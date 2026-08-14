/// Daily money entries (designs 1p and 1v).
library;

import 'package:flutter/foundation.dart';

/// Direction of an entry — the first of the three taps on design 1p.
enum EntryKind {
  /// Money coming in.
  moneyIn,

  /// Money going out.
  moneyOut,
}

/// Category chips on design 1p.
///
/// Fixed for now; a real backend would tailor these to the business sector.
enum EntryCategory { milkSale, fodder, vet, emi, other }

/// How an entry was recorded — shown as metadata on design 1v.
enum EntrySource {
  /// Typed into the app.
  manual,

  /// Spoken; transcribed on-device.
  voice,
}

/// Whether an entry has reached the server yet.
enum EntrySyncState {
  /// Safely on the server.
  synced,

  /// On its way now.
  sending,

  /// Saved on the phone, waiting for network.
  pending,
}

/// One IN/OUT entry in the ledger.
@immutable
class LedgerEntry {
  /// Creates an entry.
  const LedgerEntry({
    required this.kind,
    required this.amountInr,
    required this.category,
    required this.recordedAt,
    this.source = EntrySource.manual,
    this.syncState = EntrySyncState.synced,
    this.backendId,
    this.clientId,
  });

  /// Direction.
  final EntryKind kind;

  /// Whole rupees, always positive; [kind] carries the sign.
  final int amountInr;

  /// What it was for.
  final EntryCategory category;

  /// When it was written.
  final DateTime recordedAt;

  /// How it was recorded.
  final EntrySource source;

  /// Sync status.
  final EntrySyncState syncState;

  /// Server-side id if this entry has been persisted. Null for
  /// offline-only rows that haven't reached `/entries` yet.
  final int? backendId;

  /// Client-generated UUID — the same value the backend stores as
  /// `client_entry_id` and the local database uses as its primary key.
  ///
  /// This is the only stable handle an entry has while it is offline, so it is
  /// what the edit path addresses a row by. [backendId] is null until the
  /// entry has been through a sync cycle.
  final String? clientId;

  /// A copy with a different sync status.
  LedgerEntry withSyncState(EntrySyncState state) {
    return LedgerEntry(
      kind: kind,
      amountInr: amountInr,
      category: category,
      recordedAt: recordedAt,
      source: source,
      syncState: state,
      backendId: backendId,
      clientId: clientId,
    );
  }
}
