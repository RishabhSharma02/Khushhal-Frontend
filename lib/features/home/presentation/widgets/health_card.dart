/// The health card at the centre of home (designs 1o and 1o2).
library;

import 'package:flutter/material.dart';

import '../../../../app/model/insights.dart';
import '../../../../core/formatting.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/khushhal_card.dart';
import '../../../../l10n/app_localizations.dart';

/// The stamped monthly score, presented like a credit report.
///
/// With [pending] set the card shows the fresh month-end score with its NEW
/// stamp and delta (1o2); otherwise it shows the running month's score with
/// the days-written progress underneath (1o).
class HealthCard extends StatelessWidget {
  /// Creates the card.
  const HealthCard({
    super.key,
    required this.businessName,
    required this.health,
    this.pending,
    this.onTap,
  });

  /// Name on the headline.
  final String businessName;

  /// The score the month runs on.
  final HealthSnapshot health;

  /// The fresh score, while it is still unopened.
  final HealthSnapshot? pending;

  /// Usually opens the forecast (1q).
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final HealthSnapshot shown = pending ?? health;
    final bool fresh = pending != null;
    final _BandStyle band = _BandStyle.forSnapshot(shown, businessName, l10n);

    // The score refreshes every 30 days from `asOn`. Show progress as days
    // elapsed since the last stamp — the label and bar move forward each
    // day even though the numeric score only changes on `nextUpdate`.
    final int windowDays = shown.nextUpdate.difference(shown.asOn).inDays;
    final int totalDays = windowDays > 0 ? windowDays : 30;
    final int elapsed = DateTime.now().difference(shown.asOn).inDays
        .clamp(0, totalDays);
    final double windowFraction = elapsed / totalDays;

