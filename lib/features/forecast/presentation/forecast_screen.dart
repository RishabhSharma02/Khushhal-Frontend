/// Six-month forecast (design 1q).
library;

import 'package:flutter/material.dart';

import '../../../app/model/insights.dart';
import '../../../app/session.dart';
import '../../../core/formatting.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/back_header.dart';
import '../../../core/widgets/gradient_cta_button.dart';
import '../../../core/widgets/khushhal_card.dart';
import '../../../core/widgets/page_backdrop.dart';
import '../../../l10n/app_localizations.dart';
import 'alerts_screen.dart';

/// The monthly forecast edition with what-if chips.
///
/// One stamped edition per month: a net-cash-flow bar for six months, the
/// flagged month outlined amber, one plain-words insight, and what-if chips
/// that preview without replacing the official edition.
class ForecastScreen extends StatefulWidget {
  /// Creates the screen.
  const ForecastScreen({super.key});

  @override
  State<ForecastScreen> createState() => _ForecastScreenState();
}

class _ForecastScreenState extends State<ForecastScreen> {
  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final AppSession session = SessionScope.of(context);
    final List<ForecastMonth> months = session.forecast;
    final ForecastMonth? risk = months.flaggedRiskMonth;
    final HealthSnapshot? health = session.health;

    return Scaffold(
      body: PageBackdrop(
        child: Column(
          children: <Widget>[
            BackHeader(title: l10n.forecastHeading),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(height: 12),
                    // The stamp dates are the health snapshot's — the
                    // forecast is stamped in the same run as the score.
                    // Nothing to date the edition by until one exists.
                    if (health != null) ...<Widget>[
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 11,
                        ),
                        decoration: BoxDecoration(
                          color: AppPalette.mintChip,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          children: <Widget>[
                            const Icon(
                              Icons.event_rounded,
                              size: 16,
                              color: AppPalette.leaf,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                l10n.forecastMadeOn(
                                  dayMonth(context, health.asOn),
                                  dayMonth(context, health.nextUpdate),
                                ),
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: AppPalette.leaf,
                                  height: 1.3,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                    KhushhalCard(
                      radius: 18,
                      padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              _LegendSwatch(
                                label: l10n.forecastNetLabel,
                                filled: true,
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          _ForecastChart(months: months),
                          const SizedBox(height: 6),
                          Row(
                            children: <Widget>[
                              for (final ForecastMonth month in months)
                                Expanded(
                                  child: Text(
                                    monthShort(context, month.month),
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 10.5,
                                      fontWeight: month.isRiskMonth
                                          ? FontWeight.w700
                                          : FontWeight.w400,
                                      color: month.isRiskMonth
                                          ? AppPalette.amberAccent
                                          : AppPalette.hint,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    KhushhalCard(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 13,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            risk == null
                                ? l10n.forecastNoRiskTitle
                                : l10n.forecastInsightTitle(
                                    monthName(context, risk.month),
                                  ),
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppPalette.cardInk,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            risk == null
                                ? l10n.forecastNoRiskWhy
                                : l10n.forecastInsightWhy(
                                    rupees(context, session.savingsInr),
                                  ),
                            style: const TextStyle(
                              fontSize: 12.5,
                              color: AppPalette.muted,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            GradientCtaButton(
              label: l10n.forecastWhatCta,
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (BuildContext _) => const AlertsScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// One legend entry: a 10px swatch and its label.
class _LegendSwatch extends StatelessWidget {
  const _LegendSwatch({required this.label, required this.filled});

  final String label;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: filled ? AppPalette.leaf : AppPalette.onPrimary,
            border: filled
                ? null
                : Border.all(color: const Color(0xFFA9C9B2), width: 1.5),
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 5),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: AppPalette.hint),
        ),
      ],
    );
  }
}

/// A 110px net-cash-flow chart: one bar per month around a zero baseline.
/// Positive net (IN > OUT) grows up in leaf green; negative net grows down
/// in amber. The flagged month keeps its amber outline.
class _ForecastChart extends StatelessWidget {
  const _ForecastChart({required this.months});

  final List<ForecastMonth> months;

  static const double _height = 110;
  static const double _halfHeight = _height / 2;

  @override
  Widget build(BuildContext context) {
    // Normalise every month's cash-flow prediction against the largest
    // magnitude in the window so the tallest bar reaches the chart edge
    // without letting a runaway extreme flatten the rest.
    double peak = 0;
    for (final ForecastMonth m in months) {
      final double abs = m.cfPred.abs();
      if (abs > peak) peak = abs;
    }
    final double scale = peak == 0 ? 0 : 1 / peak;

    return SizedBox(
      height: _height,
      child: Stack(
        children: <Widget>[
          // Zero baseline runs across the middle so positive and negative
          // months read against a fixed reference rather than the bottom of
          // the card.
          Positioned(
            left: 0,
            right: 0,
            top: _halfHeight - 0.75,
            child: Container(height: 1.5, color: AppPalette.outline),
          ),
          Row(
            children: <Widget>[
              for (final ForecastMonth month in months)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: _NetBar(month: month, scale: scale),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _NetBar extends StatelessWidget {
  const _NetBar({required this.month, required this.scale});

  final ForecastMonth month;
  final double scale;

  @override
  Widget build(BuildContext context) {
    // Signed cash-flow prediction, normalised against the window's peak
    // magnitude and clamped so an outlier cannot escape the card frame.
    final double net = (month.cfPred * scale).clamp(-1.0, 1.0);
    final bool positive = net >= 0;
    final double magnitude = net.abs() * _ForecastChart._halfHeight;

    final Color fill = positive ? AppPalette.leaf : AppPalette.amberAccent;

    final Widget bar = Container(
      height: magnitude,
      decoration: BoxDecoration(
        color: fill,
        borderRadius: BorderRadius.vertical(
          top: positive
              ? const Radius.circular(3)
              : Radius.zero,
          bottom: positive
              ? Radius.zero
              : const Radius.circular(3),
        ),
      ),
    );

    // Positive bars anchor to the middle baseline and grow up; negative
    // bars anchor to the same baseline and grow down. A flexible spacer
    // fills the unused half so the layout stays balanced across months.
    final Widget stackedBar = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          child: positive
              ? Align(alignment: Alignment.bottomCenter, child: bar)
              : const SizedBox.shrink(),
        ),
        Expanded(
          child: positive
              ? const SizedBox.shrink()
              : Align(alignment: Alignment.topCenter, child: bar),
        ),
      ],
    );

    if (!month.isRiskMonth) return stackedBar;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFD99000), width: 1.5),
        borderRadius: BorderRadius.circular(6),
      ),
      child: stackedBar,
    );
  }
}
