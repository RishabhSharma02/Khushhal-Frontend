import 'dart:async';

import '../../../app/model/ledger.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_exception.dart';
import 'ledger_outbox.dart';

class SyncOutcome {
  const SyncOutcome({required this.accepted, required this.duplicates, required this.stillPending});
  final int accepted;
  final int duplicates;
  final int stillPending;

  bool get isClean => stillPending == 0;
}

/// Writes ledger entries to a local Hive outbox first, then attempts to flush
/// them to `/api/v1/businesses/{id}/entries/sync`. The `client_entry_id`
/// UUID makes retries safe: the backend uses `ON CONFLICT DO NOTHING`.
class LedgerRepository {
  LedgerRepository({required ApiClient apiClient, required LedgerOutbox outbox})
      : _api = apiClient,
        _outbox = outbox;

  final ApiClient _api;
  final LedgerOutbox _outbox;

  int get pendingCount => _outbox.pendingCount();

  /// Called from AddEntryScreen. Enqueues + tries to sync opportunistically.
  /// Returns whether the sync succeeded; if it didn't, the entry stays in
  /// the outbox for the next drain.
  Future<bool> submit({required int businessId, required LedgerEntry entry}) async {
    await _outbox.enqueue(businessId: businessId, entry: entry);
    try {
      final outcome = await syncAll();
      return outcome.isClean;
    } on ApiException {
      return false;
    }
  }

  /// Drains every pending entry across every business. Groups per business
  /// so the batch endpoint sees a homogeneous list.
  Future<SyncOutcome> syncAll() async {
    final grouped = _outbox.pendingByBusiness();
    if (grouped.isEmpty) {
      return const SyncOutcome(accepted: 0, duplicates: 0, stillPending: 0);
    }

    int totalAccepted = 0;
    int totalDuplicates = 0;
    final drained = <String>[];

    for (final entry in grouped.entries) {
      final businessId = entry.key;
      final payloads = entry.value;
      try {
        final resp = await _api.postJson(
          '/api/v1/businesses/$businessId/entries/sync',
          body: {'entries': payloads},
        );
        totalAccepted += (resp['accepted'] as int?) ?? 0;
        totalDuplicates += (resp['duplicates'] as int?) ?? 0;
        // The backend treats duplicates as accepted-for-clearance; either
        // way, we can drop the client rows.
        drained.addAll(payloads.map((p) => p['client_entry_id'] as String));
      } on ApiException {
        // Leave this business's payloads in the outbox for the next try.
      }
    }

    await _outbox.removeAccepted(drained);

    return SyncOutcome(
      accepted: totalAccepted,
      duplicates: totalDuplicates,
      stillPending: _outbox.pendingCount(),
    );
  }

  /// Read-side helper for HistoryScreen — thin passthrough that maps the
  /// backend rows into the domain [LedgerEntry] shape.
  Future<List<Map<String, dynamic>>> history(int businessId, {int limit = 50, int? cursor}) async {
    final resp = await _api.getJson(
      '/api/v1/businesses/$businessId/entries',
      query: {'limit': limit, 'cursor': ?cursor},
    );
    return (resp['items'] as List<dynamic>).cast<Map<String, dynamic>>();
  }
}
