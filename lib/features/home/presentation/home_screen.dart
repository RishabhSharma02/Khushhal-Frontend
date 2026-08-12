/// Home — the health card and the day's numbers (designs 1o, 1o2, 1u).
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/demo_data.dart';
import '../../../app/model/insights.dart';
import '../../../app/session.dart';
import '../../../core/formatting.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/gradient_cta_button.dart';
import '../../../core/widgets/khushhal_card.dart';
import '../../../core/widgets/shimmer_box.dart';
import '../../../core/widgets/sync_chip.dart';
import '../../../l10n/app_localizations.dart';
import '../../insights/bloc/insights_cubit.dart';
import '../../entries/presentation/add_entry_screen.dart';
import '../../forecast/presentation/alert_detail_screen.dart';
import '../../forecast/presentation/alerts_screen.dart';
import '../../forecast/presentation/forecast_screen.dart';
import '../../forecast/presentation/monthly_update_screen.dart';
import '../../money/presentation/savings_loan_screen.dart';
import '../../sync/presentation/sync_screen.dart';
import 'widgets/business_pill.dart';
import 'widgets/health_card.dart';
import 'widgets/money_tiles.dart';
import 'widgets/watch_card.dart';

/// The home tab in its three states.
///
/// Normally (1o) it shows the stamped score, four live numbers and one
/// watch item. When the month has closed (1o2) a banner and a NEW stamp
/// appear and the main button becomes the reveal. Offline (1u) it slims to
/// what runs on-device and says so, calmly — offline is a state here, not
/// an error.
class HomeScreen extends StatelessWidget {
  /// Creates the home tab.
  const HomeScreen({super.key});

  void _push(BuildContext context, Widget screen) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (BuildContext _) => screen));
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final AppSession session = SessionScope.of(context);
    final bool offline = session.connectivity == ConnectivityStatus.offline;
    final bool updateReady = session.updateReady;

    // Safe against an empty forecast (fresh install, no ML score yet).
    ForecastMonth? riskMonth;
    if (session.forecast.isNotEmpty) {
      riskMonth = session.forecast.firstWhere(
        (ForecastMonth m) => m.isRiskMonth,
        orElse: () => session.forecast.last,
      );
    }

    final List<Widget> body;

    if (offline) {
      body = <Widget>[
        // Wrap, not Row: at the largest text sizes the chip drops to its own
        // line instead of overflowing the 320px screens this app targets.
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 8,
          runSpacing: 6,
          children: <Widget>[
            Text(
              l10n.brandName,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppPalette.forest,
                height: 1.3,
              ),
            ),
            SyncChip(
              status: session.connectivity,
              onTap: () => _push(context, const SyncScreen()),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _OfflineBanner(count: session.pendingEntryCount),
        const SizedBox(height: 12),
        if (session.health != null)
          _OfflineHealthCard(health: session.health!)
        else
          const _HealthCardSkeleton(),
        const SizedBox(height: 10),
        const MoneyTileGrid(compact: true),
        const SizedBox(height: 12),
        GradientCtaButton(
          label: l10n.homeWriteEntryCta,
          icon: Icons.edit_rounded,
          onPressed: () => _push(context, const AddEntryScreen()),
        ),
      ];
    } else {
      body = <Widget>[
        // Wrap, not Row: at the largest text sizes the chip drops to its own
        // line instead of overflowing the 320px screens this app targets.
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 8,
          runSpacing: 6,
          children: <Widget>[
            BusinessPill(
              label: session.activeBusiness?.name ?? l10n.brandName,
              onTap: () => showBusinessSwitcher(context),
            ),
            SyncChip(
              status: session.connectivity,
              onTap: () => _push(context, const SyncScreen()),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          l10n.homeSwitchHint,
          style: const TextStyle(
            fontSize: 11.5,
            color: AppPalette.faint,
            height: 1.3,
          ),
        ),
        const SizedBox(height: 10),
        if (updateReady) ...<Widget>[
          _MonthClosedBanner(
            month: monthName(
              context,
              _monthBefore(session.pendingHealth!.asOn),
            ),
          ),
          const SizedBox(height: 10),
        ],
        // Show a shimmering placeholder while the insights cubit is
        // fetching from the backend for the first time; once data lands
        // (or the fetch fails and we stay on demo data) the real card
        // renders.
        BlocBuilder<InsightsCubit, InsightsState>(
          builder: (context, s) {
            final live = session.health;
            if (live == null) return const _HealthCardSkeleton();
            return HealthCard(
              businessName: session.activeBusiness?.name ?? l10n.brandName,
              health: live,
              pending: session.pendingHealth,
              onTap: () => _push(context, const ForecastScreen()),
            );
          },
        ),
        const SizedBox(height: 10),
        MoneyTileGrid(
          onEditTap: () => _push(context, const SavingsLoanScreen()),
        ),
        // Watch section only appears when the backend surfaces at least
        // one alert AND the ML has flagged a risk month in the forecast.
        if (session.alerts.isNotEmpty && riskMonth != null) ...<Widget>[
          const SizedBox(height: 14),
          Text(
            l10n.homeWatch,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppPalette.muted,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 7),
          WatchCard(
            riskMonthLabel: monthShort(context, riskMonth.month),
            fromForecast: updateReady,
            onOpenAlerts: () => _push(context, const AlertsScreen()),
            onOpenPlan: () => _push(context, const AlertDetailScreen()),
          ),
        ],
      ];
    }

    return Column(
      children: <Widget>[
        Expanded(
          child: ListView(
            padding: const EdgeInsets.only(bottom: 8),
            children: body,
          ),
        ),
        if (!offline) ...<Widget>[
          const SizedBox(height: 8),
          if (updateReady)
            GradientCtaButton(
              label: l10n.homeSeeChangedCta,
              icon: Icons.auto_awesome_rounded,
              onPressed: () => _push(context, const MonthlyUpdateScreen()),
            )
          else
            GradientCtaButton(
              label: l10n.homeWriteEntryCta,
              icon: Icons.edit_rounded,
              onPressed: () => _push(context, const AddEntryScreen()),
            ),
        ],
      ],
    );
  }

  static DateTime _monthBefore(DateTime date) {
    return DateTime(date.year, date.month - 1, 1);
  }
}

