/// The four KPI tiles atop the dashboard (Officer Portal 5a).
library;

import 'package:flutter/material.dart';

import '../../../data/officer_demo_data.dart';
import '../../theme/officer_palette.dart';
import '../../widgets/officer_card.dart';

/// Enterprises / healthy / watch / at-risk counts, in a responsive row.
class KpiSummaryRow extends StatelessWidget {
  /// Creates the KPI row.
  const KpiSummaryRow({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool wide = constraints.maxWidth > 620;

        final List<Widget> tiles = <Widget>[
          _KpiTile(
            emoji: '🏢',
            iconBg: OfficerPalette.soft,
            label: 'Enterprises',
            value: '${OfficerDemoData.totalEnterpriseCount}',
          ),
          _KpiTile(
            emoji: '🟢',
            iconBg: OfficerPalette.chipGreenBg,
            label: 'Healthy',
            value: '${OfficerDemoData.healthyCount}',
          ),
          _KpiTile(
            emoji: '🟡',
            iconBg: OfficerPalette.chipAmberBg,
            label: 'Watch',
            value: '${OfficerDemoData.watchCount}',
          ),
          _KpiTile(
            emoji: '🔴',
            iconBg: OfficerPalette.chipRedBg,
            label: 'At risk',
            value: '${OfficerDemoData.atRiskCount}',
            valueColor: OfficerPalette.statusRed,
            caption: 'count, last 6 months ▸',
          ),
        ];

        if (wide) {
          return IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                for (final Widget tile in tiles) ...<Widget>[
                  Expanded(child: tile),
                  if (tile != tiles.last) const SizedBox(width: 14),
                ],
              ],
            ),
          );
        }

        return Wrap(
          spacing: 14,
          runSpacing: 14,
          children: <Widget>[
            for (final Widget tile in tiles)
              SizedBox(width: (constraints.maxWidth - 14) / 2, child: tile),
          ],
        );
      },
    );
  }
}

class _KpiTile extends StatelessWidget {
  const _KpiTile({
    required this.emoji,
    required this.iconBg,
    required this.label,
    required this.value,
    this.valueColor = OfficerPalette.ink,
    this.caption,
  });

  final String emoji;
  final Color iconBg;
  final String label;
  final String value;
  final Color valueColor;
  final String? caption;

  @override
  Widget build(BuildContext context) {
    return OfficerCard(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      child: Row(
        children: <Widget>[
          Container(
            width: 44,
            height: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
            child: Text(emoji, style: const TextStyle(fontSize: 18)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12.5,
                    color: OfficerPalette.body,
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: valueColor,
                  ),
                ),
                if (caption != null)
                  Text(
                    caption!,
                    style: const TextStyle(
                      fontSize: 10,
                      color: OfficerPalette.muted,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
