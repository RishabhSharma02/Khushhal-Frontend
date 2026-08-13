/// The enterprises table (Officer Portal 5b).
library;

import 'package:flutter/material.dart';

import '../../../domain/enterprise.dart';
import '../../theme/officer_palette.dart';
import '../../widgets/officer_card.dart';
import '../../widgets/status_chip.dart';

/// A responsive table of enterprises — columns collapse to a card list
/// below [_stackBreakpoint].
class EnterpriseTable extends StatelessWidget {
  /// Creates the enterprise table.
  const EnterpriseTable({
    super.key,
    required this.enterprises,
    required this.onSelected,
  });

  /// Rows to show, already filtered/sorted.
  final List<Enterprise> enterprises;

  /// Called when a row is tapped.
  final ValueChanged<Enterprise> onSelected;

  static const double _stackBreakpoint = 760;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool stacked = constraints.maxWidth < _stackBreakpoint;

        return OfficerCard(
          padding: EdgeInsets.symmetric(
            vertical: stacked ? 6 : 4,
            horizontal: stacked ? 6 : 6,
          ),
          child: Column(
            children: <Widget>[
              if (!stacked) const _TableHeader(),
              for (final Enterprise enterprise in enterprises)
                InkWell(
                  onTap: () => onSelected(enterprise),
                  child: stacked
                      ? _StackedRow(enterprise: enterprise)
                      : _TableRow(enterprise: enterprise),
                ),
              if (enterprises.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Center(
                    child: Text(
                      'No enterprises match this filter',
                      style: TextStyle(
                        fontSize: 12.5,
                        color: OfficerPalette.muted,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

const List<int> _flex = <int>[22, 11, 11, 7, 10, 15, 9];

class _TableHeader extends StatelessWidget {
  const _TableHeader();

  static const List<String> _labels = <String>[
    'ENTERPRISE / OWNER',
    'VILLAGE',
    'TYPE · SECTOR',
    'SCORE',
    'CASH',
    'FLAG',
    'LAST SYNC',
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        children: <Widget>[
          for (int i = 0; i < _labels.length; i++)
            Expanded(
              flex: _flex[i],
              child: Text(
                _labels[i],
                style: const TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.4,
                  color: OfficerPalette.muted,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _TableRow extends StatelessWidget {
  const _TableRow({required this.enterprise});

  final Enterprise enterprise;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: OfficerPalette.line)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            flex: _flex[0],
            child: Row(
              children: <Widget>[
                StatusDot(tone: enterprise.riskLevel.tone),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        enterprise.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          color: OfficerPalette.ink,
                        ),
                      ),
                      Text(
                        enterprise.contact.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 11,
                          color: OfficerPalette.muted,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: _flex[1],
            child: Text(
              enterprise.village,
              style: const TextStyle(fontSize: 12.5),
            ),
          ),
          Expanded(
            flex: _flex[2],
            child: Text(
              enterprise.typeSectorLabel,
              style: const TextStyle(fontSize: 12.5),
            ),
          ),
          Expanded(
            flex: _flex[3],
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  '${enterprise.healthScore}',
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: 2),
                Icon(
                  enterprise.scoreRising
                      ? Icons.arrow_drop_up
                      : Icons.arrow_drop_down,
                  size: 16,
                  color: enterprise.scoreRising
                      ? OfficerPalette.statusGreen
                      : OfficerPalette.statusRed,
                ),
              ],
            ),
          ),
          Expanded(
            flex: _flex[4],
            child: Text(
              enterprise.lastSyncHoursAgo == null
                  ? 'stale'
                  : '₹${_money(enterprise.financials.cashOnHandInr)}',
              style: const TextStyle(fontSize: 12.5),
            ),
          ),
          Expanded(
            flex: _flex[5],
            child: Text(
              enterprise.flagSummary ?? '—',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12, color: OfficerPalette.body),
            ),
          ),
          Expanded(
            flex: _flex[6],
            child: Text(
              enterprise.lastSyncHoursAgo == null
                  ? '${enterprise.staleDays}d ⚠'
                  : '${enterprise.lastSyncHoursAgo}h ✓',
              style: TextStyle(
                fontSize: 12,
                fontWeight: enterprise.lastSyncHoursAgo == null
                    ? FontWeight.w700
                    : FontWeight.w400,
                color: enterprise.lastSyncHoursAgo == null
                    ? OfficerPalette.statusRed
                    : OfficerPalette.muted,
              ),
            ),
          ),
        ],
      ),
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

class _StackedRow extends StatelessWidget {
  const _StackedRow({required this.enterprise});

  final Enterprise enterprise;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: OfficerPalette.soft,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: <Widget>[
          StatusDot(tone: enterprise.riskLevel.tone),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  enterprise.name,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: OfficerPalette.ink,
                  ),
                ),
                Text(
                  '${enterprise.village} · ${enterprise.typeSectorLabel}',
                  style: const TextStyle(
                    fontSize: 11,
                    color: OfficerPalette.muted,
                  ),
                ),
                if (enterprise.flagSummary != null)
                  Text(
                    enterprise.flagSummary!,
                    style: const TextStyle(
                      fontSize: 11,
                      color: OfficerPalette.body,
                    ),
                  ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Text(
                '${enterprise.healthScore}',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
              StatusChip(
                label: enterprise.riskLevel.label,
                tone: enterprise.riskLevel.tone,
                dense: true,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