/// The green month-closed banner above the health card (1o2).
class _MonthClosedBanner extends StatelessWidget {
  const _MonthClosedBanner({required this.month});

  final String month;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[AppPalette.forest, AppPalette.leaf],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppPalette.forest.withValues(alpha: 0.6),
            offset: const Offset(0, 14),
            blurRadius: 30,
            spreadRadius: -16,
          ),
        ],
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: AppPalette.onPrimary.withValues(alpha: 0.16),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.auto_awesome_rounded,
              size: 16,
              color: AppPalette.onPrimary,
            ),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Text(
              l10n.homeMonthClosedBanner(month),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppPalette.onPrimary,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// The amber "no network" note (1u).
class _OfflineBanner extends StatelessWidget {
  const _OfflineBanner({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      decoration: BoxDecoration(
        color: AppPalette.amberWash,
        border: Border.all(color: AppPalette.amberBorder),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        l10n.offlineBanner(count),
        style: const TextStyle(
          fontSize: 12.5,
          color: AppPalette.amberInk,
          height: 1.5,
        ),
      ),
    );
  }
}

/// The slimmed-down score card shown offline (1u).
class _OfflineHealthCard extends StatelessWidget {
  const _OfflineHealthCard({required this.health});

  final HealthSnapshot health;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;

    return KhushhalCard(
      radius: 20,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: <Widget>[
          Text(
            l10n.offlineHealthHeadline,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppPalette.forest,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            l10n.offlineScoreLine(health.score, dayMonth(context, health.asOn)),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12.5,
              color: AppPalette.muted,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 10),
          Container(height: 1, color: AppPalette.line),
          const SizedBox(height: 9),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Icon(
                Icons.storefront_rounded,
                size: 14,
                color: AppPalette.faint,
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  l10n.offlineMandiStale(DemoData.mandiStaleDays),
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppPalette.faint,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Skeleton shown while insights load for the active business for the
/// first time. Matches HealthCard's rough footprint so the layout doesn't
/// jump when data arrives.
class _HealthCardSkeleton extends StatelessWidget {
  const _HealthCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return ShimmerBox(
      child: KhushhalCard(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const <Widget>[
            SkeletonBar(width: 140, height: 12),
            SizedBox(height: 12),
            SkeletonBar(width: 90, height: 36),
            SizedBox(height: 20),
            SkeletonBar(height: 8, radius: 99),
            SizedBox(height: 12),
            SkeletonBar(width: 200, height: 12),
          ],
        ),
      ),
    );
  }
}
