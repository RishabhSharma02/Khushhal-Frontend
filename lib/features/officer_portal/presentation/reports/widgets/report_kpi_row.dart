/// The four month-in-review KPI tiles (Officer Portal 5e).
library;

import 'package:flutter/material.dart';

import '../../../domain/report_summary.dart';
import '../../theme/officer_palette.dart';
import '../../widgets/officer_card.dart';
import '../../widgets/status_chip.dart';

/// Avg score, flags resolved, EMIs on time, visits done.
class ReportKpiRow extends StatelessWidget {
  /// Creates the report KPI row.
  const ReportKpiRow({super.key, required this.summary});

  /// The month's summary.
  final ReportSummary summary;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double tileWidth = constraints.maxWidth > 620
            ? (constraints.maxWidth - 3 * 12) / 4
            : (constraints.maxWidth - 12) / 2;

        final List<Widget> tiles = <Widget>[
          _Tile(
            label: 'AVG HEALTH SCORE',
            value: '${summary.averageHealthScore}',
            deltaLabel:
                '${summary.averageHealthScoreDelta >= 0 ? '+' : ''}${summary.averageHealthScoreDelta}',
          ),
          _Tile(
            label: 'FLAGS RESOLVED',
            value: '${summary.flagsResolved}/${summary.flagsOpened}',
            trailingLabel: '${summary.averageResolutionDays}d avg',
          ),
          _Tile(
            label: 'EMIs ON TIME',
            value: '${summary.emisOnTimePercent}%',
            deltaLabel:
                '${summary.emisOnTimeDelta >= 0 ? '+' : ''}${summary.emisOnTimeDelta}%',
          ),
          _Tile(
            label: 'VISITS DONE',
            value: '${summary.visitsDone}',
            trailingLabel: '${summary.riskLedVisits} risk-led',
          ),
        ];

        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: <Widget>[
            for (final Widget tile in tiles)
              SizedBox(width: tileWidth, child: tile),
          ],
        );
      },
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({
    required this.label,
    required this.value,
    this.deltaLabel,
    this.trailingLabel,
  });

  final String label;
  final String value;
  final String? deltaLabel;
  final String? trailingLabel;

  @override
  Widget build(BuildContext context) {
    return OfficerCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: OfficerPalette.muted,
            ),
          ),
          const SizedBox(height: 4),
          Wrap(
            spacing: 8,
            runSpacing: 2,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: <Widget>[
              Text(
                value,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: OfficerPalette.ink,
                ),
              ),
              if (deltaLabel != null)
                StatusChip(
                  label: deltaLabel!,
                  tone: OfficerTone.green,
                  dense: true,
                ),
              if (trailingLabel != null)
                Text(
                  trailingLabel!,
                  style: const TextStyle(
                    fontSize: 11.5,
                    color: OfficerPalette.muted,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
