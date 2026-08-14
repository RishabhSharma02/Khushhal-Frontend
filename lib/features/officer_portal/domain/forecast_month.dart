/// One month of an enterprise's cash flow chart (Officer Portal 5c).
library;

import 'package:flutter/foundation.dart';

/// A single bar-pair on the enterprise detail's IN/OUT chart.
///
/// Recorded months carry real [moneyInInr]/[moneyOutInr]; forecast months
/// carry the AI's projection instead — [isForecast] tells the chart which
/// palette to use.
@immutable
class CashFlowMonth {
  /// Creates one month's bars.
  const CashFlowMonth({
    required this.label,
    required this.moneyInInr,
    required this.moneyOutInr,
    this.isForecast = false,
    this.isFlagged = false,
  });

  /// Short month label, e.g. "Nov".
  final String label;

  /// Money in (or forecast in), in rupees.
  final int moneyInInr;

  /// Money out (or forecast out), in rupees.
  final int moneyOutInr;

  /// Whether this bar-pair is a forecast rather than a recorded entry.
  final bool isForecast;

  /// Whether the AI flagged this month as a cash gap.
  final bool isFlagged;
}
