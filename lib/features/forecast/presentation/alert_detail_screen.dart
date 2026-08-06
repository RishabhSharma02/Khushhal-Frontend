/// Alert detail with three actions (design 1s).
library;

import 'package:flutter/material.dart';

import '../../../app/demo_data.dart';
import '../../../app/model/insights.dart';
import '../../../app/session.dart';
import '../../../core/formatting.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/back_header.dart';
import '../../../core/widgets/info_note.dart';
import '../../../core/widgets/khushhal_card.dart';
import '../../../core/widgets/page_backdrop.dart';
import '../../../core/widgets/secondary_cta_button.dart';
import '../../../l10n/app_localizations.dart';

/// The tight-month plan: at most three actions, each with its rupee benefit
/// stated, so doing them has a visible reward.
class AlertDetailScreen extends StatelessWidget {
  /// Creates the screen.
  const AlertDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final AppSession session = SessionScope.of(context);
    final String riskMonth = monthName(
      context,
      DemoData.forecast.firstWhere((ForecastMonth m) => m.isRiskMonth).month,
    );

    return Scaffold(
      body: PageBackdrop(
        child: Column(
          children: <Widget>[
            BackHeader(title: l10n.planTitle(riskMonth)),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(height: 14),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: AppPalette.amberWash,
                        border: Border.all(
                          color: AppPalette.amberBorder,
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              const Icon(
                                Icons.warning_amber_rounded,
                                size: 20,
                                color: AppPalette.amberAccent,
                              ),
                              const SizedBox(width: 9),
                              Expanded(
                                child: Text(
                                  l10n.planTightTitle(riskMonth),
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w700,
                                    color: AppPalette.amberInk,
                                    height: 1.3,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Text(
                            l10n.planTightSubtitle(
                              rupees(context, DemoData.tightMonthSavingsFrom),
                              rupees(context, DemoData.forecastSavingsFloor),
                            ),
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppPalette.amberMuted,
                              height: 1.45,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      l10n.planDoThese,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppPalette.muted,
                      ),
                    ),
                    const SizedBox(height: 8),
                    for (int i = 0; i < session.planActions.length; i++)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 9),
                        child: _ActionCard(
                          number: i + 1,
                          action: session.planActions[i],
                          riskMonth: riskMonth,
                        ),
                      ),
                    const SizedBox(height: 3),
                    InfoNote(
                      text: l10n.planNote(
                        riskMonth,
                        rupees(context, DemoData.actionsSavingsFloor),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            SecondaryCtaButton(
              label: l10n.talkToOfficerCta,
              icon: Icons.support_agent_rounded,
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}

/// One numbered plan action with its Done toggle.
class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.number,
    required this.action,
    required this.riskMonth,
  });

  final int number;
  final PlanAction action;
  final String riskMonth;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final AppSession session = SessionScope.of(context);

    final (
      String title,
      String benefit,
      bool benefitIsGain,
    ) = switch (action.kind) {
      PlanActionKind.buyFodderEarly => (
        l10n.planFodderTitle,
        l10n.planFodderBenefit(rupees(context, DemoData.fodderActionBenefit)),
        true,
      ),
      PlanActionKind.weeklySetAside => (
        l10n.planWeeklyTitle(rupees(context, DemoData.weeklySetAside)),
        l10n.planWeeklyBenefit(
          rupees(context, DemoData.weeklySetAsideBuffer),
          riskMonth,
        ),
        true,
      ),
      PlanActionKind.moveEmiDate => (
        l10n.planEmiTitle,
        l10n.planEmiNote,
        false,
      ),
    };

    return KhushhalCard(
      radius: 16,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 26,
            height: 26,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: AppPalette.mintChip,
              shape: BoxShape.circle,
            ),
            child: Text(
              '$number',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppPalette.forest,
              ),
            ),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: AppPalette.cardInk,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  benefit,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: benefitIsGain
                        ? FontWeight.w600
                        : FontWeight.w400,
                    color: benefitIsGain ? AppPalette.leaf : AppPalette.hint,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          _DonePill(
            done: action.done,
            label: l10n.planDoneChip,
            onTap: () => session.setActionDone(action.kind, !action.done),
          ),
        ],
      ),
    );
  }
}

/// The Done toggle: outlined until tapped, forest-filled once done.
class _DonePill extends StatelessWidget {
  const _DonePill({
    required this.done,
    required this.label,
    required this.onTap,
  });

  final bool done;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: done ? AppPalette.forest : AppPalette.onPrimary,
      shape: StadiumBorder(
        side: BorderSide(
          color: done ? AppPalette.forest : AppPalette.outline,
          width: 1.5,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        customBorder: const StadiumBorder(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: done ? AppPalette.onPrimary : AppPalette.forest,
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.check,
                size: 13,
                color: done ? AppPalette.onPrimary : AppPalette.forest,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
