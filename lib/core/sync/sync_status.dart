/// The single source of truth for "is my data safe on the server yet?".
///
/// Everything user-facing about sync — the chip in every header, the Sync
/// screen, the offline home — reads this one value.
library;

import 'package:flutter/foundation.dart';

/// Coarse sync state, in the order the user cares about.
enum SyncState {
  /// No usable network. Writes still succeed; they queue.
  offline,

  /// A push or pull is in flight right now.
  syncing,

  /// Online and idle, but the outbox is not empty — either waiting for the next
  /// cycle or blocked on failures.
  pendingChanges,

  /// Online, outbox empty. Everything on this device is on the server.
  synced,
}

/// An immutable snapshot of where sync stands.
@immutable
class SyncStatus {
  const SyncStatus({
    this.state = SyncState.synced,
    this.pendingCount = 0,
    this.failedCount = 0,
    this.lastFullSync,
  });

  /// Starting point before the first connectivity probe resolves.
  static const SyncStatus unknown = SyncStatus();

  final SyncState state;

  /// Ops queued and still retryable.
  final int pendingCount;

  /// Ops that exhausted their retries and need the user to look at them.
  final int failedCount;

  /// When the outbox was last observed empty after a successful cycle.
  final DateTime? lastFullSync;

  /// True when there is anything at all the server has not accepted.
  bool get hasUnsyncedWork => pendingCount > 0 || failedCount > 0;

  /// True when the user should be actively nudged — failures do not resolve
  /// themselves.
  bool get needsAttention => failedCount > 0;

  SyncStatus copyWith({
    SyncState? state,
    int? pendingCount,
    int? failedCount,
    DateTime? lastFullSync,
  }) {
    return SyncStatus(
      state: state ?? this.state,
      pendingCount: pendingCount ?? this.pendingCount,
      failedCount: failedCount ?? this.failedCount,
      lastFullSync: lastFullSync ?? this.lastFullSync,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is SyncStatus &&
        other.state == state &&
        other.pendingCount == pendingCount &&
        other.failedCount == failedCount &&
        other.lastFullSync == lastFullSync;
  }

  @override
  int get hashCode =>
      Object.hash(state, pendingCount, failedCount, lastFullSync);

  @override
  String toString() =>
      'SyncStatus(${state.name}, pending: $pendingCount, failed: $failedCount)';
}

/// Broadcasts [SyncStatus] to the widget tree.
///
/// A [ValueNotifier] rather than a raw stream so widgets can use
/// `ValueListenableBuilder` and always have a current value to paint on first
/// build — a chip that flickers through "unknown" on every rebuild would be
/// worse than one that is briefly stale.
class SyncStatusController extends ValueNotifier<SyncStatus> {
  SyncStatusController() : super(SyncStatus.unknown);

  bool _online = true;
  bool _busy = false;

  /// Whether the last connectivity probe succeeded.
  bool get isOnline => _online;

  /// Whether a sync cycle is currently running.
  bool get isBusy => _busy;

  /// Called by the connectivity monitor.
  void setOnline(bool online) {
    if (_online == online) return;
    _online = online;
    _recompute();
  }

  /// Called by the sync engine around a cycle.
  void setBusy(bool busy) {
    if (_busy == busy) return;
    _busy = busy;
    _recompute();
  }

  /// Called by the sync engine whenever the outbox changes size.
  void setCounts({required int pending, required int failed}) {
    if (value.pendingCount == pending && value.failedCount == failed) return;
    value = value.copyWith(pendingCount: pending, failedCount: failed);
    _recompute();
  }

  /// Records a clean cycle for the Sync screen's "last full sync" line.
  void setLastFullSync(DateTime? at) {
    if (value.lastFullSync == at) return;
    value = value.copyWith(lastFullSync: at);
  }

  void _recompute() {
    value = value.copyWith(state: _deriveState());
  }

  SyncState _deriveState() {
    // Offline outranks everything: a queued write during a dead connection is
    // the normal case, not a problem, and the chip should say so plainly.
    if (!_online) return SyncState.offline;
    if (_busy) return SyncState.syncing;
    if (value.pendingCount > 0 || value.failedCount > 0) {
      return SyncState.pendingChanges;
    }
    return SyncState.synced;
  }
}
