/// Risk alerts list (design 1r).
library;

import 'package:flutter/material.dart';

import '../../../app/model/insights.dart';
import '../../../app/session.dart';
import '../../../core/formatting.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/back_header.dart';
import '../../../core/widgets/choice_pill.dart';
import '../../../core/widgets/page_backdrop.dart';
import '../../../core/widgets/secondary_cta_button.dart';
import '../../../l10n/app_localizations.dart';
import 'alert_detail_screen.dart';

/// Alerts with severity filters and the SMS fallback note.
///
/// Every alert says what happened, why it matters to this business, and —
/// when there is one — the next step. Urgent alerts wear amber and sit on
/// top.
class AlertsScreen extends StatefulWidget {
  /// Creates the screen.
  const AlertsScreen({super.key});

  @override
  State<AlertsScreen> createState() => _AlertsScreenState();
}

/// The list filter along the top.
enum _Filter { all, urgent, info }

class _AlertsScreenState extends State<AlertsScreen> {
  _Filter _filter = _Filter.all;

  bool _matches(RiskAlert alert) {
    return switch (_filter) {
      _Filter.all => true,
      _Filter.urgent => alert.severity == AlertSeverity.urgent,
      _Filter.info => alert.severity == AlertSeverity.info,
    };
  }

  void _openPlan([int? alertId]) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext _) => AlertDetailScreen(alertId: alertId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final AppSession session = SessionScope.of(context);
    final List<RiskAlert> alerts = session.alerts;
    final ForecastMonth? riskMonth = session.forecast.flaggedRiskMonth;
    final int urgentCount = alerts
        .where((RiskAlert a) => a.severity == AlertSeverity.urgent)
        .length;

    return Scaffold(
      body: PageBackdrop(
        child: Column(
          children: <Widget>[
            BackHeader(title: l10n.alertsTitle),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(height: 14),
                    Wrap(
                      spacing: 7,
                      runSpacing: 7,
                      children: <Widget>[
                        ChoicePill(
                          label: l10n.alertsFilterAll(alerts.length),
                          selected: _filter == _Filter.all,
                          onTap: () => setState(() => _filter = _Filter.all),
                        ),
                        ChoicePill(
                          label: l10n.alertsFilterUrgent(urgentCount),
                          selected: _filter == _Filter.urgent,
                          onTap: () => setState(() => _filter = _Filter.urgent),
                        ),
                        ChoicePill(
                          label: l10n.alertsFilterInfo,
                          selected: _filter == _Filter.info,
                          onTap: () => setState(() => _filter = _Filter.info),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    for (final RiskAlert alert in alerts.where(
                      _matches,
                    )) ...<Widget>[
                      _AlertCard(
                        alert: alert,
                        riskMonth: riskMonth,
                        onOpenPlan: () => _openPlan(alert.backendId),
                      ),
                      const SizedBox(height: 9),
                    ],
                    const SizedBox(height: 3),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFFC9D8CC)),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Icon(
                            Icons.sms_outlined,
                            size: 15,
                            color: AppPalette.hint,
                          ),
                          const SizedBox(width: 9),
                          Flexible(
                            child: Text(
                              l10n.alertsSmsNote,
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppPalette.hint,
                                height: 1.4,
                              ),
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

/// One alert row; the urgent one wears amber and opens the plan.
class _AlertCard extends StatelessWidget {
  const _AlertCard({
    required this.alert,
    required this.riskMonth,
    required this.onOpenPlan,
  });

  final RiskAlert alert;

  /// The month the live forecast flags, or null when it flags none — the
  /// savings alert names it instead of naming the month it was stamped in.
  final ForecastMonth? riskMonth;

  final VoidCallback onOpenPlan;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final bool urgent = alert.severity == AlertSeverity.urgent;

    final (String title, String detail) = switch (alert.kind) {
      AlertKind.savingsRunningLow => (
        riskMonth == null
            ? l10n.alertSavingsTitleNoMonth
            : l10n.alertSavingsTitle(monthName(context, riskMonth!.month)),
        alert.raisedOn == null
            ? l10n.alertSavingsDetailUndated
            : l10n.alertSavingsDetail(dayMonth(context, alert.raisedOn!)),
      ),
      AlertKind.fodderPriceUp => (
        l10n.alertFodderTitle,
        l10n.alertFodderDetail(
          alert.raisedOn == null ? '' : dayMonth(context, alert.raisedOn!),
        ),
      ),
      AlertKind.heavyRain => (l10n.alertRainTitle, l10n.alertRainDetail),
    };

    final Widget body = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Icon(
          urgent ? Icons.warning_amber_rounded : Icons.info_outline_rounded,
          size: 20,
          color: urgent ? AppPalette.amberAccent : AppPalette.leaf,
        ),
        const SizedBox(width: 11),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  height: 1.4,
                  color: urgent ? AppPalette.amberInk : AppPalette.cardInk,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                detail,
                style: TextStyle(
                  fontSize: 12,
                  height: 1.45,
                  color: urgent ? AppPalette.amberMuted : AppPalette.hint,
                ),
              ),
              if (alert.hasPlan) ...<Widget>[
                const SizedBox(height: 4),
                Text(
                  l10n.alertSavingsAction,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppPalette.forest,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );

    if (urgent) {
      return Material(
        color: AppPalette.amberWash,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppPalette.amberBorder, width: 1.5),
        ),
        child: InkWell(
          onTap: alert.hasPlan ? onOpenPlan : null,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
            child: body,
          ),
        ),
      );
    }

    // Non-urgent alerts also open the plan when the backend attached one —
    // green- and amber-risk businesses now carry sector×band actionables
    // via `savings_low`, and the tap was silently a no-op before.
    return Material(
      color: AppPalette.onPrimary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppPalette.line, width: 1.5),
      ),
      child: InkWell(
        onTap: alert.hasPlan ? onOpenPlan : null,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
          child: body,
        ),
      ),
    );
  }
}
