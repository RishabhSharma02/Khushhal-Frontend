/// The full enterprise file: money, forecast, plan, history (Officer
/// Portal 5c).
library;

import 'package:flutter/material.dart';

import '../../data/enterprises_repository.dart' show DataQuality;
import '../../domain/action_step.dart';
import '../../domain/contact_log.dart';
import '../../domain/enterprise.dart';
import '../../domain/forecast_month.dart';
import '../officer_session.dart';
import '../theme/officer_palette.dart';
import '../widgets/officer_card.dart';
import '../widgets/officer_nav_rail.dart';
import '../widgets/officer_shell_scaffold.dart';
import 'widgets/action_plan_card.dart';
import 'widgets/add_action_step_dialog.dart';
import 'widgets/add_note_dialog.dart';
import 'widgets/ai_flag_banner.dart';
import 'widgets/cash_flow_forecast_chart.dart';
import 'widgets/contact_history_card.dart';
import 'widgets/data_quality_card.dart';
import 'widgets/enterprise_header_card.dart';

/// One enterprise's full file — money, forecast, plan, history, quality.
class EnterpriseDetailScreen extends StatefulWidget {
  /// Creates the enterprise detail screen.
  const EnterpriseDetailScreen({
    super.key,
    required this.enterpriseId,
    required this.onSectionSelected,
  });

  /// Which enterprise to show.
  final String enterpriseId;

  /// Called when a rail section is tapped — also pops this pushed screen.
  final ValueChanged<OfficerSection> onSectionSelected;

  @override
  State<EnterpriseDetailScreen> createState() => _EnterpriseDetailScreenState();
}

class _EnterpriseDetailScreenState extends State<EnterpriseDetailScreen> {
  Future<List<CashFlowMonth>>? _cashFlowFuture;
  Future<DataQuality>? _dataQualityFuture;
  Future<List<ActionStep>>? _actionStepsFuture;
  Future<List<ContactLogEntry>>? _contactHistoryFuture;
  String? _loadedForId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Guarded by enterpriseId so this only (re-)fetches when navigating to
    // a different enterprise — not on every session change (e.g. adding an
    // action step notifies listeners too, and this screen depends on the
    // session via OfficerSessionScope.of(context) below).
    if (_loadedForId != widget.enterpriseId) {
      _loadedForId = widget.enterpriseId;
      final OfficerSession session = OfficerSessionScope.of(context);
      _cashFlowFuture = session.enterprisesRepository?.fetchCashFlow(widget.enterpriseId);
      _dataQualityFuture = session.enterprisesRepository?.fetchDataQuality(widget.enterpriseId);
      _actionStepsFuture = session.actionPlanRepository?.fetchActionSteps(widget.enterpriseId);
      _contactHistoryFuture = session.actionPlanRepository?.fetchContactLog(widget.enterpriseId);
    }
  }

  void _reloadActionSteps() {
    final OfficerSession session = OfficerSessionScope.of(context);
    setState(() {
      _actionStepsFuture = session.actionPlanRepository?.fetchActionSteps(widget.enterpriseId);
    });
  }

  void _reloadContactHistory() {
    final OfficerSession session = OfficerSessionScope.of(context);
    setState(() {
      _contactHistoryFuture = session.actionPlanRepository?.fetchContactLog(widget.enterpriseId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final OfficerSession session = OfficerSessionScope.of(context);
    final Enterprise enterprise = session.enterpriseById(widget.enterpriseId);

    return OfficerShellScaffold(
      section: OfficerSection.enterprises,
      onSectionSelected: (OfficerSection section) {
        widget.onSectionSelected(section);
        Navigator.of(context).pop();
      },
      children: <Widget>[
        GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Text.rich(
            TextSpan(
              children: <InlineSpan>[
                const TextSpan(
                  text: 'Enterprises',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: OfficerPalette.forest,
                  ),
                ),
                TextSpan(text: ' › ${enterprise.name}'),
              ],
            ),
            style: const TextStyle(fontSize: 12.5, color: OfficerPalette.muted),
          ),
        ),
        EnterpriseHeaderCard(
          enterprise: enterprise,
          onScheduleVisit: () => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Coming soon.')),
          ),
        ),
        _StatRow(enterprise: enterprise),
        LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final Widget chartCard = OfficerCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  FutureBuilder<List<CashFlowMonth>>(
                    future: _cashFlowFuture,
                    builder: (BuildContext context, AsyncSnapshot<List<CashFlowMonth>> snapshot) {
                      if (!snapshot.hasData) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 32),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                      return CashFlowForecastChart(months: snapshot.data!);
                    },
                  ),
                  if (enterprise.flagSummary != null)
                    AiFlagBanner(narrative: enterprise.flagSummary!),
                ],
              ),
            );

            final List<Widget> left = <Widget>[
              chartCard,
              const SizedBox(height: 14),
              FutureBuilder<List<ContactLogEntry>>(
                future: _contactHistoryFuture,
                builder: (BuildContext context, AsyncSnapshot<List<ContactLogEntry>> snapshot) {
                  return ContactHistoryCard(
                    entries: snapshot.data ?? const <ContactLogEntry>[],
                    onAddNote: () => showAddNoteDialog(
                      context: context,
                      onSubmit: ({
                        required DateTime date,
                        required ContactKind kind,
                        required String note,
                      }) async {
                        await session.actionPlanRepository?.addContactNote(
                          enterprise.id,
                          date: date,
                          kind: kind,
                          note: note,
                        );
                        _reloadContactHistory();
                      },
                    ),
                  );
                },
              ),
            ];

            final List<Widget> right = <Widget>[
              FutureBuilder<List<ActionStep>>(
                future: _actionStepsFuture,
                builder: (BuildContext context, AsyncSnapshot<List<ActionStep>> snapshot) {
                  return ActionPlanCard(
                    steps: snapshot.data ?? const <ActionStep>[],
                    gapLabel: enterprise.flagSummary ?? '',
                    onAddStepManually: () => showAddActionStepDialog(
                      context: context,
                      onSubmit: ({
                        required String title,
                        required String detail,
                        required ActionStepImpact impact,
                      }) async {
                        await session.actionPlanRepository?.addActionStep(
                          enterprise.id,
                          title: title,
                          detail: detail,
                          impact: impact,
                        );
                        _reloadActionSteps();
                      },
                    ),
                    onEditStep: (ActionStep step) => showAddActionStepDialog(
                      context: context,
                      existingStep: step,
                      onSubmit: ({
                        required String title,
                        required String detail,
                        required ActionStepImpact impact,
                      }) async {
                        await session.actionPlanRepository?.updateActionStep(
                          enterprise.id,
                          step.id!,
                          title: title,
                          detail: detail,
                          impact: impact,
                        );
                        _reloadActionSteps();
                      },
                    ),
                    onDeleteStep: (ActionStep step) async {
                      await session.actionPlanRepository?.deleteActionStep(enterprise.id, step.id!);
                      _reloadActionSteps();
                    },
                  );
                },
              ),
              const SizedBox(height: 14),
              _DataQuality(enterprise: enterprise, dataQualityFuture: _dataQualityFuture),
            ];

            if (constraints.maxWidth > 900) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: left,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: right,
                    ),
                  ),
                ],
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[...left, const SizedBox(height: 14), ...right],
            );
          },
        ),
      ],
    );
  }
}

