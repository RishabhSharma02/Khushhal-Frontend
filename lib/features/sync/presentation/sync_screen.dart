/// Sync status and queue (design 1w).
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../entries/data/ledger_repository.dart';

import '../../../app/demo_data.dart';
import '../../../app/labels.dart';
import '../../../app/model/ledger.dart';
import '../../../app/session.dart';
import '../../../core/formatting.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/back_header.dart';
import '../../../core/widgets/info_note.dart';
import '../../../core/widgets/khushhal_card.dart';
import '../../../core/widgets/page_backdrop.dart';
import '../../../core/widgets/secondary_cta_button.dart';
import '../../../core/widgets/section_label.dart';
import '../../../core/widgets/sync_chip.dart';
import '../../../l10n/app_localizations.dart';

/// The reassurance screen: nothing is lost, sync is automatic, and the data
/// cost is stated. Reached from the sync chip on any screen.
class SyncScreen extends StatefulWidget {
  /// Creates the screen.
  const SyncScreen({super.key});

  @override
  State<SyncScreen> createState() => _SyncScreenState();
}

class _SyncScreenState extends State<SyncScreen> {
  int? _outboxCount;

  @override
  void initState() {
    super.initState();
    _refreshOutbox();
  }

  void _refreshOutbox() {
    try {
      final repo = context.read<LedgerRepository>();
      final n = repo.pendingCount;
      if (mounted) setState(() => _outboxCount = n);
    } catch (_) {
      _outboxCount = null;
    }
  }

  Future<void> _syncNow(BuildContext context, AppSession session) async {
    // Local demo-state sync (keeps the existing chip animation happy).
    session.syncNow();

    // Real outbox drain — no-op if no repository was provided.
    LedgerRepository? repo;
    try {
      repo = context.read<LedgerRepository>();
    } catch (_) {
      return;
    }
    try {
      final outcome = await repo.syncAll();
      if (!context.mounted) return;
      final msg = outcome.isClean
          ? 'Synced ${outcome.accepted} (${outcome.duplicates} dupes).'
          : 'Synced ${outcome.accepted}. Still pending: ${outcome.stillPending}.';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
      _refreshOutbox();
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sync failed: $e')),
      );
    }
  }

  /// Weekday abbreviation for a queue row ("Tue" / "मंगल").
  String _weekday(BuildContext context, DateTime date) {
    return DateFormat(
      'EEE',
      Localizations.localeOf(context).languageCode == 'hi' ? 'hi' : 'en',
    ).format(date);
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final AppSession session = SessionScope.of(context);
    final List<LedgerEntry> pending = session.entries
        .where((LedgerEntry e) => e.syncState != EntrySyncState.synced)
        .toList();
    final Iterable<LedgerEntry> sent = session.entries
        .where((LedgerEntry e) => e.syncState == EntrySyncState.synced)
        .take(1);

    return Scaffold(
      body: PageBackdrop(
        child: Column(
          children: <Widget>[
            BackHeader(
              title: l10n.syncTitle,
              // Clamped so the chip cannot squeeze the title out at
              // accessibility text scales.
              trailing: MediaQuery.withClampedTextScaling(
                maxScaleFactor: 1.3,
                child: SyncChip(
                  status: pending.isEmpty
                      ? ConnectivityStatus.synced
                      : ConnectivityStatus.syncing,
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    if (_outboxCount != null && _outboxCount! > 0) ...<Widget>[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppPalette.mintWash,
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(color: AppPalette.line),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            const Icon(Icons.inbox_outlined, size: 16, color: AppPalette.forest),
                            const SizedBox(width: 6),
                            Text(
                              '$_outboxCount pending in outbox',
                              style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: AppPalette.forest),
                            ),
                          ],
                        ),
                      ),
                    ],
                    if (pending.isNotEmpty) ...<Widget>[
                      const SizedBox(height: 16),
                      KhushhalCard(
                        radius: 20,
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: <Widget>[
                            const Icon(
                              Icons.cloud_upload_outlined,
                              size: 30,
                              color: AppPalette.leaf,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              l10n.syncSending(pending.length),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppPalette.cardInk,
                              ),
                            ),
                            const SizedBox(height: 12),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(99),
                              child: SizedBox(
                                height: 8,
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      flex: 2,
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: <Color>[
                                              AppPalette.leaf,
                                              AppPalette.sprout,
                                            ],
                                          ),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(99),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        color: AppPalette.mintWash,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 14),
                    SectionLabel(l10n.syncWaitingHeader),
                    const SizedBox(height: 7),
                    for (final (int i, LedgerEntry entry)
                        in sent.followedBy(pending).indexed)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 7),
                        child: _QueueRow(
                          label:
                              '${entry.category.label(l10n)} '
                              '${rupees(context, entry.amountInr)} · '
                              '${_weekday(context, entry.recordedAt)}',
                          status: entry.syncState == EntrySyncState.synced
                              ? _QueueStatus.sent
                              : i == (sent.isEmpty ? 0 : 1)
                              ? _QueueStatus.sending
                              : _QueueStatus.waiting,
                        ),
                      ),
                    const SizedBox(height: 5),
                    InfoNote(text: l10n.syncAutoNote),
                    const SizedBox(height: 10),
                    KhushhalCard(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 12,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              l10n.syncLastFull,
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppPalette.body,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Flexible(
                            child: Text(
                              '${_weekday(context, DemoData.lastFullSync)} '
                              '${clockTime(context, DemoData.lastFullSync)}',
                              textAlign: TextAlign.end,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: AppPalette.cardInk,
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
              label: l10n.syncNowCta,
              icon: Icons.sync_rounded,
              onPressed: () => _syncNow(context, session),
            ),
          ],
        ),
      ),
    );
  }
}

/// Where a queue row is in its journey to the server.
enum _QueueStatus { sent, sending, waiting }

/// One entry of the outbound queue.
class _QueueRow extends StatelessWidget {
  const _QueueRow({required this.label, required this.status});

  final String label;
  final _QueueStatus status;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;

    final Widget trailing = switch (status) {
      _QueueStatus.sent => Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            l10n.syncStatusSent,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppPalette.leaf,
            ),
          ),
          const SizedBox(width: 3),
          const Icon(Icons.check, size: 14, color: AppPalette.leaf),
        ],
      ),
      _QueueStatus.sending => Text(
        l10n.syncStatusSending,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: AppPalette.forest,
        ),
      ),
      _QueueStatus.waiting => Text(
        l10n.syncStatusWaiting,
        style: const TextStyle(fontSize: 13, color: AppPalette.faint),
      ),
    };

    return KhushhalCard(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 13, color: AppPalette.body),
            ),
          ),
          trailing,
        ],
      ),
    );
  }
}
