/// The entry-streak / sync / forecast-confidence card (Officer Portal 5c).
library;

import 'package:flutter/material.dart';

import '../../theme/officer_palette.dart';
import '../../widgets/officer_card.dart';

/// A small card summarising how trustworthy this enterprise's forecast is.
class DataQualityCard extends StatelessWidget {
  /// Creates the data-quality card.
  const DataQualityCard({
    super.key,
    required this.entryStreakDaysPerWeek,
    required this.lastSyncLabel,
    required this.forecastConfidencePercent,
  });

  /// Days per week the enterprise is entering data.
  final int entryStreakDaysPerWeek;

  /// e.g. "2h ago ✓" or "12d ⚠".
  final String lastSyncLabel;

  /// How confident the forecast model is, 0–100.
  final int forecastConfidencePercent;

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
                Icons.fact_check_outlined,
                size: 17,
                color: OfficerPalette.forest,
              ),
              SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Data quality',
                  style: TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w800,
                    color: OfficerPalette.ink,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _Row(
            label: 'Entry streak',
            value: '$entryStreakDaysPerWeek days/wk',
          ),
          const SizedBox(height: 4),
          _Row(label: 'Last sync', value: lastSyncLabel),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: LinearProgressIndicator(
              value: forecastConfidencePercent / 100,
              minHeight: 8,
              backgroundColor: OfficerPalette.soft,
              valueColor: const AlwaysStoppedAnimation<Color>(
                OfficerPalette.statusGreen,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'forecast confidence $forecastConfidencePercent%',
            style: const TextStyle(fontSize: 10.5, color: OfficerPalette.muted),
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
            style: const TextStyle(fontSize: 12, color: OfficerPalette.body),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: OfficerPalette.ink,
          ),
        ),
      ],
    );
  }
}
