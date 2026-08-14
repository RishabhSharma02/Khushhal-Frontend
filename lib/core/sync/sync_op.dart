/// The vocabulary of the outbox: what kinds of writes can be queued, and the
/// in-memory shape of a queued write.
library;

import 'dart:convert';

/// Which record type an outbox op targets.
///
/// Deliberately narrow. Anything not listed here is online-only by design —
/// onboarding, OTP login and business *creation* all require a network round
/// trip and are never queued.
enum SyncEntity {
  /// A money IN/OUT row. The only entity that supports [SyncOpKind.create].
  ledgerEntry,

  /// Editable business fields: name, staff count, tenure.
  business,

  /// Name, language, location, notification toggle — everything behind
  /// `PATCH /me`.
  userProfile,

  /// The savings and loan scalars behind `PATCH /me/savings-loan`. Split from
  /// [userProfile] because it is a different endpoint with its own payload.
  savingsLoan,

  /// One plan-action checkbox on an alert.
  planAction,
}

/// What an op does to its target.
enum SyncOpKind { create, update, delete }

/// A queued write, hydrated from the `sync_ops` table.
class SyncOp {
  const SyncOp({
    required this.id,
    required this.entity,
    required this.op,
    required this.localRowId,
    required this.dedupeKey,
    required this.payload,
    required this.attempts,
    required this.createdAt,
    required this.nextAttemptAt,
    this.serverId,
    this.businessServerId,
    this.lastError,
    this.deadLettered = false,
  });

  final int id;
  final SyncEntity entity;
  final SyncOpKind op;
  final String localRowId;
  final String dedupeKey;
  final Map<String, dynamic> payload;
  final int attempts;
  final DateTime createdAt;
  final DateTime nextAttemptAt;
  final int? serverId;
  final int? businessServerId;
  final String? lastError;
  final bool deadLettered;

  /// The key two ops must share to be collapsed into one.
  static String keyFor({
    required SyncEntity entity,
    required SyncOpKind op,
    required String localRowId,
  }) => '${entity.name}:${op.name}:$localRowId';

  /// Whether this op can be retried later, as opposed to needing the user or a
  /// fresh pull to resolve it.
  bool get isRetryable => !deadLettered;
}

/// Encodes an op payload for the `payload` text column.
String encodeSyncPayload(Map<String, dynamic> payload) => jsonEncode(payload);

/// Decodes the `payload` text column, tolerating nulls and corrupt rows.
///
/// A payload that fails to parse must not wedge the whole drain, so this
/// degrades to an empty map and lets the push handler rebuild the body from the
/// current row values.
Map<String, dynamic> decodeSyncPayload(String? raw) {
  if (raw == null || raw.isEmpty) return <String, dynamic>{};
  try {
    final decoded = jsonDecode(raw);
    return decoded is Map<String, dynamic> ? decoded : <String, dynamic>{};
  } on FormatException {
    return <String, dynamic>{};
  }
}

/// Human-readable label for the Sync screen's queue rows.
extension SyncEntityLabel on SyncEntity {
  /// A short noun describing what is waiting to be sent.
  String get label => switch (this) {
    SyncEntity.ledgerEntry => 'Entry',
    SyncEntity.business => 'Business details',
    SyncEntity.userProfile => 'Profile',
    SyncEntity.savingsLoan => 'Savings & loan',
    SyncEntity.planAction => 'Plan action',
  };
}
