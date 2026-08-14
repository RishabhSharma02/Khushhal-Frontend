/// A device's sync health, feeding the Data sync screen (Officer Portal 5f).
library;

import 'package:flutter/foundation.dart';

/// What an officer can do about one stale device, per row.
enum SyncActionKind {
  /// Call the owner directly.
  call,

  /// Add the enterprise to the visit route.
  addToRoute,

  /// Send a re-login link (likely a phone change).
  resendLogin,
}

/// One row in the Data sync screen's stale-device table.
@immutable
class DeviceSyncStatus {
  /// Creates a sync status row.
  const DeviceSyncStatus({
    required this.enterpriseId,
    required this.enterpriseName,
    required this.village,
    required this.lastSyncDays,
    required this.lastEntryDays,
    required this.pendingEstimateLabel,
    required this.likelyCause,
    required this.actionKind,
    required this.actionLabel,
  });

  /// The enterprise this device belongs to.
  final String enterpriseId;

  /// Denormalised for the table row.
  final String enterpriseName;

  /// Denormalised village for the table row.
  final String village;

  /// Days since the device last synced.
  final int lastSyncDays;

  /// Days since the last on-device entry (may differ from sync — a device
  /// can sync fine while the owner has stopped entering).
  final int lastEntryDays;

  /// Rough count of pending entries, e.g. "~14 entries" or "unknown".
  final String pendingEstimateLabel;

  /// A short guess at why it's stale, shown as-is.
  final String likelyCause;

  /// Which remedy this row's button performs.
  final SyncActionKind actionKind;

  /// The button's label, e.g. "📞 Call".
  final String actionLabel;
}
