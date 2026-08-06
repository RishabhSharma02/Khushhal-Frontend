/// What the guided setup (designs 1h–1n) learns about each business.
library;

import 'package:flutter/foundation.dart';

/// Who runs the business — "I am a…" on design 1k.
enum BusinessSegment {
  /// Self-help group.
  shg,

  /// Farmer producer organisation.
  fpo,

  /// Sole owner.
  own,
}

/// The line of work — "My work is…" on design 1k.
///
/// Picking a sector silently loads that sector's seasonality and commodity
/// model, so it doubles as the forecast's starting point.
enum BusinessSector { dairy, poultry, foodProcessing, crafts, shop, other }

/// "Running since" chips on design 1l.
enum BusinessTenure { underOneYear, oneToThreeYears, threeToTenYears, tenPlus }

/// Where the monthly numbers came from on design 1m/1n.
enum MoneyBasis {
  /// Slider guesses — held loosely by the model.
  roughEstimate,

  /// Typed from the owner's own diary — weighted higher.
  fromRecords,
}

/// The four monthly numbers collected on design 1m/1n, in whole rupees.
@immutable
class MonthlyMoney {
  /// Creates a monthly snapshot.
  const MonthlyMoney({
    required this.moneyIn,
    required this.moneyOut,
    required this.loanEmi,
    required this.savings,
    required this.basis,
  });

  /// Sales in a typical month.
  final int moneyIn;

  /// Costs in a typical month.
  final int moneyOut;

  /// Monthly loan repayment.
  final int loanEmi;

  /// Savings on hand today.
  final int savings;

  /// How these numbers were given.
  final MoneyBasis basis;
}

/// One fully set-up business.
@immutable
class Business {
  /// Creates a business record.
  const Business({
    required this.name,
    required this.segment,
    required this.sector,
    required this.tenure,
    required this.staffCount,
    required this.monthly,
  });

  /// Name typed on design 1l — the only typing in the whole setup.
  final String name;

  /// Who runs it.
  final BusinessSegment segment;

  /// Line of work.
  final BusinessSector sector;

  /// How long it has been running.
  final BusinessTenure tenure;

  /// People working, including the owner.
  final int staffCount;

  /// The monthly money picture from setup.
  final MonthlyMoney monthly;
}
