/// One month of an enterprise's cash flow chart (Officer Portal 5c).
library;

import 'package:flutter/foundation.dart';

/// A single month on the enterprise detail's cash-flow chart.
///
/// Recorded months carry real [moneyInInr]/[moneyOutInr], plotted as a
/// bar-pair. Forecast months carry [netInr] — the model's actual `cf_pred`
/// — plotted as a single bar instead, since splitting it into a synthetic
/// in/out pair isn't a real prediction on its own. [isForecast] tells the
/// chart which to use.
@immutable
class CashFlowMonth {
  /// Creates one month's bar(s).
  const CashFlowMonth({
    required this.label,
    required this.moneyInInr,
    required this.moneyOutInr,
    this.netInr,
    this.isForecast = false,
    this.isFlagged = false,
  });

  /// Short month label, e.g. "Nov".
  final String label;

  /// Money in, in rupees. Recorded months only.
  final int moneyInInr;

  /// Money out, in rupees. Recorded months only.
  final int moneyOutInr;

  /// The forecast's predicted net cash flow, in rupees. Forecast months
  /// only — `null` for recorded months.
  final int? netInr;

  /// Whether this month is a forecast rather than a recorded entry.
  final bool isForecast;

  /// Whether the AI flagged this month as a cash gap.
  final bool isFlagged;
}
