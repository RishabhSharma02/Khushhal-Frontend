/// Monthly update reveal (design 1q2).
library;

import 'package:flutter/material.dart';

import '../../../app/demo_data.dart';
import '../../../app/model/insights.dart';
import '../../../app/session.dart';
import '../../../core/formatting.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/back_header.dart';
import '../../../core/widgets/gradient_cta_button.dart';
import '../../../core/widgets/khushhal_card.dart';
import '../../../core/widgets/page_backdrop.dart';
import '../../../l10n/app_localizations.dart';
import 'forecast_screen.dart';

/// The month-end score reveal: one number, one delta, six months of history,
/// then three plain reasons — two up, one down, so the score never feels
/// arbitrary.
///
/// Opening this screen consumes the pending update: the home banner clears
/// and the new score becomes the stamped one.
class MonthlyUpdateScreen extends StatefulWidget {
  /// Creates the screen.
  const MonthlyUpdateScreen({super.key});

  @override
  State<MonthlyUpdateScreen> createState() => _MonthlyUpdateScreenState();
}

class _MonthlyUpdateScreenState extends State<MonthlyUpdateScreen> {
  HealthSnapshot? _revealed;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_revealed == null) {
      final AppSession session = SessionScope.of(context);
      _revealed = session.pendingHealth ?? session.health;

      // Promote after this frame: the reveal has been seen, so home's
      // "month closed" banner has done its job.
      WidgetsBinding.instance.addPostFrameCallback((Duration _) {
        session.acceptMonthlyUpdate();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final AppSession session = SessionScope.of(context);
    final HealthSnapshot revealed = _revealed!;
    final DateTime closedMonth = DateTime(
      revealed.asOn.year,
      revealed.asOn.month - 1,
      1,
    );
    final DateTime monthBeforeClosed = DateTime(
      revealed.asOn.year,
      revealed.asOn.month - 2,
      1,
    );
    final String businessName =
        session.activeBusiness?.name ?? l10n.businessN(1);

    return Scaffold(
      body: PageBackdrop(
        child: Column(
          children: <Widget>[
            BackHeader(
              title: l10n.updateTitle(monthName(context, closedMonth)),
              trailing: _DateChip(label: dayMonth(context, revealed.asOn)),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(height: 12),
                    KhushhalCard(
                      radius: 20,
                      padding: const EdgeInsets.fromLTRB(20, 18, 20, 16),
                      child: Column(
                        children: <Widget>[
                          Text(
                            l10n.updateScoreLabel(businessName).toUpperCase(),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1,
                              color: AppPalette.faint,
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Scales down rather than clips when large text
                          // sizes outgrow the card.
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: <Widget>[
                                Text(
                                  '${revealed.score}',
                                  style: const TextStyle(
                                    fontSize: 52,
                                    fontWeight: FontWeight.w700,
                                    height: 1,
                                    color: AppPalette.ink,
                                  ),
                                ),
                                const Text(
                                  '/100',
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600,
                                    color: AppPalette.faint,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 9),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 11,
                              vertical: 4,
                            ),
                            decoration: const BoxDecoration(
                              color: AppPalette.mintChip,
                              borderRadius: BorderRadius.all(
                                Radius.circular(99),
                              ),
                            ),
                            child: Text(
                              '▲ ${l10n.updateDeltaFrom(revealed.delta ?? 0, monthName(context, closedMonth))}',
                              style: const TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w700,
                                color: AppPalette.leaf,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          _ScoreHistoryChart(history: DemoData.scoreHistory),
                          const SizedBox(height: 14),
                          Container(
                            padding: const EdgeInsets.only(top: 11),
                            decoration: const BoxDecoration(
                              border: Border(
                                top: BorderSide(color: AppPalette.line),
                              ),
                            ),
                            // Wraps to two lines when large text runs out
                            // of row.
                            child: Wrap(
                              alignment: WrapAlignment.spaceBetween,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              spacing: 10,
                              runSpacing: 4,
                              children: <Widget>[
                                Text.rich(
                                  TextSpan(
                                    children: <InlineSpan>[
                                      TextSpan(
                                        text: '${l10n.updateBandLabel} ',
                                        style: const TextStyle(
                                          fontSize: 11.5,
                                          color: AppPalette.muted,
                                        ),
                                      ),
                                      TextSpan(
                                        text: l10n.riskLowBadge.toUpperCase(),
                                        style: const TextStyle(
                                          fontSize: 11.5,
                                          fontWeight: FontWeight.w700,
                                          color: AppPalette.leaf,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  l10n.homeNextUpdate(
                                    dayMonth(context, revealed.nextUpdate),
                                  ),
                                  style: const TextStyle(
                                    fontSize: 11.5,
                                    color: AppPalette.faint,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      l10n.updateWhyMoved,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppPalette.muted,
                      ),
                    ),
                    const SizedBox(height: 7),
                    for (final ScoreReason reason in DemoData.scoreReasons)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: _ReasonCard(
                          positive: reason.isPositive,
                          text: switch (reason) {
                            ScoreReason.milkIncomeRose => l10n.reasonMilkIncome(
                              rupees(context, DemoData.milkIncomeRise),
                              monthName(context, monthBeforeClosed),
                            ),
                            ScoreReason.steadyEntries =>
                              l10n.reasonSteadyEntries(
                                DemoData.closedMonthDaysWritten,
                                DemoData.closedMonthDays,
                              ),
                            ScoreReason.fodderCostUp => l10n.reasonFodderCost(
                              rupees(context, DemoData.fodderCostRise),
                            ),
                          },
                        ),
                      ),
                    const SizedBox(height: 3),
                    Text(
                      l10n.updateFixedNote(
                        dayMonth(context, revealed.nextUpdate),
                      ),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 11.5,
                        color: AppPalette.faint,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            GradientCtaButton(
              label: l10n.updateSeeForecastCta,
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute<void>(
                    builder: (BuildContext _) => const ForecastScreen(),
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

/// The little dated chip in the header.
class _DateChip extends StatelessWidget {
  const _DateChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    // Chips stay chip-sized at accessibility text scales.
    return MediaQuery.withClampedTextScaling(
      maxScaleFactor: 1.3,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: const BoxDecoration(
          color: AppPalette.mintChip,
          borderRadius: BorderRadius.all(Radius.circular(99)),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppPalette.leaf,
          ),
        ),
      ),
    );
  }
}

/// Six months of score history as maturing green bars.
class _ScoreHistoryChart extends StatelessWidget {
  const _ScoreHistoryChart({required this.history});

  final List<(DateTime, int)> history;

  /// Bars ripen towards the fresh score, matching the mock's ramp.
  static const List<Color> _ramp = <Color>[
    Color(0xFFE4EFE6),
    Color(0xFFE4EFE6),
    Color(0xFFD5E8DA),
    Color(0xFFD5E8DA),
    Color(0xFF9CCDA9),
    AppPalette.leaf,
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        for (int i = 0; i < history.length; i++) ...<Widget>[
          if (i > 0) const SizedBox(width: 6),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  height: history[i].$2 / 100 * 50,
                  decoration: BoxDecoration(
                    color: _ramp[i.clamp(0, _ramp.length - 1)],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  monthShort(context, history[i].$1),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 9.5,
                    fontWeight: i == history.length - 1
                        ? FontWeight.w700
                        : FontWeight.w400,
                    color: i == history.length - 1
                        ? AppPalette.forest
                        : AppPalette.idle,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

/// One "why it moved" line with its up/down marker.
class _ReasonCard extends StatelessWidget {
  const _ReasonCard({required this.positive, required this.text});

  final bool positive;
  final String text;

  @override
  Widget build(BuildContext context) {
    return KhushhalCard(
      radius: 14,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            positive ? '▲' : '▼',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              height: 1.4,
              color: positive ? AppPalette.leaf : AppPalette.expense,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 13,
                height: 1.45,
                color: AppPalette.cardInk,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
