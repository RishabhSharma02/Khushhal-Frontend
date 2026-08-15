/// The monthly rollups shown on the Reports screen (Officer Portal 5e).
library;

import 'package:flutter/foundation.dart';

/// One sector's average health score row on the Reports screen.
@immutable
class SectorScore {
  /// Creates a sector score row.
  const SectorScore({
    required this.icon,
    required this.label,
    required this.enterpriseCount,
    required this.averageScore,
  });

  /// The sector's emoji.
  final String icon;

  /// Sector name, e.g. "Dairy".
  final String label;

  /// How many enterprises make up this average.
  final int enterpriseCount;

  /// Average health score, 0–100.
  final int averageScore;
}

/// How well the AI's forecasts held up last month.
@immutable
class ForecastAccuracy {
  /// Creates a forecast-accuracy summary.
  const ForecastAccuracy({
    required this.predictedVsActualLabel,
    required this.flagsThatCameTrue,
    required this.flagsRaised,
    required this.falseAlarms,
  });

  /// e.g. "±9%".
  final String predictedVsActualLabel;

  /// How many raised flags actually happened.
  final int flagsThatCameTrue;

  /// How many flags were raised in total.
  final int flagsRaised;

  /// Flags that didn't pan out.
  final int falseAlarms;
}

/// App-adoption stats across the officer's enterprises.
@immutable
class AppAdoption {
  /// Creates an adoption summary.
  const AppAdoption({
    required this.enterprisesWithStreak,
    required this.totalEnterprises,
    required this.voiceEntryUsers,
    required this.activeSavingsPlans,
  });

  /// Enterprises entering data 5+ days a week.
  final int enterprisesWithStreak;

  /// Total enterprises on the officer's beat.
  final int totalEnterprises;

  /// Enterprises using voice entry.
  final int voiceEntryUsers;

  /// Enterprises with an active savings plan.
  final int activeSavingsPlans;
}

/// The full month-in-review shown on the Reports screen.
@immutable
class ReportSummary {
  /// Creates a report summary.
  const ReportSummary({
    required this.monthLabel,
    required this.comparedToLabel,
    required this.averageHealthScore,
    required this.averageHealthScoreDelta,
    required this.flagsResolved,
    required this.flagsOpened,
    required this.averageResolutionDays,
    required this.visitsDone,
    required this.riskLedVisits,
    required this.sectorScores,
    required this.insight,
    required this.forecastAccuracy,
    required this.appAdoption,
  });

  /// e.g. "July 2026".
  final String monthLabel;

  /// e.g. "Compared with June".
  final String comparedToLabel;

  /// Average health score across all enterprises.
  final int averageHealthScore;

  /// Change vs. the previous period.
  final int averageHealthScoreDelta;

  /// Flags resolved this month.
  final int flagsResolved;

  /// Flags opened this month (resolved is out of this many).
  final int flagsOpened;

  /// Average days to resolve a flag.
  final int averageResolutionDays;

  /// Visits completed this month.
  final int visitsDone;

  /// Of those, how many were risk-led.
  final int riskLedVisits;

  /// Per-sector score breakdown.
  final List<SectorScore> sectorScores;

  /// The one-line AI insight under the sector bars.
  final String insight;

  /// Forecast accuracy card contents.
  final ForecastAccuracy forecastAccuracy;

  /// App adoption card contents.
  final AppAdoption appAdoption;
}
