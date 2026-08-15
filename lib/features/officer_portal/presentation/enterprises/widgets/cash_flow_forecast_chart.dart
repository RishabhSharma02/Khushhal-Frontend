/// The 12-month net-cash-flow chart with forecast half and flagged month
/// (5c).
library;

import 'package:flutter/material.dart';

import '../../../domain/forecast_month.dart';
import '../../theme/officer_palette.dart';

/// One bar per month — net cash flow (money in minus out for recorded
/// months, the forecast model's `cf_pred` for forecast months) — colored by
/// sign, with the flagged month outlined in risk red.
class CashFlowForecastChart extends StatelessWidget {
  /// Creates the chart.
  const CashFlowForecastChart({super.key, required this.months});

  /// The 12 months to plot, recorded first then forecast.
  final List<CashFlowMonth> months;

  static const double _height = 130;

  /// Net cash flow for [month]: real (money in − out) when recorded, the
  /// forecast model's `cf_pred` when forecast.
  static int _net(CashFlowMonth month) {
    return month.isForecast ? (month.netInr ?? 0) : (month.moneyInInr - month.moneyOutInr);
  }

  @override
  Widget build(BuildContext context) {
    final int maxValue = months.fold<int>(
      1,
      (int max, CashFlowMonth m) => _net(m).abs() > max ? _net(m).abs() : max,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            const Icon(
              Icons.bar_chart_rounded,
              size: 17,
              color: OfficerPalette.forest,
            ),
            const SizedBox(width: 6),
            const Expanded(
              child: Text(
                'Monthly net cash flow (₹) — last 6 months & next 6 forecast',
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w800,
                  color: OfficerPalette.ink,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        const Text(
          'Net cash flow — green is positive, red is negative',
          style: TextStyle(fontSize: 11, color: OfficerPalette.muted),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: _height,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              for (final CashFlowMonth month in months)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: Container(
                      padding: month.isFlagged
                          ? const EdgeInsets.fromLTRB(2, 2, 2, 0)
                          : EdgeInsets.zero,
                      decoration: month.isFlagged
                          ? BoxDecoration(
                              border: Border.all(
                                color: OfficerPalette.statusRed,
                                width: 1.5,
                              ),
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(6),
                              ),
                            )
                          : null,
                      child: _Bar(
                        height: _net(month).abs() / maxValue * _height,
                        color: _net(month) >= 0
                            ? OfficerPalette.statusGreen
                            : OfficerPalette.statusRed,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        Row(
          children: <Widget>[
            for (final CashFlowMonth month in months)
              Expanded(
                child: Text(
                  month.label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: month.isFlagged
                        ? FontWeight.w700
                        : FontWeight.w400,
                    color: month.isFlagged
                        ? OfficerPalette.statusRed
                        : OfficerPalette.muted,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 4),
        const Text(
          'Left of the divider = recorded entries · right = AI forecast · '
          'red outline marks the flagged month',
          style: TextStyle(fontSize: 10.5, color: OfficerPalette.muted),
        ),
      ],
    );
  }
}

class _Bar extends StatelessWidget {
  const _Bar({required this.height, required this.color});

  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height.clamp(0, CashFlowForecastChart._height),
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(3)),
      ),
    );
  }
}
