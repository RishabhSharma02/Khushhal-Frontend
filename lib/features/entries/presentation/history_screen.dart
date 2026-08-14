/// History — the IN/OUT ledger, grouped by day (design 1v).
library;

import 'package:flutter/material.dart';

import '../../../app/labels.dart';
import '../../../app/model/ledger.dart';
import '../../../app/session.dart';
import '../../../core/formatting.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/choice_pill.dart';
import '../../../core/widgets/khushhal_card.dart';
import '../../../core/widgets/section_label.dart';
import '../../../core/widgets/sync_chip.dart';
import '../../../l10n/app_localizations.dart';
import '../../home/presentation/widgets/business_pill.dart';
import '../../sync/presentation/sync_screen.dart';
import 'add_entry_screen.dart';

/// Which slice of the ledger is showing.
enum _HistoryFilter { all, moneyIn, moneyOut, salary, loan }

/// The history tab: month totals on top, entries grouped by day below.
///
/// Every row keeps the +/− glyph next to its colored amount so direction
/// never relies on color alone, and notes how the entry was made (voice,
/// waiting to sync). Tapping a row opens the entry form to correct it.
class HistoryScreen extends StatefulWidget {
  /// Creates the history tab.
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  _HistoryFilter _filter = _HistoryFilter.all;
  // The month whose entries are currently on screen. Defaults to today's
  // month; user can move backwards via the month pill.
  late DateTime _month = DateTime(DateTime.now().year, DateTime.now().month, 1);

  bool _matches(LedgerEntry entry) {
    return switch (_filter) {
      _HistoryFilter.all => true,
      _HistoryFilter.moneyIn => entry.kind == EntryKind.moneyIn,
      _HistoryFilter.moneyOut => entry.kind == EntryKind.moneyOut,
      // No salary category exists yet; the chip shows an empty list.
      _HistoryFilter.salary => false,
      _HistoryFilter.loan => entry.category == EntryCategory.emi,
    };
  }

  bool _inSelectedMonth(LedgerEntry e) =>
      e.recordedAt.year == _month.year && e.recordedAt.month == _month.month;

  Future<T?> _push<T>(Widget screen) {
    return Navigator.of(context).push<T>(
      MaterialPageRoute<T>(builder: (BuildContext _) => screen),
    );
  }

  Future<void> _pickMonth() async {
    // Simple month picker: bottom sheet with the last 12 months.
    final now = DateTime.now();
    final months = List.generate(
      12,
      (i) => DateTime(now.year, now.month - i, 1),
      growable: false,
    );
    final picked = await showModalBottomSheet<DateTime>(
      context: context,
      backgroundColor: AppPalette.onPrimary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (_) => SafeArea(
        child: ListView.separated(
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(vertical: 12),
          itemCount: months.length,
          separatorBuilder: (_, _) => const Divider(height: 1, color: AppPalette.line),
          itemBuilder: (_, i) {
            final m = months[i];
            final selected = m.year == _month.year && m.month == _month.month;
            return ListTile(
              title: Text(monthShort(context, m)),
              trailing: selected ? const Icon(Icons.check_rounded, color: AppPalette.forest) : null,
              onTap: () => Navigator.of(context).pop(m),
            );
          },
        ),
      ),
    );
    if (picked != null && mounted) setState(() => _month = picked);
  }

  /// Day headers relative to the actual current date.
  String _dayLabel(BuildContext context, DateTime day) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final DateTime today = DateTime.now();
    final DateTime date = DateTime(day.year, day.month, day.day);
    final int daysAgo = DateTime(
      today.year,
      today.month,
      today.day,
    ).difference(date).inDays;

    return switch (daysAgo) {
      0 => l10n.historyToday,
      1 => l10n.historyYesterday,
      _ => dayMonth(context, date),
    };
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final AppSession session = SessionScope.of(context);

    final List<LedgerEntry> entries = session.entries
        .where(_inSelectedMonth)
        .where(_matches)
        .toList(growable: false);
    int monthIn = 0, monthOut = 0, monthLoan = 0;
    for (final e in session.entries.where(_inSelectedMonth)) {
      if (e.kind == EntryKind.moneyIn) {
        monthIn += e.amountInr;
      } else {
        monthOut += e.amountInr;
      }
      if (e.category == EntryCategory.emi) monthLoan += e.amountInr;
    }

