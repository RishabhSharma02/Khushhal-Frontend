/// Model output shown on home, the monthly update, forecast and alerts
/// (designs 1o–1s).
///
/// Everything here is semantic — enums and numbers, never display strings —
/// so the language can switch in Settings without touching stored state.
/// Screens resolve the text through `AppLocalizations`.
library;

import 'package:flutter/foundation.dart';

/// Risk band on the health card.
enum RiskLevel { low, medium, high }

/// The monthly health score, stamped like a credit score.
///
/// It moves only on the 1st of the month; daily entries feed the next one.
@immutable
class HealthSnapshot {
  /// Creates a score snapshot.
  const HealthSnapshot({
    required this.score,
    required this.asOn,
    required this.nextUpdate,
    required this.risk,
    required this.daysWritten,
    required this.daysInMonth,
    this.delta,
  });

  /// 0–100.
  final int score;

  /// The 1st the score was stamped on.
  final DateTime asOn;

  /// When the next score arrives.
  final DateTime nextUpdate;

  /// Risk band.
  final RiskLevel risk;

  /// Entry days recorded so far this month.
  final int daysWritten;

  /// Days in the running month.
  final int daysInMonth;

  /// Change against the previous month, when this snapshot is fresh.
  final int? delta;
}

/// One "why it moved" line on the monthly update (1q2).
enum ScoreReason { milkIncomeRose, steadyEntries, fodderCostUp }

/// Whether a reason pushed the score up or held it back.
extension ScoreReasonDirection on ScoreReason {
  /// True when the reason helped the score.
  bool get isPositive => this != ScoreReason.fodderCostUp;
}

/// One bar pair of the six-month forecast chart (1q).
@immutable
class ForecastMonth {
  /// Creates a month of the forecast.
  const ForecastMonth({
    required this.month,
    required this.inLevel,
    required this.outLevel,
    this.isRiskMonth = false,
  });

  /// First day of the month shown.
  final DateTime month;

  /// Money IN as a fraction of the chart height, 0–1.
  final double inLevel;

  /// Money OUT as a fraction of the chart height, 0–1.
  final double outLevel;

  /// True for the month the model flags — outlined amber on the chart.
  final bool isRiskMonth;
}

/// Reads across the rolling six-month forecast window.
extension ForecastWindow on List<ForecastMonth> {
  /// The first month the model actually flagged, ignoring months that have
  /// already passed; null when nothing in the window is flagged.
  ///
  /// The window is stamped on the 1st and then sits still for a month, so a
  /// flagged month can drift into the past — surfacing it would tell the
  /// owner to watch out for a month they have already lived through. There
  /// is deliberately no "otherwise take the last month" fallback either:
  /// every screen that shows a month name has to be able to say "nothing
  /// flagged" instead of naming a month the model never picked.
  ForecastMonth? get flaggedRiskMonth {
    final DateTime now = DateTime.now();
    final DateTime currentMonth = DateTime(now.year, now.month, 1);

    for (final ForecastMonth month in this) {
      if (month.isRiskMonth && !month.month.isBefore(currentMonth)) {
        return month;
      }
    }
    return null;
  }
}

/// Severity of a risk alert (1r).
enum AlertSeverity {
  /// Needs action — amber card, pinned on top.
  urgent,

  /// Good to know.
  info,
}

/// The alerts the demo model raises (1r).
enum AlertKind { savingsRunningLow, fodderPriceUp, heavyRain }

/// One alert in the list.
@immutable
class RiskAlert {
  /// Creates an alert.
  const RiskAlert({
    required this.kind,
    required this.severity,
    this.raisedOn,
    this.hasPlan = false,
    this.backendId,
  });

  /// Which alert this is; the screens map it to copy.
  final AlertKind kind;

  /// How loudly it is shown.
  final AlertSeverity severity;

  /// When it was raised; null for undated feeds (weather department).
  final DateTime? raisedOn;

  /// True when tapping it opens the three-action plan (1s).
  final bool hasPlan;

  /// Server id for this alert. Null for demo data and legacy alerts that
  /// never hit `/alerts` — the detail screen falls back to the first live
  /// alert when this is missing.
  final int? backendId;
}

/// The three plan actions on the alert detail (1s).
enum PlanActionKind { buyFodderEarly, weeklySetAside, moveEmiDate }

/// One action of the plan, with its done state.
@immutable
class PlanAction {
  /// Creates a plan action.
  const PlanAction({required this.kind, this.done = false});

  /// Which action this is; the screens map it to copy.
  final PlanActionKind kind;

  /// Marked done by the user — re-runs the local forecast.
  final bool done;

  /// A copy with [done] flipped to [value].
  PlanAction withDone(bool value) => PlanAction(kind: kind, done: value);
}
