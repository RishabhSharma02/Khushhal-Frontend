/// The per-sector health-score bars and insight (Officer Portal 5e).
library;

import 'package:flutter/material.dart';

import '../../../domain/report_summary.dart';
import '../../theme/officer_palette.dart';
import '../../widgets/officer_card.dart';

/// Sector rows colored by threshold, plus a short AI insight underneath.
class SectorScoreBars extends StatelessWidget {
  /// Creates the sector score bars card.
  const SectorScoreBars({
    super.key,
    required this.scores,
    required this.insight,
  });

  /// Per-sector averages.
  final List<SectorScore> scores;

  /// The one-line insight shown under the bars.
  final String insight;

  static Color _colorFor(int score) {
    if (score >= 60) {
      return OfficerPalette.statusGreen;
    }
    if (score >= 40) {
      return OfficerPalette.statusAmber;
    }
    return OfficerPalette.statusRed;
  }

  @override
  Widget build(BuildContext context) {
    return OfficerCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text.rich(
            const TextSpan(
              children: <InlineSpan>[
                TextSpan(
                  text: 'Health score by sector ',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: OfficerPalette.ink,
                  ),
                ),
                TextSpan(
                  text: '(avg 0–100 · enterprise count in brackets)',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: OfficerPalette.muted,
                    fontSize: 11.5,
                  ),
                ),
              ],
            ),
            style: const TextStyle(fontSize: 14.5),
          ),
          const SizedBox(height: 12),
          for (final SectorScore score in scores)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: 96,
                    child: Text(
                      '${score.icon} ${score.label} (${score.enterpriseCount})',
                      style: const TextStyle(fontSize: 12.5),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: score.averageScore / 100,
                        minHeight: 10,
                        backgroundColor: OfficerPalette.soft,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          _colorFor(score.averageScore),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    score.averageScore < 40
                        ? '${score.averageScore} ⚠'
                        : '${score.averageScore}',
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w800,
                      color: score.averageScore < 40
                          ? OfficerPalette.statusRed
                          : OfficerPalette.ink,
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: OfficerPalette.chipGreenBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text.rich(
              TextSpan(
                children: <InlineSpan>[
                  const TextSpan(
                    text: '✨ ',
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                  const TextSpan(
                    text: 'Insight: ',
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                  TextSpan(text: insight),
                ],
              ),
              style: const TextStyle(
                fontSize: 12.5,
                height: 1.4,
                color: OfficerPalette.chipGreenInk,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
