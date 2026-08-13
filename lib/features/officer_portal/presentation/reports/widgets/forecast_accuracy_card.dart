/// How well the AI's forecasts held up (Officer Portal 5e).
library;

import 'package:flutter/material.dart';

import '../../../domain/report_summary.dart';
import '../../theme/officer_palette.dart';
import '../../widgets/officer_card.dart';

/// Predicted vs. actual, flags that came true, false alarms.
class ForecastAccuracyCard extends StatelessWidget {
  /// Creates the forecast-accuracy card.
  const ForecastAccuracyCard({super.key, required this.accuracy});

  /// The month's accuracy stats.
  final ForecastAccuracy accuracy;

  @override
  Widget build(BuildContext context) {
    return OfficerCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Row(
            children: <Widget>[
              Icon(
                Icons.auto_awesome_rounded,
                size: 17,
                color: OfficerPalette.forest,
              ),
              SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Forecast accuracy (AI)',
                  style: TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w800,
                    color: OfficerPalette.ink,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _Row(
            label: 'Predicted vs actual (June)',
            value: accuracy.predictedVsActualLabel,
          ),
          const SizedBox(height: 6),
          _Row(
            label: 'Flags that came true',
            value: '${accuracy.flagsThatCameTrue} of ${accuracy.flagsRaised}',
          ),
          const SizedBox(height: 6),
          _Row(label: 'False alarms', value: '${accuracy.falseAlarms}'),
          const SizedBox(height: 8),
          const Text(
            'accuracy improves as entry streaks grow',
            style: TextStyle(fontSize: 10.5, color: OfficerPalette.muted),
          ),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 12.5, color: OfficerPalette.body),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w700,
            color: OfficerPalette.ink,
          ),
        ),
      ],
    );
  }
}
