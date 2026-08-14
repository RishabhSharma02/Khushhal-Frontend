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
    this.month,
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

  /// First day of the month these numbers describe. Null for a snapshot the
  /// setup wizard has only just collected and the server has not echoed back
  /// with a month yet.
  final DateTime? month;

  /// True when there is a figure worth showing as the baseline behind a live
  /// month-to-date total.
  bool get hasBaseline => moneyIn > 0 || moneyOut > 0;
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
    this.savingsInr = 0,
    this.loanInr = 0,
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

  /// Savings held for this business, in whole rupees. Editable on the savings
  /// & loan screen; seeded from [monthly] at setup.
  final int savingsInr;

  /// Loan outstanding for this business, in whole rupees. Setup asks for a
  /// monthly EMI rather than a balance, so this starts at zero and the owner
  /// fills it in later.
  final int loanInr;

  /// A copy with the fields Settings' edit sheet can change replaced.
  ///
  /// Segment and sector are deliberately absent: changing either invalidates
  /// every stamped health score, so they stay locked after setup.
  Business copyWith({
    String? name,
    BusinessTenure? tenure,
    int? staffCount,
    MonthlyMoney? monthly,
    int? savingsInr,
    int? loanInr,
  }) {
    return Business(
      name: name ?? this.name,
      segment: segment,
      sector: sector,
      tenure: tenure ?? this.tenure,
      staffCount: staffCount ?? this.staffCount,
      monthly: monthly ?? this.monthly,
      savingsInr: savingsInr ?? this.savingsInr,
      loanInr: loanInr ?? this.loanInr,
    );
  }
}