    // Group by calendar day, newest first (entries are already sorted).
    final List<(DateTime, List<LedgerEntry>)> groups =
        <(DateTime, List<LedgerEntry>)>[];
    for (final LedgerEntry entry in entries) {
      final DateTime day = DateTime(
        entry.recordedAt.year,
        entry.recordedAt.month,
        entry.recordedAt.day,
      );

      if (groups.isEmpty || groups.last.$1 != day) {
        groups.add((day, <LedgerEntry>[entry]));
      } else {
        groups.last.$2.add(entry);
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
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
              onTap: () => _push(const SyncScreen()),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Text(
                l10n.historyTitle,
                style: const TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.w600,
                  color: AppPalette.ink,
                  height: 1.25,
                ),
              ),
            ),
            const SizedBox(width: 8),
            _MonthPill(
              label: monthShort(context, _month),
              onTap: _pickMonth,
            ),
          ],
        ),
        const SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: <Widget>[
              for (final (_HistoryFilter filter, String label)
                  in <(_HistoryFilter, String)>[
                    (_HistoryFilter.all, l10n.historyFilterAll),
                    (_HistoryFilter.moneyIn, l10n.entryIn),
                    (_HistoryFilter.moneyOut, l10n.entryOut),
                    (_HistoryFilter.salary, l10n.historyFilterSalary),
                    (_HistoryFilter.loan, l10n.tileLoan),
                  ]) ...<Widget>[
                ChoicePill(
                  label: label,
                  selected: _filter == filter,
                  onTap: () => setState(() => _filter = filter),
                ),
                const SizedBox(width: 6),
              ],
            ],
          ),
        ),
        const SizedBox(height: 10),
        _TotalsCard(
          monthLabel: monthShort(context, _month),
          moneyIn: monthIn,
          moneyOut: monthOut,
          loanPaid: monthLoan,
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.only(bottom: 8),
            children: <Widget>[
              for (final (DateTime day, List<LedgerEntry> dayEntries)
                  in groups) ...<Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 12, bottom: 7),
                  child: SectionLabel(_dayLabel(context, day)),
                ),
                for (final LedgerEntry entry in dayEntries)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 7),
                    child: _EntryRow(
                      entry: entry,
                      onTap: () async {
                        final saved = await _push<bool>(
                          AddEntryScreen(editing: entry),
                        );
                        if (saved == true && mounted) setState(() {});
                      },
                    ),
                  ),
              ],
              const SizedBox(height: 3),
              Center(
                child: Text(
                  '${l10n.historyTapToCorrect} ✎',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppPalette.hint,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// The outlined month selector pill — opens a picker on tap.
class _MonthPill extends StatelessWidget {
  const _MonthPill({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(99),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: AppPalette.onPrimary,
          border: Border.all(color: AppPalette.forest, width: 1.5),
          borderRadius: BorderRadius.circular(99),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              label,
              style: const TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: AppPalette.forest,
                height: 1.2,
              ),
            ),
            const SizedBox(width: 3),
            const Icon(
              Icons.expand_more_rounded,
              size: 14,
              color: AppPalette.forest,
            ),
          ],
        ),
      ),
    );
  }
}

/// The three month totals over the list.
class _TotalsCard extends StatelessWidget {
  const _TotalsCard({
    required this.monthLabel,
    required this.moneyIn,
    required this.moneyOut,
    required this.loanPaid,
  });

  final String monthLabel;
  final int moneyIn;
  final int moneyOut;
  final int loanPaid;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;

    Widget column(String label, int amount, Color color) {
      return Expanded(
        child: Column(
          children: <Widget>[
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 11,
                color: AppPalette.hint,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 2),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                rupees(context, amount),
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: color,
                  height: 1.3,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return KhushhalCard(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      child: Row(
        children: <Widget>[
          column(l10n.historyInMonth(monthLabel), moneyIn, AppPalette.leaf),
          Container(width: 1, height: 34, color: AppPalette.line),
          column(
            l10n.historyOutMonth(monthLabel),
            moneyOut,
            AppPalette.expense,
          ),
          Container(width: 1, height: 34, color: AppPalette.line),
          column(l10n.historyLoanPaid, loanPaid, AppPalette.cardInk),
        ],
      ),
    );
  }
}

/// One ledger row.
class _EntryRow extends StatelessWidget {
  const _EntryRow({required this.entry, this.onTap});

  final LedgerEntry entry;
  final VoidCallback? onTap;

  static const Map<EntryCategory, IconData> _icons = <EntryCategory, IconData>{
    EntryCategory.milkSale: Icons.water_drop_rounded,
    EntryCategory.fodder: Icons.grass_rounded,
    EntryCategory.vet: Icons.medical_services_rounded,
    EntryCategory.emi: Icons.account_balance_rounded,
    EntryCategory.other: Icons.category_rounded,
  };

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final bool incoming = entry.kind == EntryKind.moneyIn;

    // Waiting-to-sync wins over the voice note: it is the one the owner may
    // act on (find network), and the row has space for a single note.
    final String? note = entry.syncState == EntrySyncState.pending
        ? l10n.historyWillSync
        : entry.source == EntrySource.voice
        ? l10n.historyByVoice
        : null;

    final String time = clockTime(context, entry.recordedAt);

    return KhushhalCard(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      onTap: onTap,
      child: Row(
        children: <Widget>[
          Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              color: AppPalette.mintChip,
              shape: BoxShape.circle,
            ),
            child: Icon(
              _icons[entry.category],
              size: 16,
              color: AppPalette.leaf,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  entry.category.label(l10n),
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    color: AppPalette.cardInk,
                    height: 1.3,
                  ),
                ),
                Text(
                  note == null ? time : '$time · $note',
                  style: const TextStyle(
                    fontSize: 11.5,
                    color: AppPalette.hint,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Scales down before it would clip: the amount is the row's point,
          // so at giant text sizes it shrinks a little rather than truncate.
          Flexible(
            child: Align(
              alignment: AlignmentDirectional.centerEnd,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  '${incoming ? '+' : '−'}${rupees(context, entry.amountInr)}',
                  style: TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                    color: incoming ? AppPalette.leaf : AppPalette.expense,
                    height: 1.3,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
