/// Stand-in model output while there is no backend.
///
/// Numbers and dates mirror the approved design mocks (Shanti Dairy, October
/// 2026) so every screen renders exactly the scenario that was signed off.
/// Dates are pinned — nothing here reads the real clock, which keeps tests
/// and screenshots deterministic.
library;

import 'model/business.dart';
import 'model/insights.dart';
import 'model/ledger.dart';

/// The demo scenario: Sunita Devi's dairy, late October 2026.
abstract final class DemoData {
  /// The scenario's "today".
  static final DateTime today = DateTime(2026, 10, 22);

  /// Owner shown on Settings (no login flow in this build).
  static const String ownerName = 'Sunita Devi';

  /// Owner's number shown on Settings.
  static const String ownerPhone = '+91 98765 43210';

  /// Month totals so far, as on [today], in whole rupees.
  static const int monthMoneyIn = 43750;

  /// Costs so far this month.
  static const int monthMoneyOut = 38550;

  /// Loan repaid this month.
  static const int monthLoanPaid = 8000;

  /// Savings balance.
  static const int savings = 41200;

  /// Outstanding loan.
  static const int loan = 86000;

  /// The stamped score the month runs on.
  static final HealthSnapshot currentHealth = HealthSnapshot(
    score: 72,
    asOn: DateTime(2026, 10, 1),
    nextUpdate: DateTime(2026, 11, 1),
    risk: RiskLevel.low,
    daysWritten: 22,
    daysInMonth: 31,
  );

  /// The fresh score waiting behind the "month closed" banner (1o2).
  static final HealthSnapshot pendingHealth = HealthSnapshot(
    score: 76,
    delta: 4,
    asOn: DateTime(2026, 11, 1),
    nextUpdate: DateTime(2026, 12, 1),
    risk: RiskLevel.low,
    daysWritten: 0,
    daysInMonth: 30,
  );

  /// Score history bars on the monthly update (1q2), oldest first.
  ///
  /// The last value is [pendingHealth]'s score.
  static final List<(DateTime, int)> scoreHistory = <(DateTime, int)>[
    (DateTime(2026, 6, 1), 60),
    (DateTime(2026, 7, 1), 58),
    (DateTime(2026, 8, 1), 66),
    (DateTime(2026, 9, 1), 64),
    (DateTime(2026, 10, 1), 72),
    (DateTime(2026, 11, 1), 76),
  ];

  /// Why the score moved (1q2) — two up, one down, so it never feels
  /// arbitrary.
  static const List<ScoreReason> scoreReasons = <ScoreReason>[
    ScoreReason.milkIncomeRose,
    ScoreReason.steadyEntries,
    ScoreReason.fodderCostUp,
  ];

  /// The six-month forecast (1q): three months of history, the flagged risk
  /// month, then two recovering months.
  static final List<ForecastMonth> forecast = <ForecastMonth>[
    ForecastMonth(month: DateTime(2026, 8, 1), inLevel: .60, outLevel: .50),
    ForecastMonth(month: DateTime(2026, 9, 1), inLevel: .65, outLevel: .52),
    ForecastMonth(month: DateTime(2026, 10, 1), inLevel: .75, outLevel: .55),
    ForecastMonth(
      month: DateTime(2026, 11, 1),
      inLevel: .40,
      outLevel: .62,
      isRiskMonth: true,
    ),
    ForecastMonth(month: DateTime(2026, 12, 1), inLevel: .80, outLevel: .56),
    ForecastMonth(month: DateTime(2027, 1, 1), inLevel: .85, outLevel: .58),
  ];

  /// Savings the forecast expects November to bottom out at.
  static const int forecastSavingsFloor = 9000;

  /// Savings today as the tight-month copy rounds it (1s).
  static const int tightMonthSavingsFrom = 41000;

  /// Where savings hold if plan actions 1 and 2 get done (1s).
  static const int actionsSavingsFloor = 17000;

  /// Rupees saved by buying fodder early (1s, action 1).
  static const int fodderActionBenefit = 2500;

  /// Weekly set-aside amount (1s, action 2).
  static const int weeklySetAside = 500;

  /// Buffer the weekly set-aside builds by November (1s, action 2).
  static const int weeklySetAsideBuffer = 6000;

  /// The alert list (1r) — one urgent with a plan, two informational.
  static final List<RiskAlert> alerts = <RiskAlert>[
    RiskAlert(
      kind: AlertKind.savingsRunningLow,
      severity: AlertSeverity.urgent,
      raisedOn: DateTime(2026, 10, 12),
      hasPlan: true,
    ),
    RiskAlert(
      kind: AlertKind.fodderPriceUp,
      severity: AlertSeverity.info,
      raisedOn: DateTime(2026, 10, 10),
    ),
    const RiskAlert(kind: AlertKind.heavyRain, severity: AlertSeverity.info),
  ];

  /// The three-action November plan (1s).
  static const List<PlanAction> planActions = <PlanAction>[
    PlanAction(kind: PlanActionKind.buyFodderEarly),
    PlanAction(kind: PlanActionKind.weeklySetAside),
    PlanAction(kind: PlanActionKind.moveEmiDate),
  ];

  /// Recent ledger entries (1v): two today, two yesterday.
  static final List<LedgerEntry> entries = <LedgerEntry>[
    LedgerEntry(
      kind: EntryKind.moneyIn,
      amountInr: 1850,
      category: EntryCategory.milkSale,
      recordedAt: DateTime(2026, 10, 22, 9, 30),
      source: EntrySource.voice,
    ),
    LedgerEntry(
      kind: EntryKind.moneyOut,
      amountInr: 600,
      category: EntryCategory.fodder,
      recordedAt: DateTime(2026, 10, 22, 8, 10),
      syncState: EntrySyncState.pending,
    ),
    LedgerEntry(
      kind: EntryKind.moneyIn,
      amountInr: 1700,
      category: EntryCategory.milkSale,
      recordedAt: DateTime(2026, 10, 21, 9, 45),
    ),
    LedgerEntry(
      kind: EntryKind.moneyOut,
      amountInr: 8000,
      category: EntryCategory.emi,
      recordedAt: DateTime(2026, 10, 21, 11, 0),
    ),
  ];

  /// When the last full sync finished (1w).
  static final DateTime lastFullSync = DateTime(2026, 10, 20, 16, 10);

  /// How stale the cached mandi prices are when offline (1u), in days.
  static const int mandiStaleDays = 2;

  /// How much milk income rose over September (1q2, reason 1), in rupees.
  static const int milkIncomeRise = 4200;

  /// Entry days written in the closed month (1q2, reason 2).
  static const int closedMonthDaysWritten = 28;

  /// Days in the closed month (1q2, reason 2).
  static const int closedMonthDays = 31;

  /// How much fodder cost rose in the closed month (1q2, reason 3).
  static const int fodderCostRise = 1900;

  /// The business the demo session starts with.
  static const Business business = Business(
    name: 'Shanti Dairy Farm',
    segment: BusinessSegment.shg,
    sector: BusinessSector.dairy,
    tenure: BusinessTenure.threeToTenYears,
    staffCount: 4,
    monthly: MonthlyMoney(
      moneyIn: 45000,
      moneyOut: 30000,
      loanEmi: 8000,
      savings: 40000,
      basis: MoneyBasis.roughEstimate,
    ),
  );
}
