/// Alert detail with backend plan actions (design 1s).
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../app/session.dart';
import '../../../core/formatting.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/back_header.dart';
import '../../../core/widgets/info_note.dart';
import '../../../core/widgets/khushhal_card.dart';
import '../../../core/widgets/page_backdrop.dart';
import '../../../core/widgets/secondary_cta_button.dart';
import '../../../l10n/app_localizations.dart';
import '../../insights/bloc/insights_cubit.dart';
import '../../insights/data/insights_api.dart';
import '../../insights/data/insights_repository.dart';

// TODO: replace with the actual assigned field-officer phone once the
// backend exposes a per-user contact endpoint.
const String _fieldOfficerPhone = '+917987956779';

/// The tight-month plan pulled straight from `GET /alerts/{id}`.
///
/// Pushed from HomeScreen watch card or AlertsScreen. If [alertId] is
/// omitted (Home watch-card push) we default to the most-recent alert in
/// the session — which is what the loader mirrored from `/alerts`.
class AlertDetailScreen extends StatefulWidget {
  const AlertDetailScreen({super.key, this.alertId});

  final int? alertId;

  @override
  State<AlertDetailScreen> createState() => _AlertDetailScreenState();
}

class _AlertDetailScreenState extends State<AlertDetailScreen> {
  RemoteAlert? _detail;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _fetch());
  }

  Future<void> _fetch() async {
    final session = SessionScope.of(context);
    final businessId = session.activeBackendBusinessId;
    if (businessId == null) {
      setState(() {
        _loading = false;
        _error = 'No active business.';
      });
      return;
    }
    // Prefer explicit alertId; fall back to the first live alert.
    int? id = widget.alertId;
    if (id == null) {
      // We need the backend alert id; session.alerts is domain-typed and
      // doesn't carry it. Refetch the list via InsightsCubit's state.
      final insights = context.read<InsightsCubit>().state;
      if (insights.alerts.isNotEmpty) id = insights.alerts.first.id;
    }
    if (id == null) {
      setState(() {
        _loading = false;
        _error = 'No alert to show.';
      });
      return;
    }
    try {
      final repo = context.read<InsightsRepository>();
      final row = await repo.getAlertDetail(businessId, id);
      if (!mounted) return;
      setState(() {
        _detail = row;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = e.toString();
      });
    }
  }

  Future<void> _toggle(RemotePlanAction action) async {
    final businessId = SessionScope.of(context).activeBackendBusinessId;
    final alert = _detail;
    if (businessId == null || alert == null) return;
    try {
      final repo = context.read<InsightsRepository>();
      final updated = await repo.togglePlanAction(
        businessId: businessId,
        alertId: alert.id,
        actionId: action.id,
        done: !action.done,
      );
      if (!mounted) return;
      setState(() {
        _detail = RemoteAlert(
          id: alert.id,
          businessId: alert.businessId,
          asOn: alert.asOn,
          kind: alert.kind,
          severity: alert.severity,
          driver: alert.driver,
          hasPlan: alert.hasPlan,
          raisedOn: alert.raisedOn,
          planActions: [
            for (final a in alert.planActions)
              if (a.id == action.id) updated else a,
          ],
        );
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Update failed: $e')));
    }
  }

  Future<void> _callOfficer() async {
    final uri = Uri.parse('tel:$_fieldOfficerPhone');
    if (!await launchUrl(uri)) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not open dialer for $_fieldOfficerPhone')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final alert = _detail;
    final headerMonth = alert != null
        ? monthName(context, alert.asOn)
        : (l10n.brandName);

    return Scaffold(
      body: PageBackdrop(
        child: Column(
          children: <Widget>[
            BackHeader(title: l10n.planTitle(headerMonth)),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : (alert == null
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Text(_error ?? 'No plan available yet.',
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: AppPalette.muted)),
                          ),
                        )
                      : _buildBody(context, l10n, alert)),
            ),
            const SizedBox(height: 12),
            SecondaryCtaButton(
              label: l10n.talkToOfficerCta,
              icon: Icons.support_agent_rounded,
              onPressed: _callOfficer,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, AppLocalizations l10n, RemoteAlert alert) {
    final month = monthName(context, alert.asOn);
    // Prefer owner-facing actions if present; fall back to any actions on
    // the alert (some overlays are field-officer only).
    final ownerActions = alert.planActions.where((a) => a.role == 'owner').toList();
    final actions = ownerActions.isNotEmpty ? ownerActions : alert.planActions;
    final isHindi = Localizations.localeOf(context).languageCode == 'hi';

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(height: 14),
          _AlertBanner(month: month, driver: alert.driver, severity: alert.severity),
          const SizedBox(height: 14),
          Text(l10n.planDoThese,
              style: const TextStyle(fontSize: 13, color: AppPalette.muted)),
          const SizedBox(height: 8),
          for (int i = 0; i < actions.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 9),
              child: _ActionCard(
                number: i + 1,
                title: _labelFor(actions[i], isHindi),
                done: actions[i].done,
                onToggle: () => _toggle(actions[i]),
                doneLabel: l10n.planDoneChip,
              ),
            ),
          const SizedBox(height: 8),
          InfoNote(text: 'Marking actions done here helps the ML model re-score your business next month.'),
        ],
      ),
    );
  }

  String _labelFor(RemotePlanAction a, bool isHindi) {
    if (isHindi && a.labelHi != null && a.labelHi!.isNotEmpty) return a.labelHi!;
    return a.labelEn;
  }
}

