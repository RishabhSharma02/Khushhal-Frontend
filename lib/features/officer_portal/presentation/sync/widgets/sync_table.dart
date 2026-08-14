/// The stale-device table (Officer Portal 5f).
library;

import 'package:flutter/material.dart';

import '../../../domain/sync_status.dart';
import '../../theme/officer_palette.dart';
import '../../widgets/officer_buttons.dart';
import '../../widgets/officer_card.dart';

/// Per-row remedy: call, add to route, or resend a re-login link.
class SyncTable extends StatelessWidget {
  /// Creates the sync table.
  const SyncTable({super.key, required this.rows, required this.onAction});

  /// The stale-device rows.
  final List<DeviceSyncStatus> rows;

  /// Called when a row's action button is tapped.
  final ValueChanged<DeviceSyncStatus> onAction;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool stacked = constraints.maxWidth < 700;

        return OfficerCard(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
          child: Column(
            children: <Widget>[
              for (final DeviceSyncStatus row in rows)
                stacked
                    ? _StackedRow(row: row, onAction: onAction)
                    : _WideRow(row: row, onAction: onAction),
            ],
          ),
        );
      },
    );
  }
}

class _WideRow extends StatelessWidget {
  const _WideRow({required this.row, required this.onAction});

  final DeviceSyncStatus row;
  final ValueChanged<DeviceSyncStatus> onAction;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: OfficerPalette.line)),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 18,
            child: Text.rich(
              TextSpan(
                children: <InlineSpan>[
                  TextSpan(
                    text: row.enterpriseName,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: OfficerPalette.ink,
                    ),
                  ),
                  TextSpan(text: ' · ${row.village}'),
                ],
              ),
              style: const TextStyle(fontSize: 12.5),
            ),
          ),
          Expanded(
            flex: 8,
            child: Text(
              '${row.lastSyncDays}d ⚠',
              style: const TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                color: OfficerPalette.statusRed,
              ),
            ),
          ),
          Expanded(
            flex: 8,
            child: Text(
              '${row.lastEntryDays}d',
              style: const TextStyle(fontSize: 12.5),
            ),
          ),
          Expanded(
            flex: 10,
            child: Text(
              row.pendingEstimateLabel,
              style: const TextStyle(fontSize: 12.5),
            ),
          ),
          Expanded(
            flex: 18,
            child: Text(
              row.likelyCause,
              style: const TextStyle(fontSize: 12, color: OfficerPalette.body),
            ),
          ),
          Expanded(
            flex: 11,
            child: Align(
              alignment: Alignment.centerRight,
              child: OfficerSecondaryButton(
                label: row.actionLabel,
                onPressed: () => onAction(row),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StackedRow extends StatelessWidget {
  const _StackedRow({required this.row, required this.onAction});

  final DeviceSyncStatus row;
  final ValueChanged<DeviceSyncStatus> onAction;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: OfficerPalette.soft,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  '${row.enterpriseName} · ${row.village}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    color: OfficerPalette.ink,
                  ),
                ),
              ),
              Text(
                '${row.lastSyncDays}d ⚠',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: OfficerPalette.statusRed,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            row.likelyCause,
            style: const TextStyle(fontSize: 11.5, color: OfficerPalette.body),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: OfficerSecondaryButton(
              label: row.actionLabel,
              onPressed: () => onAction(row),
            ),
          ),
        ],
      ),
    );
  }
}