    return KhushhalCard(
      radius: 20,
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 14),
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Flexible(
                child: Text(
                  l10n.scoreAsOn(dayMonth(context, shown.asOn)).toUpperCase(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.05,
                    color: AppPalette.faint,
                    height: 1.3,
                  ),
                ),
              ),
              if (fresh) ...<Widget>[
                const SizedBox(width: 7),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 7,
                    vertical: 2,
                  ),
                  decoration: const BoxDecoration(
                    color: AppPalette.leaf,
                    borderRadius: BorderRadius.all(Radius.circular(99)),
                  ),
                  child: Text(
                    l10n.scoreNew.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 9.5,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.76,
                      color: AppPalette.onPrimary,
                      height: 1.3,
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 6),
          Text(
            band.headline,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppPalette.ink,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 4),
          if (fresh)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: <Widget>[
                Flexible(
                  child: Text(
                    l10n.scoreOutOf(shown.score),
                    style: const TextStyle(
                      fontSize: 12.5,
                      color: AppPalette.muted,
                      height: 1.4,
                    ),
                  ),
                ),
                if (shown.delta != null) ...<Widget>[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: const BoxDecoration(
                      color: AppPalette.mintChip,
                      borderRadius: BorderRadius.all(Radius.circular(99)),
                    ),
                    child: Text(
                      '▲ ${shown.delta}',
                      style: const TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        color: AppPalette.leaf,
                        height: 1.3,
                      ),
                    ),
                  ),
                ],
              ],
            )
          else
            Text(
              band.summary,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12.5,
                color: AppPalette.muted,
                height: 1.4,
              ),
            ),
          const SizedBox(height: 9),
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              decoration: BoxDecoration(
                color: band.background,
                border: Border.all(color: band.border),
                borderRadius: BorderRadius.circular(99),
              ),
              child: Text(
                band.label.toUpperCase(),
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.46,
                  color: band.ink,
                  height: 1.3,
                ),
              ),
            ),
          ),
          if (onTap != null) ...<Widget>[
            const SizedBox(height: 8),
            Text(
              l10n.healthTapForForecast,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
                color: AppPalette.leaf,
                height: 1.3,
              ),
            ),
          ],
          const SizedBox(height: 13),
          const _DashedLine(),
          const SizedBox(height: 11),
          if (fresh)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Flexible(
                  child: Text(
                    l10n.homeNextUpdate(dayMonth(context, shown.nextUpdate)),
                    style: const TextStyle(
                      fontSize: 11.5,
                      color: AppPalette.muted,
                      height: 1.4,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    l10n.homeMonthJustStarted(monthName(context, shown.asOn)),
                    textAlign: TextAlign.end,
                    style: const TextStyle(
                      fontSize: 11.5,
                      color: AppPalette.faint,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            )
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Flexible(
                      child: Text(
                        l10n.homeScoreAsOf(dayMonth(context, shown.asOn)),
                        style: const TextStyle(
                          fontSize: 11.5,
                          color: AppPalette.muted,
                          height: 1.4,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        l10n.homeDayOf30(elapsed),
                        textAlign: TextAlign.end,
                        style: const TextStyle(
                          fontSize: 11.5,
                          color: AppPalette.faint,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                _DaysProgressBar(fraction: windowFraction),
                const SizedBox(height: 6),
                Text(
                  l10n.homeNextUpdate(dayMonth(context, shown.nextUpdate)),
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppPalette.faint,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.homeScoreNote,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppPalette.faint,
                    height: 1.4,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

/// Everything on the card that follows the band: the headline, the summary
/// line, and the colours of the risk pill.
///
/// Backend returns a `RiskLevel` (low / medium / high) — we map each band to
/// the same palette used elsewhere in the app: mint for low, amber for
/// medium, danger for high.
class _BandStyle {
  const _BandStyle({
    required this.label,
    required this.headline,
    required this.summary,
    required this.background,
    required this.border,
    required this.ink,
  });

  final String label;

  /// Business name, the band's word, and the face — the face is added here
  /// rather than baked into the ARB string so it can follow the score too.
  final String headline;

  final String summary;
  final Color background;
  final Color border;
  final Color ink;

  /// Two faces per band, the brighter one from the given score upwards.
  ///
  /// The only place the tiers live: a band alone is too coarse (36 and 59
  /// are both red-adjacent but feel different to their owner), and a single
  /// score ladder would fight the band the backend already decided on.
  static String _face(RiskLevel level, int score) => switch (level) {
    RiskLevel.low => score >= 80 ? '😄' : '🙂',
    RiskLevel.medium => score >= 50 ? '😐' : '😕',
    RiskLevel.high => score >= 30 ? '😟' : '😰',
  };

  factory _BandStyle.forSnapshot(
    HealthSnapshot health,
    String businessName,
    AppLocalizations l10n,
  ) {
    final String face = _face(health.risk, health.score);

    switch (health.risk) {
      case RiskLevel.low:
        return _BandStyle(
          label: l10n.riskLowBadge,
          headline: '${l10n.healthHeadlineLow(businessName)} $face',
          summary: l10n.healthSummaryLow(health.score),
          background: AppPalette.mintChip,
          border: AppPalette.riskLowBorder,
          ink: AppPalette.leaf,
        );
      case RiskLevel.medium:
        return _BandStyle(
          label: l10n.riskMediumBadge,
          headline: '${l10n.healthHeadlineMedium(businessName)} $face',
          summary: l10n.healthSummaryMedium(health.score),
          background: AppPalette.amberWash,
          border: AppPalette.amberBorder,
          ink: AppPalette.amberInk,
        );
      case RiskLevel.high:
        return _BandStyle(
          label: l10n.riskHighBadge,
          headline: '${l10n.healthHeadlineHigh(businessName)} $face',
          summary: l10n.healthSummaryHigh(health.score),
          background: const Color(0xFFFDECEB),
          border: AppPalette.dangerBorder,
          ink: AppPalette.danger,
        );
    }
  }
}

/// The dashed hairline between the score and its metadata.
class _DashedLine extends StatelessWidget {
  const _DashedLine();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final int dashes = (constraints.maxWidth / 8).floor().clamp(1, 200);

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List<Widget>.generate(dashes, (int _) {
            return Container(width: 4, height: 1, color: AppPalette.line);
          }),
        );
      },
    );
  }
}

/// The days-written bar under the running score.
class _DaysProgressBar extends StatelessWidget {
  const _DaysProgressBar({required this.fraction});

  final double fraction;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(99),
      child: SizedBox(
        height: 6,
        width: double.infinity,
        child: Stack(
          children: <Widget>[
            Container(color: const Color(0xFFEDF3EE)),
            FractionallySizedBox(
              widthFactor: fraction.clamp(0.0, 1.0),
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: <Color>[AppPalette.sprout, AppPalette.leaf],
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(99)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
