/// The officer's home screen (Officer Portal 5a).
library;

import 'package:flutter/material.dart';

import '../../data/officer_demo_data.dart';
import '../../domain/enterprise.dart';
import '../enterprises/enterprise_detail_screen.dart';
import '../officer_session.dart';
import '../theme/officer_palette.dart';
import '../visits/widgets/add_visit_dialog.dart';
import '../widgets/officer_avatar.dart';
import '../widgets/officer_buttons.dart';
import '../widgets/officer_nav_rail.dart';
import '../widgets/officer_shell_scaffold.dart';
import 'widgets/health_score_card.dart';
import 'widgets/kpi_summary_row.dart';
import 'widgets/risk_queue_card.dart';
import 'widgets/visits_progress_card.dart';

/// Greeting, KPIs, score trend, risk queue, visit progress, sync notice.
class DashboardScreen extends StatelessWidget {
  /// Creates the dashboard screen.
  const DashboardScreen({super.key, required this.onSectionSelected});

  /// Called when a rail section is tapped.
  final ValueChanged<OfficerSection> onSectionSelected;

  void _openEnterprise(
    BuildContext context,
    OfficerSession session,
    Enterprise enterprise,
  ) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext _) => EnterpriseDetailScreen(
          enterpriseId: enterprise.id,
          onSectionSelected: onSectionSelected,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final OfficerSession session = OfficerSessionScope.of(context);

    return OfficerShellScaffold(
      section: OfficerSection.dashboard,
      onSectionSelected: onSectionSelected,
      children: <Widget>[
        _Header(
          firstName: session.profile.fullName.trim().split(RegExp(r'\s+')).first,
          onLogVisit: () => showAddVisitDialog(context: context),
        ),
        const KpiSummaryRow(),
        LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final RiskQueueCard riskQueue = RiskQueueCard(
              enterprises: session.riskQueue,
              totalFlagged:
                  OfficerDemoData.atRiskCount + OfficerDemoData.watchCount,
              onEnterpriseSelected: (Enterprise e) =>
                  _openEnterprise(context, session, e),
              onViewAll: () => onSectionSelected(OfficerSection.enterprises),
            );
            final VisitsProgressCard visitsCard = VisitsProgressCard(
              nextVisit: session.nextVisit,
              onPlanRoute: () => onSectionSelected(OfficerSection.visits),
            );

            if (constraints.maxWidth > 860) {
              return IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    const Expanded(flex: 16, child: HealthScoreCard()),
                    const SizedBox(width: 14),
                    Expanded(flex: 10, child: riskQueue),
                    const SizedBox(width: 14),
                    Expanded(flex: 10, child: visitsCard),
                  ],
                ),
              );
            }

            return Column(
              children: <Widget>[
                const HealthScoreCard(),
                const SizedBox(height: 14),
                riskQueue,
                const SizedBox(height: 14),
                visitsCard,
              ],
            );
          },
        ),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.firstName, required this.onLogVisit});

  final String firstName;
  final VoidCallback onLogVisit;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool wide = constraints.maxWidth > 640;

        final Widget greeting = Row(
          children: <Widget>[
            const OfficerAvatar(text: '☘', size: 44, fontSize: 20),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    'Hello, $firstName!',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: OfficerPalette.ink,
                    ),
                  ),
                  const Text(
                    'Health & activity of your 48 enterprises · Fri 1 Aug 2026',
                    style: TextStyle(fontSize: 13, color: OfficerPalette.muted),
                  ),
                ],
              ),
            ),
          ],
        );

        final Widget cta = OfficerPrimaryButton(
          label: '+ Log visit',
          expand: false,
          onPressed: onLogVisit,
        );

        if (wide) {
          return Row(
            children: <Widget>[
              Expanded(child: greeting),
              const SizedBox(width: 14),
              cta,
            ],
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[greeting, const SizedBox(height: 12), cta],
        );
      },
    );
  }
}
