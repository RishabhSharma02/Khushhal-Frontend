/// The 12-month IN/OUT chart with forecast half and flagged month (5c).
library;

import 'package:flutter/material.dart';

import '../../../domain/forecast_month.dart';
import '../../theme/officer_palette.dart';

/// Grouped bar chart: recorded months solid, forecast months lighter, the
/// flagged month outlined in risk red.
class CashFlowForecastChart extends StatelessWidget {
  /// Creates the chart.
  const CashFlowForecastChart({super.key, required this.months});

  /// The 12 months to plot, recorded first then forecast.
  final List<CashFlowMonth> months;

  static const double _height = 130;

  @override
  Widget build(BuildContext context) {
    final int maxValue = months.fold<int>(
      1,
      (int max, CashFlowMonth m) => <int>[
        max,
        m.moneyInInr,
        m.moneyOutInr,
      ].reduce((int a, int b) => a > b ? a : b),
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
                'Monthly cash flow (₹) — last 6 months & next 6 forecast',
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
        Wrap(
          spacing: 12,
          children: <Widget>[
            _Legend(color: OfficerPalette.statusGreen, label: 'money IN'),
            _Legend(color: OfficerPalette.recordedOut, label: 'money OUT'),
            _Legend(color: OfficerPalette.forecastIn, label: 'forecast'),
          ],
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
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: _Bar(
                              height: month.moneyInInr / maxValue * _height,
                              color: month.isForecast
                                  ? OfficerPalette.forecastIn
                                  : OfficerPalette.statusGreen,
                            ),
                          ),
                          const SizedBox(width: 3),
                          Expanded(
                            child: _Bar(
                              height: month.moneyOutInr / maxValue * _height,
                              color: month.isForecast
                                  ? OfficerPalette.forecastOut
                                  : OfficerPalette.recordedOut,
                            ),
                          ),
                        ],
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

class _Legend extends StatelessWidget {
  const _Legend({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          width: 9,
          height: 9,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 5),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: OfficerPalette.muted),
        ),
      ],
    );
  }
}
