/// The officer's home screen (Officer Portal 5a).
library;

import 'package:flutter/material.dart';

import '../../data/dashboard_repository.dart';
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
import 'widgets/plan_route_coming_soon_dialog.dart';
import 'widgets/risk_queue_card.dart';
import 'widgets/visits_progress_card.dart';

/// Greeting, KPIs, score trend, risk queue, visit progress, sync notice.
class DashboardScreen extends StatefulWidget {
  /// Creates the dashboard screen.
  const DashboardScreen({super.key, required this.onSectionSelected});

  /// Called when a rail section is tapped.
  final ValueChanged<OfficerSection> onSectionSelected;

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  Future<DashboardTrends>? _trendsFuture;
  bool _loaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_loaded) {
      _loaded = true;
      _trendsFuture = OfficerSessionScope.of(context).dashboardRepository?.fetchDashboard();
    }
  }

  void _openEnterprise(
    BuildContext context,
    OfficerSession session,
    Enterprise enterprise,
  ) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext _) => EnterpriseDetailScreen(
          enterpriseId: enterprise.id,
          onSectionSelected: widget.onSectionSelected,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final OfficerSession session = OfficerSessionScope.of(context);
    final List<Enterprise> enterprises = session.enterprises;
    final int healthyCount = enterprises
        .where((Enterprise e) => e.riskLevel == RiskLevel.healthy)
        .length;
    final int watchCount = enterprises
        .where((Enterprise e) => e.riskLevel == RiskLevel.watch)
        .length;
    final int atRiskCount = enterprises
        .where((Enterprise e) => e.riskLevel == RiskLevel.atRisk)
        .length;

    return OfficerShellScaffold(
      section: OfficerSection.dashboard,
      onSectionSelected: widget.onSectionSelected,
      children: <Widget>[
        _Header(
          firstName: session.profile.fullName.trim().split(RegExp(r'\s+')).first,
          enterpriseCount: enterprises.length,
          onLogVisit: () => showAddVisitDialog(context: context),
        ),
        KpiSummaryRow(
          totalEnterpriseCount: enterprises.length,
          healthyCount: healthyCount,
          watchCount: watchCount,
          atRiskCount: atRiskCount,
        ),
        FutureBuilder<DashboardTrends>(
          future: _trendsFuture,
          builder: (BuildContext context, AsyncSnapshot<DashboardTrends> snapshot) {
            final DashboardTrends trends =
                snapshot.data ??
                (
                  averageScoreHistory: const <int>[],
                  averageScoreDelta: 0,
                  openFlagCount: 0,
                  openFlagDelta: 0,
                  visitsDoneThisWeek: 0,
                  visitsPlannedThisWeek: 0,
                );

            return LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                final RiskQueueCard riskQueue = RiskQueueCard(
                  enterprises: session.riskQueue,
                  totalFlagged: atRiskCount + watchCount,
                  onEnterpriseSelected: (Enterprise e) =>
                      _openEnterprise(context, session, e),
                  onViewAll: () => widget.onSectionSelected(OfficerSection.enterprises),
                );
                final VisitsProgressCard visitsCard = VisitsProgressCard(
                  nextVisit: session.nextVisit,
                  visitsDoneThisWeek: trends.visitsDoneThisWeek,
                  visitsPlannedThisWeek: trends.visitsPlannedThisWeek,
                  onPlanRoute: () => showPlanRouteComingSoonDialog(context: context),
                );
                final HealthScoreCard healthScoreCard = HealthScoreCard(
                  enterpriseCount: enterprises.length,
                  averageScoreHistory: trends.averageScoreHistory,
                  averageScoreDelta: trends.averageScoreDelta,
                  openFlagCount: trends.openFlagCount,
                  openFlagDelta: trends.openFlagDelta,
                );

                if (constraints.maxWidth > 860) {
                  return IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Expanded(flex: 16, child: healthScoreCard),
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
                    healthScoreCard,
                    const SizedBox(height: 14),
                    riskQueue,
                    const SizedBox(height: 14),
                    visitsCard,
                  ],
                );
              },
            );
          },
        ),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.firstName,
    required this.enterpriseCount,
    required this.onLogVisit,
  });

  final String firstName;
  final int enterpriseCount;
  final VoidCallback onLogVisit;

  static const List<String> _weekdays = <String>[
    'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun',
  ];
  static const List<String> _months = <String>[
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  String get _todayLabel {
    final DateTime now = DateTime.now();
    return '${_weekdays[now.weekday - 1]} ${now.day} ${_months[now.month - 1]} ${now.year}';
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool wide = constraints.maxWidth > 640;

        final Widget greeting = Row(
          children: <Widget>[
            const OfficerAvatar.logo(
              imageAsset: 'assets/images/khushhal_logo.jpg',
              size: 44,
            ),
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
                  Text(
                    'Health & activity of your $enterpriseCount enterprises · $_todayLabel',
                    style: const TextStyle(fontSize: 13, color: OfficerPalette.muted),
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
