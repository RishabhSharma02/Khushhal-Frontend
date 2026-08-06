/// Maps semantic model enums to their localized copy.
///
/// State stores enums (see `model/`); screens resolve display text here so a
/// language switch in Settings re-renders everything, stored data included.
library;

import '../l10n/app_localizations.dart';
import 'model/business.dart';
import 'model/ledger.dart';

/// Copy for [BusinessSegment] (design 1k).
extension BusinessSegmentLabels on BusinessSegment {
  /// Chip label.
  String label(AppLocalizations l10n) {
    return switch (this) {
      BusinessSegment.shg => l10n.segmentShg,
      BusinessSegment.fpo => l10n.segmentFpo,
      BusinessSegment.own => l10n.segmentOwn,
    };
  }
}

/// Copy for [BusinessSector] (designs 1k, 1x).
extension BusinessSectorLabels on BusinessSector {
  /// Chip / subtitle label.
  String label(AppLocalizations l10n) {
    return switch (this) {
      BusinessSector.dairy => l10n.sectorDairy,
      BusinessSector.poultry => l10n.sectorPoultry,
      BusinessSector.foodProcessing => l10n.sectorFoodProcessing,
      BusinessSector.crafts => l10n.sectorCrafts,
      BusinessSector.shop => l10n.sectorShop,
      BusinessSector.other => l10n.sectorOther,
    };
  }
}

/// Copy for [BusinessTenure] (design 1l).
extension BusinessTenureLabels on BusinessTenure {
  /// Chip label.
  String label(AppLocalizations l10n) {
    return switch (this) {
      BusinessTenure.underOneYear => l10n.tenureUnderOneYear,
      BusinessTenure.oneToThreeYears => l10n.tenureOneToThree,
      BusinessTenure.threeToTenYears => l10n.tenureThreeToTen,
      BusinessTenure.tenPlus => l10n.tenureTenPlus,
    };
  }
}

/// Copy for [EntryCategory] (designs 1p, 1v, 1w).
extension EntryCategoryLabels on EntryCategory {
  /// Chip / list label.
  String label(AppLocalizations l10n) {
    return switch (this) {
      EntryCategory.milkSale => l10n.categoryMilkSale,
      EntryCategory.fodder => l10n.categoryFodder,
      EntryCategory.vet => l10n.categoryVet,
      EntryCategory.emi => l10n.categoryEmi,
      EntryCategory.other => l10n.categoryOther,
    };
  }
}
