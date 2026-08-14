/// The four device-health KPI tiles (Officer Portal 5f).
library;

import 'package:flutter/material.dart';

import '../../theme/officer_palette.dart';
import '../../widgets/officer_card.dart';

/// Synced &lt;24h, 1–7 days, stale 7+, entry gaps 5+.
class SyncKpiRow extends StatelessWidget {
  /// Creates the sync KPI row.
  const SyncKpiRow({
    super.key,
    required this.syncedUnder24h,
    required this.synced1To7Days,
    required this.stale7Plus,
    required this.entryGap5Plus,
  });

  /// Devices synced within 24 hours.
  final int syncedUnder24h;

  /// Devices synced 1–7 days ago.
  final int synced1To7Days;

  /// Devices stale 7+ days.
  final int stale7Plus;

  /// Devices with a 5+ day entry gap.
  final int entryGap5Plus;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double tileWidth = constraints.maxWidth > 620
            ? (constraints.maxWidth - 3 * 12) / 4
            : (constraints.maxWidth - 12) / 2;

        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: <Widget>[
            SizedBox(
              width: tileWidth,
              child: _Tile(
                label: 'SYNCED < 24H',
                value: '$syncedUnder24h',
                valueColor: OfficerPalette.statusGreen,
              ),
            ),
            SizedBox(
              width: tileWidth,
              child: _Tile(label: '1–7 DAYS', value: '$synced1To7Days'),
            ),
            SizedBox(
              width: tileWidth,
              child: _Tile(
                label: 'STALE 7+ DAYS',
                value: '$stale7Plus',
                valueColor: OfficerPalette.statusRed,
                tint: OfficerPalette.chipRedBg,
                caption: 'scores use last-known data',
              ),
            ),
            SizedBox(
              width: tileWidth,
              child: _Tile(
                label: 'ENTRY GAPS 5+ D',
                value: '$entryGap5Plus',
                valueColor: OfficerPalette.statusAmber,
              ),
            ),
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
    this.valueColor = OfficerPalette.ink,
    this.tint,
    this.caption,
  });

  final String label;
  final String value;
  final Color valueColor;
  final Color? tint;
  final String? caption;

  @override
  Widget build(BuildContext context) {
    return OfficerCard(
      color: tint ?? OfficerPalette.card,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: tint != null ? valueColor : OfficerPalette.muted,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: valueColor,
            ),
          ),
          if (caption != null)
            Text(
              caption!,
              style: const TextStyle(
                fontSize: 10.5,
                color: OfficerPalette.muted,
              ),
            ),
        ],
      ),
    );
  }
}
