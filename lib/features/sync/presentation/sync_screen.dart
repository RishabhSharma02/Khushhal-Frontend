/// Sync status and queue (design 1w).
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../app/session.dart';
import '../../../core/db/app_database.dart';
import '../../../core/formatting.dart';
import '../../../core/sync/outbox_dao.dart';
import '../../../core/sync/sync_engine.dart';
import '../../../core/sync/sync_op.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/back_header.dart';
import '../../../core/widgets/info_note.dart';
import '../../../core/widgets/khushhal_card.dart';
import '../../../core/widgets/page_backdrop.dart';
import '../../../core/widgets/secondary_cta_button.dart';
import '../../../core/widgets/section_label.dart';
import '../../../core/widgets/sync_chip.dart';
import '../../../l10n/app_localizations.dart';

/// The reassurance screen: nothing is lost, sync is automatic, and anything
/// that failed is named rather than hidden behind a count.
///
/// Every number on this screen now comes from the `sync_ops` table and
/// `sync_meta`, so it reflects what will actually be sent — the previous
/// version animated a fake progress bar and printed a hardcoded last-sync
/// time, which meant the one screen whose entire job is trust was the one
/// screen making things up.
class SyncScreen extends StatefulWidget {
  /// Creates the screen.
  const SyncScreen({super.key});

  @override
  State<SyncScreen> createState() => _SyncScreenState();
}

class _SyncScreenState extends State<SyncScreen> {
  bool _syncing = false;

  OutboxDao? get _outbox {
    try {
      return context.read<OutboxDao>();
    } catch (_) {
      return null;
    }
  }

  SyncEngine? get _engine {
    try {
      return context.read<SyncEngine>();
    } catch (_) {
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    // Opening this screen is itself a request to sync; the user came here
    // because they want to know their data is safe.
    WidgetsBinding.instance.addPostFrameCallback((_) => _syncNow());
  }

  Future<void> _syncNow() async {
    final SyncEngine? engine = _engine;
    if (engine == null || _syncing) return;

    setState(() => _syncing = true);
    final SyncCycleResult result = await engine.syncNow();
    if (!mounted) return;
    setState(() => _syncing = false);

    if (result.skippedOffline) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Still offline — your changes are saved on this phone.'),
        ),
      );
      return;
    }
    if (result.isClean) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Everything is synced.')));
    }
  }

  Future<void> _retryFailed() async {
    final SyncEngine? engine = _engine;
    if (engine == null) return;
    setState(() => _syncing = true);
    await engine.retryFailed();
    if (mounted) setState(() => _syncing = false);
  }

  Future<void> _discard(int opId) async {
    await _outbox?.discard(opId);
  }

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
    final OutboxDao? outbox = _outbox;

    return Scaffold(
      body: PageBackdrop(
        child: Column(
          children: <Widget>[
            BackHeader(
              title: l10n.syncTitle,
              trailing: MediaQuery.withClampedTextScaling(
                maxScaleFactor: 1.3,
                child: SyncChip(
                  status: session.connectivity,
                  pendingCount: session.pendingSyncCount,
                ),
              ),
            ),
            Expanded(
              child: outbox == null
                  ? _EmptyQueue(message: l10n.syncAutoNote)
                  : StreamBuilder<List<SyncOpRow>>(
                      stream: outbox.watchAll(),
                      builder: (context, snapshot) {
                        final List<SyncOpRow> ops =
                            snapshot.data ?? const <SyncOpRow>[];
                        return _QueueBody(
                          ops: ops,
                          syncing: _syncing,
                          onRetry: _retryFailed,
                          onDiscard: _discard,
                          weekday: _weekday,
                        );
                      },
                    ),
            ),
            const SizedBox(height: 12),
            SecondaryCtaButton(
              label: _syncing ? 'Syncing…' : l10n.syncNowCta,
              icon: Icons.sync_rounded,
              onPressed: _syncNow,
            ),
          ],
        ),
      ),
    );
  }
}

/// The scrollable body: pending ops, failed ops, and the last-sync line.
class _QueueBody extends StatelessWidget {
  const _QueueBody({
    required this.ops,
    required this.syncing,
    required this.onRetry,
    required this.onDiscard,
    required this.weekday,
  });

