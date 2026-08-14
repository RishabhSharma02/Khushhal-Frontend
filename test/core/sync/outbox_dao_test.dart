import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:khushhal/core/db/app_database.dart';
import 'package:khushhal/core/sync/outbox_dao.dart';
import 'package:khushhal/core/sync/sync_op.dart';

void main() {
  late AppDatabase db;
  late OutboxDao outbox;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    outbox = OutboxDao(db);
  });

  tearDown(() => db.close());

  Future<List<SyncOpRow>> queue() => outbox.claimReady();

  group('coalescing', () {
    test('folds an update into a create that has not been sent', () async {
      final int createId = await outbox.enqueue(
        entity: SyncEntity.ledgerEntry,
        op: SyncOpKind.create,
        localRowId: 'row-1',
        payload: <String, dynamic>{'amount_inr': 100, 'category': 'sales'},
      );

      final int updateId = await outbox.enqueue(
        entity: SyncEntity.ledgerEntry,
        op: SyncOpKind.update,
        localRowId: 'row-1',
        payload: <String, dynamic>{'amount_inr': 250},
      );

      expect(updateId, createId, reason: 'the edit reuses the create op');

      final List<SyncOpRow> ops = await queue();
      expect(ops, hasLength(1));
      expect(ops.single.op, SyncOpKind.create);
      expect(decodeSyncPayload(ops.single.payload), <String, dynamic>{
        'amount_inr': 250,
        'category': 'sales',
      });
    });

    test('merges repeat updates field by field, newest winning', () async {
      await outbox.enqueue(
        entity: SyncEntity.business,
        op: SyncOpKind.update,
        localRowId: 'biz-1',
        payload: <String, dynamic>{'name': 'Chai stall', 'staff_count': 2},
      );
      await outbox.enqueue(
        entity: SyncEntity.business,
        op: SyncOpKind.update,
        localRowId: 'biz-1',
        payload: <String, dynamic>{'staff_count': 5},
      );

      final List<SyncOpRow> ops = await queue();
      expect(ops, hasLength(1));
      expect(decodeSyncPayload(ops.single.payload), <String, dynamic>{
        'name': 'Chai stall',
        'staff_count': 5,
      });
    });

    test('a delete cancels a create that never left the device', () async {
      await outbox.enqueue(
        entity: SyncEntity.business,
        op: SyncOpKind.create,
        localRowId: 'biz-2',
      );
      await outbox.enqueue(
        entity: SyncEntity.business,
        op: SyncOpKind.delete,
        localRowId: 'biz-2',
      );

      expect(await queue(), isEmpty);
    });

    test('rows of different entities never collapse together', () async {
      await outbox.enqueue(
        entity: SyncEntity.userProfile,
        op: SyncOpKind.update,
        localRowId: 'same-id',
        payload: <String, dynamic>{'name': 'Asha'},
      );
      await outbox.enqueue(
        entity: SyncEntity.savingsLoan,
        op: SyncOpKind.update,
        localRowId: 'same-id',
        payload: <String, dynamic>{'savings_inr': 900},
      );

      expect(await queue(), hasLength(2));
    });

    test('coalescing keeps the original queue position', () async {
      await outbox.enqueue(
        entity: SyncEntity.business,
        op: SyncOpKind.update,
        localRowId: 'biz-1',
        payload: <String, dynamic>{'name': 'first'},
      );
      await outbox.enqueue(
        entity: SyncEntity.userProfile,
        op: SyncOpKind.update,
        localRowId: 'me',
        payload: <String, dynamic>{'name': 'Asha'},
      );
      await outbox.enqueue(
        entity: SyncEntity.business,
        op: SyncOpKind.update,
        localRowId: 'biz-1',
        payload: <String, dynamic>{'name': 'second'},
      );

      final List<SyncOpRow> ops = await queue();
      expect(
        ops.map((SyncOpRow o) => o.entity).toList(),
        <SyncEntity>[SyncEntity.business, SyncEntity.userProfile],
      );
    });
  });

  group('draining', () {
    test('claimReady returns ops oldest first', () async {
      for (int i = 0; i < 3; i++) {
        await outbox.enqueue(
          entity: SyncEntity.ledgerEntry,
          op: SyncOpKind.create,
          localRowId: 'row-$i',
        );
      }

      final List<SyncOpRow> ops = await queue();
      expect(
        ops.map((SyncOpRow o) => o.localRowId).toList(),
        <String>['row-0', 'row-1', 'row-2'],
      );
    });

    test('a completed op leaves the queue', () async {
      await outbox.enqueue(
        entity: SyncEntity.ledgerEntry,
        op: SyncOpKind.create,
        localRowId: 'row-1',
      );
      final SyncOpRow op = (await queue()).single;

      expect(await outbox.completeIfUnchanged(op), isTrue);
      expect(await queue(), isEmpty);
    });

    test('an edit made mid-flight survives the ack of the old value', () async {
      await outbox.enqueue(
        entity: SyncEntity.business,
        op: SyncOpKind.update,
        localRowId: 'biz-1',
        payload: <String, dynamic>{'name': 'old'},
      );
      final SyncOpRow claimed = (await queue()).single;

      // The user edits again while the request is in flight.
      await outbox.enqueue(
        entity: SyncEntity.business,
        op: SyncOpKind.update,
        localRowId: 'biz-1',
        payload: <String, dynamic>{'name': 'new'},
      );

      expect(await outbox.completeIfUnchanged(claimed), isFalse);

      final List<SyncOpRow> remaining = await queue();
      expect(remaining, hasLength(1));
      expect(decodeSyncPayload(remaining.single.payload)['name'], 'new');
    });
  });

  group('failure handling', () {
    test('a retryable failure backs off and stays in the queue', () async {
      await outbox.enqueue(
        entity: SyncEntity.ledgerEntry,
        op: SyncOpKind.create,
        localRowId: 'row-1',
      );
      final SyncOpRow op = (await queue()).single;

      await outbox.recordFailure(op, error: 'timeout', retryable: true);

      expect(await queue(), isEmpty, reason: 'inside the backoff window');
      expect(await outbox.pendingCount(), 1);
      expect(await outbox.failedCount(), 0);
    });

    test('backoff grows with attempts and is capped', () {
      expect(OutboxDao.backoffFor(1), const Duration(seconds: 5));
      expect(OutboxDao.backoffFor(2), const Duration(seconds: 10));
      expect(OutboxDao.backoffFor(3), const Duration(seconds: 20));
      expect(OutboxDao.backoffFor(99), const Duration(minutes: 10));
    });

    test('a rejection dead-letters immediately', () async {
      await outbox.enqueue(
        entity: SyncEntity.business,
        op: SyncOpKind.update,
        localRowId: 'biz-1',
      );
      final SyncOpRow op = (await queue()).single;

      await outbox.recordFailure(op, error: '422', retryable: false);

      expect(await outbox.failedCount(), 1);
      expect(await outbox.pendingCount(), 0);
      expect(await queue(), isEmpty);
    });

    test('retries give up after kMaxSyncAttempts', () async {
      await outbox.enqueue(
        entity: SyncEntity.business,
        op: SyncOpKind.update,
        localRowId: 'biz-1',
      );

      for (int i = 0; i < kMaxSyncAttempts; i++) {
        final SyncOpRow op = await _onlyOp(db);
        await outbox.recordFailure(op, error: 'boom', retryable: true);
      }

      expect(await outbox.failedCount(), 1);
    });

    test('retryFailed makes a dead-lettered op due again', () async {
      await outbox.enqueue(
        entity: SyncEntity.business,
        op: SyncOpKind.update,
        localRowId: 'biz-1',
      );
      await outbox.recordFailure(
        await _onlyOp(db),
        error: '500',
        retryable: false,
      );

      await outbox.retryFailed();

      final List<SyncOpRow> ops = await queue();
      expect(ops, hasLength(1));
      expect(ops.single.attempts, 0);
      expect(ops.single.lastError, isNull);
    });

    test('a fresh edit clears the backoff earned by the old value', () async {
      await outbox.enqueue(
        entity: SyncEntity.business,
        op: SyncOpKind.update,
        localRowId: 'biz-1',
        payload: <String, dynamic>{'name': 'old'},
      );
      await outbox.recordFailure(
        await _onlyOp(db),
        error: 'timeout',
        retryable: true,
      );
      expect(await queue(), isEmpty);

      await outbox.enqueue(
        entity: SyncEntity.business,
        op: SyncOpKind.update,
        localRowId: 'biz-1',
        payload: <String, dynamic>{'name': 'new'},
      );

      expect(await queue(), hasLength(1));
    });
  });

  group('bookkeeping', () {
    test('pendingRowIds reports rows the pull must not overwrite', () async {
      await outbox.enqueue(
        entity: SyncEntity.ledgerEntry,
        op: SyncOpKind.create,
        localRowId: 'row-1',
      );
      await outbox.enqueue(
        entity: SyncEntity.business,
        op: SyncOpKind.update,
        localRowId: 'biz-1',
      );

      expect(
        await outbox.pendingRowIds(SyncEntity.ledgerEntry),
        <String>{'row-1'},
      );
    });

    test('discard drops a single op', () async {
      final int id = await outbox.enqueue(
        entity: SyncEntity.business,
        op: SyncOpKind.update,
        localRowId: 'biz-1',
      );

      await outbox.discard(id);

      expect(await queue(), isEmpty);
    });

    test('clear empties the queue for logout', () async {
      await outbox.enqueue(
        entity: SyncEntity.business,
        op: SyncOpKind.update,
        localRowId: 'biz-1',
      );
      await outbox.enqueue(
        entity: SyncEntity.ledgerEntry,
        op: SyncOpKind.create,
        localRowId: 'row-1',
      );

      await outbox.clear();

      expect(await outbox.pendingCount(), 0);
      expect(await outbox.failedCount(), 0);
    });
  });
}

/// The single queued op, ignoring backoff — `claimReady` hides ops that are
/// waiting, which is exactly what the retry tests need to look past.
Future<SyncOpRow> _onlyOp(AppDatabase db) async {
  final List<SyncOpRow> rows = await db.select(db.syncOps).get();
  return rows.single;
}