class _AlertBanner extends StatelessWidget {
  const _AlertBanner({required this.month, required this.driver, required this.severity});
  final String month;
  final String driver;
  final String severity;

  @override
  Widget build(BuildContext context) {
    final urgent = severity == 'urgent';
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: urgent ? AppPalette.amberWash : AppPalette.mintWash,
        border: Border.all(color: urgent ? AppPalette.amberBorder : AppPalette.line, width: 1.5),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                urgent ? Icons.warning_amber_rounded : Icons.info_outline_rounded,
                size: 20,
                color: urgent ? AppPalette.amberAccent : AppPalette.forest,
              ),
              const SizedBox(width: 9),
              Expanded(
                child: Text(
                  _driverTitle(driver, month),
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: urgent ? AppPalette.amberInk : AppPalette.forest,
                    height: 1.3,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            _driverSubtitle(driver),
            style: TextStyle(
              fontSize: 13,
              color: urgent ? AppPalette.amberMuted : AppPalette.body,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }

  String _driverTitle(String driver, String month) => switch (driver) {
        'liquidity_debt_stress' => 'Cash buffer is tight',
        'climate_stress_deficit' => 'Rainfall below normal',
        'climate_stress_excess' => 'Rainfall higher than usual',
        'market_stress' => 'Market prices moved against you',
        'new_business' => 'Fresh business — extra care needed',
        _ => 'Watch out for $month',
      };

  String _driverSubtitle(String driver) => switch (driver) {
        'liquidity_debt_stress' => 'Savings or debt cover is low. The steps below rebuild your buffer.',
        'climate_stress_deficit' => 'Local rain is below normal — expect input prices to rise.',
        'climate_stress_excess' => 'Heavier than usual rainfall — protect stored inputs.',
        'market_stress' => 'Terms of trade have moved against your sector.',
        'new_business' => 'A newer business needs closer daily tracking.',
        _ => 'Follow the steps below to stay on track.',
      };
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.number,
    required this.title,
    required this.done,
    required this.onToggle,
    required this.doneLabel,
  });

  final int number;
  final String title;
  final bool done;
  final VoidCallback onToggle;
  final String doneLabel;

  @override
  Widget build(BuildContext context) {
    return KhushhalCard(
      radius: 16,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 26, height: 26,
            alignment: Alignment.center,
            decoration: const BoxDecoration(color: AppPalette.mintChip, shape: BoxShape.circle),
            child: Text('$number',
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppPalette.forest)),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
                color: done ? AppPalette.muted : AppPalette.cardInk,
                decoration: done ? TextDecoration.lineThrough : null,
                height: 1.4,
              ),
            ),
          ),
          const SizedBox(width: 10),
          _DonePill(done: done, label: doneLabel, onTap: onToggle),
        ],
      ),
    );
  }
}

class _DonePill extends StatelessWidget {
  const _DonePill({required this.done, required this.label, required this.onTap});
  final bool done;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: done ? AppPalette.forest : AppPalette.onPrimary,
      shape: StadiumBorder(
        side: BorderSide(color: done ? AppPalette.forest : AppPalette.outline, width: 1.5),
      ),
      child: InkWell(
        onTap: onTap,
        customBorder: const StadiumBorder(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: done ? AppPalette.onPrimary : AppPalette.forest,
                  )),
              const SizedBox(width: 4),
              Icon(Icons.check, size: 13, color: done ? AppPalette.onPrimary : AppPalette.forest),
            ],
          ),
        ),
      ),
    );
  }
}