  final List<SyncOpRow> ops;
  final bool syncing;
  final Future<void> Function() onRetry;
  final Future<void> Function(int opId) onDiscard;
  final String Function(BuildContext, DateTime) weekday;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final List<SyncOpRow> pending = ops
        .where((o) => !o.deadLettered)
        .toList(growable: false);
    final List<SyncOpRow> failed = ops
        .where((o) => o.deadLettered)
        .toList(growable: false);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
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
                  if (syncing) ...<Widget>[
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(99),
                      child: const LinearProgressIndicator(minHeight: 8),
                    ),
                  ],
                ],
              ),
            ),
          ],

          if (pending.isEmpty && failed.isEmpty) ...<Widget>[
            const SizedBox(height: 24),
            _EmptyQueue(message: l10n.syncAutoNote),
          ],

          if (pending.isNotEmpty) ...<Widget>[
            const SizedBox(height: 14),
            SectionLabel(l10n.syncWaitingHeader),
            const SizedBox(height: 7),
            for (final SyncOpRow op in pending)
              Padding(
                padding: const EdgeInsets.only(bottom: 7),
                child: _QueueRow(
                  label: _describe(context, op, weekday),
                  status: op.attempts > 0
                      ? _QueueStatus.retrying
                      : _QueueStatus.waiting,
                ),
              ),
          ],

          if (failed.isNotEmpty) ...<Widget>[
            const SizedBox(height: 18),
            const SectionLabel('Could not be saved online'),
            const SizedBox(height: 7),
            for (final SyncOpRow op in failed)
              Padding(
                padding: const EdgeInsets.only(bottom: 7),
                child: _FailedRow(
                  label: _describe(context, op, weekday),
                  error: op.lastError ?? 'Rejected by the server',
                  onDiscard: () => onDiscard(op.id),
                ),
              ),
            const SizedBox(height: 6),
            SecondaryCtaButton(
              label: 'Try these again',
              icon: Icons.refresh_rounded,
              onPressed: onRetry,
            ),
          ],

          const SizedBox(height: 10),
          const _LastFullSyncCard(),
          const SizedBox(height: 12),
          InfoNote(text: l10n.syncAutoNote),
        ],
      ),
    );
  }

  /// A one-line description of what an op will send.
  ///
  /// Reads from the payload rather than joining back to the source table so a
  /// row that has since been deleted still renders something meaningful.
  static String _describe(
    BuildContext context,
    SyncOpRow op,
    String Function(BuildContext, DateTime) weekday,
  ) {
    final Map<String, dynamic> payload = decodeSyncPayload(op.payload);
    final String noun = op.entity.label;

    final Object? amount = payload['amount_inr'];
    if (amount is int) {
      final Object? raw = payload['recorded_at'];
      final DateTime? at = raw is String ? DateTime.tryParse(raw) : null;
      final String when = at == null ? '' : ' · ${weekday(context, at)}';
      return '$noun ${rupees(context, amount)}$when';
    }

    final Object? name = payload['name'];
    if (name is String && name.isNotEmpty) return '$noun · $name';

    return noun;
  }
}

/// The "nothing waiting" state.
class _EmptyQueue extends StatelessWidget {
  const _EmptyQueue({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const SizedBox(height: 24),
        const Icon(
          Icons.cloud_done_outlined,
          size: 34,
          color: AppPalette.leaf,
        ),
        const SizedBox(height: 10),
        const Text(
          'Everything is saved online',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: AppPalette.cardInk,
          ),
        ),
        const SizedBox(height: 10),
        InfoNote(text: message),
      ],
    );
  }
}

/// Reads the real last-successful-sync timestamp out of `sync_meta`.
class _LastFullSyncCard extends StatelessWidget {
  const _LastFullSyncCard();

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;

    AppDatabase? db;
    try {
      db = context.read<AppDatabase>();
    } catch (_) {
      db = null;
    }

    return StreamBuilder<DateTime?>(
      stream: db?.watchLastFullSync(),
      builder: (context, snapshot) {
        final DateTime? at = snapshot.data;
        final String value = at == null
            ? 'Not yet'
            : '${DateFormat('EEE', Localizations.localeOf(context).languageCode == 'hi' ? 'hi' : 'en').format(at)} '
                  '${clockTime(context, at)}';

        return KhushhalCard(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
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
                  value,
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
        );
      },
    );
  }
}

/// Where a queue row is in its journey to the server.
enum _QueueStatus { retrying, waiting }

/// One entry of the outbound queue.
class _QueueRow extends StatelessWidget {
  const _QueueRow({required this.label, required this.status});

  final String label;
  final _QueueStatus status;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;

    final Widget trailing = switch (status) {
      _QueueStatus.retrying => Text(
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

/// A dead-lettered op, with the server's reason and a way to drop it.
class _FailedRow extends StatelessWidget {
  const _FailedRow({
    required this.label,
    required this.error,
    required this.onDiscard,
  });

  final String label;
  final String error;
  final VoidCallback onDiscard;

  @override
  Widget build(BuildContext context) {
    return KhushhalCard(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppPalette.cardInk,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  error,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF8A6D00),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: onDiscard,
            tooltip: 'Discard',
            icon: const Icon(
              Icons.delete_outline,
              size: 18,
              color: AppPalette.faint,
            ),
          ),
        ],
      ),
    );
  }
}