class _DataQuality extends StatelessWidget {
  const _DataQuality({required this.enterprise, required this.dataQualityFuture});

  final Enterprise enterprise;
  final Future<DataQuality>? dataQualityFuture;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DataQuality>(
      future: dataQualityFuture,
      builder: (BuildContext context, AsyncSnapshot<DataQuality> snapshot) {
        final DataQuality quality =
            snapshot.data ?? (entryStreakDaysPerWeek: 0, forecastConfidencePercent: 0);

        return DataQualityCard(
          entryStreakDaysPerWeek: quality.entryStreakDaysPerWeek,
          lastSyncLabel: enterprise.lastSyncHoursAgo == null
              ? '${enterprise.staleDays}d ⚠'
              : '${enterprise.lastSyncHoursAgo}h ago ✓',
          forecastConfidencePercent: quality.forecastConfidencePercent,
        );
      },
    );
  }
}

class _StatRow extends StatelessWidget {
  const _StatRow({required this.enterprise});

  final Enterprise enterprise;

  @override
  Widget build(BuildContext context) {
    final bool netPositive = enterprise.financials.monthNetInr >= 0;

    final List<Widget> tiles = <Widget>[
      _StatTile(
        label: 'CASH TODAY',
        value: '₹${_money(enterprise.financials.cashOnHandInr)}',
      ),
      _StatTile(
        label: 'MONTH NET',
        value:
            '${netPositive ? '+' : '-'}₹${_money(enterprise.financials.monthNetInr.abs())}',
        valueColor: netPositive
            ? OfficerPalette.statusGreen
            : OfficerPalette.statusRed,
      ),
      _StatTile(
        label: 'SAVINGS',
        value: '₹${_money(enterprise.financials.savingsInr)}',
      ),
      _StatTile(
        label: 'LOAN LEFT',
        value: '₹${_money(enterprise.financials.loanLeftInr)}',
        caption:
            'EMI ₹${_money(enterprise.financials.emiInr)} · '
            '${enterprise.financials.emiOnTime ? 'on time ✓' : 'behind ⚠'}',
      ),
    ];

    // Every tile in a row is stretched to match the tallest — otherwise the
    // one tile with a caption (LOAN LEFT) ends up taller than the rest.
    Widget evenRow(List<Widget> row) {
      return IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            for (final Widget tile in row) ...<Widget>[
              Expanded(child: tile),
              if (tile != row.last) const SizedBox(width: 12),
            ],
          ],
        ),
      );
    }

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth > 640) {
          return evenRow(tiles);
        }

        return Column(
          children: <Widget>[
            evenRow(tiles.sublist(0, 2)),
            const SizedBox(height: 12),
            evenRow(tiles.sublist(2, 4)),
          ],
        );
      },
    );
  }

  static String _money(int value) {
    final String digits = value.toString();
    final StringBuffer buffer = StringBuffer();
    for (int i = 0; i < digits.length; i++) {
      final int fromEnd = digits.length - i;
      if (i != 0 && fromEnd % 3 == 0 && fromEnd != digits.length) {
        buffer.write(',');
      }
      buffer.write(digits[i]);
    }
    return buffer.toString();
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.label,
    required this.value,
    this.valueColor = OfficerPalette.ink,
    this.caption,
  });

  final String label;
  final String value;
  final Color valueColor;
  final String? caption;

  @override
  Widget build(BuildContext context) {
    return OfficerCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: OfficerPalette.muted,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: valueColor,
            ),
          ),
          if (caption != null)
            Text(
              caption!,
              style: const TextStyle(
                fontSize: 10.5,
                color: OfficerPalette.muted,
              ),
            ),
        ],
      ),
    );
  }
}
