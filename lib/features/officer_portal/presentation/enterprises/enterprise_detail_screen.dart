/// The full enterprise file: money, forecast, plan, history (Officer
/// Portal 5c).
library;

import 'package:flutter/material.dart';

import '../../data/officer_demo_data.dart';
import '../../domain/action_step.dart';
import '../../domain/enterprise.dart';
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
class EnterpriseDetailScreen extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final OfficerSession session = OfficerSessionScope.of(context);
    final Enterprise enterprise = session.enterpriseById(enterpriseId);

    return OfficerShellScaffold(
      section: OfficerSection.enterprises,
      onSectionSelected: (OfficerSection section) {
        onSectionSelected(section);
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
                  CashFlowForecastChart(
                    months: OfficerDemoData.cashFlowFor(enterprise),
                  ),
                  if (enterprise.id == 'shanti-dairy')
                    const AiFlagBanner(
                      narrative: OfficerDemoData.shantiDairyFlagNarrative,
                    ),
                ],
              ),
            );

            final List<Widget> left = <Widget>[
              chartCard,
              const SizedBox(height: 14),
              ContactHistoryCard(
                entries: session.contactHistoryFor(enterprise),
                onAddNote: () => showAddNoteDialog(
                  context: context,
                  enterpriseId: enterprise.id,
                ),
              ),
            ];

            final List<Widget> right = <Widget>[
              ActionPlanCard(
                steps: session.actionStepsFor(enterprise),
                gapLabel: enterprise.flagSummary ?? '',
                onAddStepManually: () => showAddActionStepDialog(
                  context: context,
                  enterpriseId: enterprise.id,
                ),
                onEditStep: (ActionStep step) => showAddActionStepDialog(
                  context: context,
                  enterpriseId: enterprise.id,
                  existingStep: step,
                ),
                onDeleteStep: (ActionStep step) => session.removeActionStep(
                  enterpriseId: enterprise.id,
                  step: step,
                ),
              ),
              const SizedBox(height: 14),
              _DataQuality(enterprise: enterprise),
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
  const _DataQuality({required this.enterprise});

  final Enterprise enterprise;

  @override
  Widget build(BuildContext context) {
    final ({int entryStreakDaysPerWeek, int forecastConfidencePercent})
    quality = OfficerDemoData.dataQualityFor(enterprise);

    return DataQualityCard(
      entryStreakDaysPerWeek: quality.entryStreakDaysPerWeek,
      lastSyncLabel: enterprise.lastSyncHoursAgo == null
          ? '${enterprise.staleDays}d ⚠'
          : '${enterprise.lastSyncHoursAgo}h ago ✓',
      forecastConfidencePercent: quality.forecastConfidencePercent,
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
