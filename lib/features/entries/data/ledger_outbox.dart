import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

import '../../../app/model/ledger.dart';
import 'ledger_api.dart';

/// Hive-backed queue of ledger entries that haven't been accepted by the
/// backend yet. Every write from `AddEntryScreen` goes through here first
/// so the app works offline; the sync worker drains it later.
///
/// Values are plain maps to avoid Hive typeAdapter codegen — this is a
/// tight schema owned by this file, and the outbox is short-lived data.
class LedgerOutbox {
  LedgerOutbox(this._box);
  final Box<dynamic> _box;

  static const String boxName = 'ledger_outbox_v1';
  static const _uuid = Uuid();

  static Future<LedgerOutbox> open() async {
    final box = await Hive.openBox<dynamic>(boxName);
    return LedgerOutbox(box);
  }

  /// Queues an entry for `businessId`. Returns the `clientEntryId` so the
  /// UI can render it with a "pending" chip until the sync completes.
  Future<String> enqueue({
    required int businessId,
    required LedgerEntry entry,
  }) async {
    final clientId = _uuid.v4();
    await _box.put(clientId, {
      'business_id': businessId,
      'client_entry_id': clientId,
      'kind': LedgerApiMapper.kind(entry.kind),
      'amount_inr': entry.amountInr,
      'category': LedgerApiMapper.category(entry.category),
      'recorded_at': entry.recordedAt.toUtc().toIso8601String(),
      'source': LedgerApiMapper.source(entry.source),
    });
    return clientId;
  }

  int pendingCount() => _box.length;

  /// Returns all pending payloads grouped by `business_id`, ready to POST
  /// to `/businesses/{id}/entries/sync`.
  Map<int, List<Map<String, dynamic>>> pendingByBusiness() {
    final out = <int, List<Map<String, dynamic>>>{};
    for (final v in _box.values) {
      final map = Map<String, dynamic>.from(v as Map);
      final bid = map['business_id'] as int;
      // Backend endpoint doesn't want business_id in each row.
      final payload = Map<String, dynamic>.from(map)..remove('business_id');
      out.putIfAbsent(bid, () => []).add(payload);
    }
    return out;
  }

  Future<void> removeAccepted(Iterable<String> clientEntryIds) async {
    await _box.deleteAll(clientEntryIds);
  }

  /// Wipe every queued entry — used on logout so a subsequent user's device
  /// doesn't inherit the previous account's pending writes.
  Future<void> clear() async {
    await _box.clear();
  }
}
