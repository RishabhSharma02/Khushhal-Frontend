/// Six-month forecast (design 1q).
library;

import 'package:flutter/material.dart';

import '../../../app/model/insights.dart';
import '../../../app/session.dart';
import '../../../core/formatting.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/back_header.dart';
import '../../../core/widgets/choice_pill.dart';
import '../../../core/widgets/gradient_cta_button.dart';
import '../../../core/widgets/khushhal_card.dart';
import '../../../core/widgets/page_backdrop.dart';
import '../../../l10n/app_localizations.dart';
import 'alert_detail_screen.dart';

/// The monthly forecast edition with what-if chips.
///
/// One stamped edition per month: IN/OUT bars for six months, the flagged
/// month outlined amber, one plain-words insight, and what-if chips that
/// preview without replacing the official edition.
class ForecastScreen extends StatefulWidget {
  /// Creates the screen.
  const ForecastScreen({super.key});

  @override
  State<ForecastScreen> createState() => _ForecastScreenState();
}

/// Which scenario chip is lit; only [normal] has model output in the demo.
enum _Scenario { normal, priceSpike, badWeather }

class _ForecastScreenState extends State<ForecastScreen> {
  _Scenario _scenario = _Scenario.normal;

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
                              _LegendSwatch(label: l10n.entryIn, filled: true),
                              const SizedBox(width: 14),
                              _LegendSwatch(
                                label: l10n.entryOut,
                                filled: false,
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
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 7,
                      runSpacing: 7,
                      children: <Widget>[
                        ChoicePill(
                          label: l10n.whatIfNormal,
                          selected: _scenario == _Scenario.normal,
                          onTap: () =>
                              setState(() => _scenario = _Scenario.normal),
                        ),
                        ChoicePill(
                          label: l10n.whatIfSpike,
                          selected: _scenario == _Scenario.priceSpike,
                          dashed: true,
                          onTap: () =>
                              setState(() => _scenario = _Scenario.priceSpike),
                        ),
                        ChoicePill(
                          label: l10n.whatIfWeather,
                          selected: _scenario == _Scenario.badWeather,
                          dashed: true,
                          onTap: () =>
                              setState(() => _scenario = _Scenario.badWeather),
                        ),
                      ],
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
                    builder: (BuildContext _) => const AlertDetailScreen(),
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

/// The 110px grouped-bar chart: solid IN and outlined OUT per month.
class _ForecastChart extends StatelessWidget {
  const _ForecastChart({required this.months});

  final List<ForecastMonth> months;

  static const double _height = 110;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _height,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppPalette.outline, width: 1.5),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          for (final ForecastMonth month in months)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Container(
                  // The flagged month gets its amber frame; padding keeps
                  // the bars clear of the frame line.
                  padding: month.isRiskMonth
                      ? const EdgeInsets.fromLTRB(2, 2, 2, 0)
                      : EdgeInsets.zero,
                  decoration: month.isRiskMonth
                      ? BoxDecoration(
                          border: Border.all(
                            color: const Color(0xFFD99000),
                            width: 1.5,
                          ),
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(6),
                          ),
                        )
                      : null,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Expanded(child: _bar(month, isIn: true)),
                      const SizedBox(width: 3),
                      Expanded(child: _bar(month, isIn: false)),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _bar(ForecastMonth month, {required bool isIn}) {
    final double level = isIn ? month.inLevel : month.outLevel;
    // The risk frame eats a little height; keep bars inside the chart.
    final double height = (level * _height - (month.isRiskMonth ? 4 : 0)).clamp(
      0,
      _height,
    );

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: isIn
            ? AppPalette.leaf
            : month.isRiskMonth
            ? AppPalette.amberWash
            : AppPalette.onPrimary,
        border: isIn
            ? null
            : Border.all(
                color: month.isRiskMonth
                    ? const Color(0xFFD99000)
                    : const Color(0xFFA9C9B2),
                width: 1.5,
              ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(3)),
      ),
    );
  }
}
