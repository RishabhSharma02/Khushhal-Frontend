/// The four KPI tiles atop the dashboard (Officer Portal 5a).
library;

import 'package:flutter/material.dart';

import '../../theme/officer_palette.dart';
import '../../widgets/officer_card.dart';

/// Enterprises / healthy / watch / at-risk counts, in a responsive row.
class KpiSummaryRow extends StatelessWidget {
  /// Creates the KPI row.
  const KpiSummaryRow({
    super.key,
    required this.totalEnterpriseCount,
    required this.healthyCount,
    required this.watchCount,
    required this.atRiskCount,
  });

  /// Every enterprise on the officer's beat.
  final int totalEnterpriseCount;

  /// Enterprises currently healthy.
  final int healthyCount;

  /// Enterprises on watch.
  final int watchCount;

  /// Enterprises at risk.
  final int atRiskCount;

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
            value: '$totalEnterpriseCount',
          ),
          _KpiTile(
            emoji: '🟢',
            iconBg: OfficerPalette.chipGreenBg,
            label: 'Healthy',
            value: '$healthyCount',
          ),
          _KpiTile(
            emoji: '🟡',
            iconBg: OfficerPalette.chipAmberBg,
            label: 'Watch',
            value: '$watchCount',
          ),
          _KpiTile(
            emoji: '🔴',
            iconBg: OfficerPalette.chipRedBg,
            label: 'At risk',
            value: '$atRiskCount',
            valueColor: OfficerPalette.statusRed,
            caption: 'count, last 6 months ▸',
          ),
        ];

        if (wide) {
          // A fixed height rather than IntrinsicHeight+stretch: the latter
          // sizes every tile to match the tallest one's *dry-run* measured
          // height, which on web can come in a couple of pixels short of
          // that same tile's real painted height (font-metric rounding
          // differences between the two passes) — a fixed height with
          // headroom sidesteps that class of bug entirely instead of
          // chasing pixel-exact intrinsic sizing.
          return SizedBox(
            height: 132,
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
                // Always reserved (blank when unused) rather than
                // conditional — on the wide layout, IntrinsicHeight stretches
                // every tile to match the tallest one (the "At risk" tile,
                // the only one with a caption). Making the caption line's
                // height unconditional keeps that dry-run measurement pass
                // and the real layout pass consistent; leaving it
                // conditional left the At-risk tile a hair (2px) short of
                // its own content on web due to font-metric rounding.
                Text(
                  caption ?? '',
                  style: const TextStyle(
                    fontSize: 10,
                    height: 1.3,
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
