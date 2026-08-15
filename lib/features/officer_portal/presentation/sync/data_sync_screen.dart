/// Stale-device triage, reached from the dashboard's sync banner (5f).
library;

import 'package:flutter/material.dart';

import '../../data/sync_status_repository.dart';
import '../../domain/enterprise.dart';
import '../../domain/sync_status.dart';
import '../officer_session.dart';
import '../theme/officer_palette.dart';
import '../widgets/officer_buttons.dart';
import '../widgets/officer_card.dart';
import '../widgets/officer_nav_rail.dart';
import '../widgets/officer_shell_scaffold.dart';
import '../widgets/responsive_header.dart';
import 'widgets/sync_kpi_row.dart';
import 'widgets/sync_table.dart';

/// Not-syncing (network/phone) vs. not-entering (habit) devices, each with a
/// one-click remedy.
///
/// Has no rail icon of its own in the mocks — Dashboard stays highlighted,
/// since this screen is only ever reached from its stale-sync banner.
class DataSyncScreen extends StatefulWidget {
  /// Creates the data sync screen.
  const DataSyncScreen({super.key, required this.onSectionSelected});

  /// Called when a rail section is tapped — also pops this pushed screen.
  final ValueChanged<OfficerSection> onSectionSelected;

  @override
  State<DataSyncScreen> createState() => _DataSyncScreenState();
}

class _DataSyncScreenState extends State<DataSyncScreen> {
  Future<SyncStatusSummary>? _summaryFuture;
  bool _loaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_loaded) {
      _loaded = true;
      _summaryFuture = OfficerSessionScope.of(context).syncStatusRepository?.fetchSyncStatus();
    }
  }

  void _handleAction(BuildContext context, DeviceSyncStatus row) {
    switch (row.actionKind) {
      case SyncActionKind.call:
        final Enterprise enterprise = OfficerSessionScope.of(
          context,
        ).enterpriseById(row.enterpriseId);
        showDialog<void>(
          context: context,
          builder: (BuildContext context) => Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 340),
              child: OfficerCard(
                padding: const EdgeInsets.all(22),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      row.enterpriseName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: OfficerPalette.ink,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${enterprise.contact.name} · ${enterprise.contact.role}',
                      style: const TextStyle(
                        fontSize: 12.5,
                        color: OfficerPalette.muted,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 13,
                      ),
                      decoration: BoxDecoration(
                        color: OfficerPalette.soft,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: <Widget>[
                          const Icon(
                            Icons.call_rounded,
                            size: 18,
                            color: OfficerPalette.forest,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            enterprise.contact.phone,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: OfficerPalette.ink,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Best time to call: ${enterprise.contact.bestTime} · speaks ${enterprise.contact.language}',
                      style: const TextStyle(
                        fontSize: 11.5,
                        color: OfficerPalette.muted,
                      ),
                    ),
                    const SizedBox(height: 16),
                    OfficerPrimaryButton(
                      label: 'Close',
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      case SyncActionKind.resendLogin:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Re-login link sent to ${row.enterpriseName} (demo only).',
            ),
          ),
        );
      case SyncActionKind.addToRoute:
        widget.onSectionSelected(OfficerSection.visits);
        Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final int deviceCount = OfficerSessionScope.of(context).enterprises.length;

    return OfficerShellScaffold(
      section: OfficerSection.dashboard,
      onSectionSelected: (OfficerSection section) {
        widget.onSectionSelected(section);
        Navigator.of(context).pop();
      },
      children: <Widget>[
        GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: const Text.rich(
            TextSpan(
              children: <InlineSpan>[
                TextSpan(
                  text: 'Dashboard',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: OfficerPalette.forest,
                  ),
                ),
                TextSpan(text: ' › stale devices'),
              ],
            ),
            style: TextStyle(fontSize: 12.5, color: OfficerPalette.muted),
          ),
        ),
        ResponsiveHeader(
          title: Text(
            'Data sync — $deviceCount device${deviceCount == 1 ? '' : 's'}',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: OfficerPalette.ink,
            ),
          ),
          actions: <Widget>[
            OfficerSecondaryButton(
              label: '📩 SMS nudge to stale',
              onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('SMS nudge queued (demo only).')),
              ),
            ),
            OfficerSecondaryButton(
              label: '⬇ Gap report',
              onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Export isn’t wired up in this demo yet.'),
                ),
              ),
            ),
          ],
        ),
        FutureBuilder<SyncStatusSummary>(
          future: _summaryFuture,
          builder: (BuildContext context, AsyncSnapshot<SyncStatusSummary> snapshot) {
            final SyncStatusSummary summary =
                snapshot.data ??
                (
                  syncedUnder24h: 0,
                  synced1To7Days: 0,
                  stale7Plus: 0,
                  entryGap5Plus: 0,
                  rows: const <DeviceSyncStatus>[],
                );

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SyncKpiRow(
                  syncedUnder24h: summary.syncedUnder24h,
                  synced1To7Days: summary.synced1To7Days,
                  stale7Plus: summary.stale7Plus,
                  entryGap5Plus: summary.entryGap5Plus,
                ),
                SyncTable(
                  rows: summary.rows,
                  onAction: (DeviceSyncStatus row) => _handleAction(context, row),
                ),
              ],
            );
          },
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: OfficerPalette.soft,
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Text(
            '💡 Offline-saved entries are never lost — "stale" only means the portal '
            "can't see them yet. SMS ping asks the device to reply with its entry "
            'count over SMS (no data needed).',
            style: TextStyle(fontSize: 12, color: OfficerPalette.body),
          ),
        ),
      ],
    );
  }
}
