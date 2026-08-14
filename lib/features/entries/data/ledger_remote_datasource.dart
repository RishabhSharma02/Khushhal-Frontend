/// HTTP access to the ledger endpoints. No caching, no local state.
library;

import '../../../core/network/api_client.dart';

/// What the backend reported for one batch push.
class LedgerBatchResult {
  const LedgerBatchResult({required this.accepted, required this.duplicates});

  final int accepted;

  /// Rows the backend already had, matched on `client_entry_id`. Duplicates are
  /// a success from the client's point of view — it means an earlier attempt
  /// landed and we simply never saw the response.
  final int duplicates;

  factory LedgerBatchResult.fromJson(Map<String, dynamic> json) {
    return LedgerBatchResult(
      accepted: (json['accepted'] as int?) ?? 0,
      duplicates: (json['duplicates'] as int?) ?? 0,
    );
  }
}

/// Thin wrapper over `/api/v1/businesses/{id}/entries`.
class LedgerRemoteDataSource {
  LedgerRemoteDataSource(this._api);

  final ApiClient _api;

  /// Pushes a batch of locally-created entries. Idempotent on
  /// `client_entry_id`.
  Future<LedgerBatchResult> syncBatch({
    required int businessId,
    required List<Map<String, dynamic>> entries,
  }) async {
    final json = await _api.postJson(
      '/api/v1/businesses/$businessId/entries/sync',
      body: <String, dynamic>{'entries': entries},
    );
    return LedgerBatchResult.fromJson(json);
  }

  /// Amends an entry the server already knows about.
  Future<void> updateEntry({
    required int businessId,
    required int entryId,
    int? amountInr,
    String? categoryWire,
    DateTime? recordedAt,
  }) async {
    await _api.patchJson(
      '/api/v1/businesses/$businessId/entries/$entryId',
      body: <String, dynamic>{
        'amount_inr': ?amountInr,
        'category': ?categoryWire,
        'recorded_at': ?recordedAt?.toUtc().toIso8601String(),
      },
    );
  }

  /// Reads one page of history, newest first.
  ///
  /// Returns the raw rows rather than a decoded type because the caller writes
  /// them straight into SQLite; decoding to the domain happens on the way back
  /// out of the database.
  Future<({List<Map<String, dynamic>> items, String? nextCursor})> list({
    required int businessId,
    int limit = 200,
    int? cursor,
  }) async {
    final json = await _api.getJson(
      '/api/v1/businesses/$businessId/entries',
      query: <String, dynamic>{'limit': limit, 'cursor': ?cursor},
    );
    final items = (json['items'] as List<dynamic>? ?? const <dynamic>[])
        .cast<Map<String, dynamic>>();
    return (items: items, nextCursor: json['next_cursor'] as String?);
  }
}
