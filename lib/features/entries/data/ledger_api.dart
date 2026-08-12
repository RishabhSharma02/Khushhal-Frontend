import '../../../app/model/ledger.dart';

class LedgerApiMapper {
  static String kind(EntryKind k) => switch (k) {
        EntryKind.moneyIn => 'in',
        EntryKind.moneyOut => 'out',
      };

  static String category(EntryCategory c) => switch (c) {
        EntryCategory.milkSale => 'milk_sale',
        EntryCategory.fodder => 'fodder',
        EntryCategory.vet => 'vet',
        EntryCategory.emi => 'emi',
        EntryCategory.other => 'other',
      };

  static String source(EntrySource s) => switch (s) {
        EntrySource.manual => 'manual',
        EntrySource.voice => 'voice',
      };

  // Reverse mappers — used when decoding rows from GET /entries.

  static EntryKind kindFromWire(String s) => switch (s) {
        'in' => EntryKind.moneyIn,
        _ => EntryKind.moneyOut,
      };

  static EntryCategory categoryFromWire(String s) => switch (s) {
        'milk_sale' => EntryCategory.milkSale,
        'fodder' => EntryCategory.fodder,
        'vet' => EntryCategory.vet,
        'emi' => EntryCategory.emi,
        _ => EntryCategory.other,
      };

  static EntrySource sourceFromWire(String s) =>
      s == 'voice' ? EntrySource.voice : EntrySource.manual;
}

extension RemoteLedgerEntry on Map<String, dynamic> {
  /// Decode a `GET /businesses/{id}/entries` row into the domain type.
  LedgerEntry toLedgerEntry() {
    return LedgerEntry(
      kind: LedgerApiMapper.kindFromWire(this['kind'] as String),
      amountInr: this['amount_inr'] as int,
      category: LedgerApiMapper.categoryFromWire(this['category'] as String),
      recordedAt: DateTime.parse(this['recorded_at'] as String),
      source: LedgerApiMapper.sourceFromWire(this['source'] as String),
      syncState: EntrySyncState.synced,
      backendId: this['id'] as int?,
    );
  }
}
