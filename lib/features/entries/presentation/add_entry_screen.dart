/// Add entry — three taps (design 1p).
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/labels.dart';
import '../../../app/model/ledger.dart';
import '../../../app/session.dart';
import '../../../core/formatting.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/back_header.dart';
import '../../../core/widgets/choice_pill.dart';
import '../../../core/widgets/gradient_cta_button.dart';
import '../../../core/widgets/khushhal_card.dart';
import '../../../core/widgets/page_backdrop.dart';
import '../../../l10n/app_localizations.dart';
import '../data/ledger_repository.dart';

/// The IN/OUT, amount and category entry form.
///
/// Three taps on the native number pad and out: direction, amount, category.
/// Saving never fails — offline entries queue and sync later, which the chip
/// in the corner promises up front.
class AddEntryScreen extends StatefulWidget {
  /// Creates the screen.
  const AddEntryScreen({super.key});

  @override
  State<AddEntryScreen> createState() => _AddEntryScreenState();
}

class _AddEntryScreenState extends State<AddEntryScreen> {
  final TextEditingController _amount = TextEditingController();

  EntryKind _kind = EntryKind.moneyIn;
  EntryCategory _category = EntryCategory.milkSale;

  @override
  void dispose() {
    _amount.dispose();
    super.dispose();
  }

  int get _amountValue => int.tryParse(_amount.text.trim()) ?? 0;

  void _save() {
    if (_amountValue <= 0) {
      return;
    }

    // Real wall clock — every entry must carry the actual date/time so the
    // backend can group ledger rows by month and so /entries/sync doesn't
    // deduplicate today's writes against demo dates from months ago.
    final DateTime now = DateTime.now();
    final LedgerEntry entry = LedgerEntry(
      kind: _kind,
      amountInr: _amountValue,
      category: _category,
      recordedAt: now,
    );

    final session = SessionScope.of(context);
    session.addEntry(entry);

    // Fire-and-forget backend submit via outbox — safe offline, idempotent
    // via client_entry_id. Nothing blocks the pop() below.
    final businessId = session.activeBackendBusinessId;
    if (businessId != null) {
      try {
        final repo = context.read<LedgerRepository>();
        // ignore: discarded_futures
        repo.submit(businessId: businessId, entry: entry);
      } catch (_) {
        // No repository provided (e.g. demo mode) — session addEntry is enough.
      }
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final AppSession session = SessionScope.of(context);

    return Scaffold(
      body: PageBackdrop(
        child: Column(
          children: <Widget>[
            BackHeader(
              title: l10n.addEntryTitle,
              trailing: _SavesOfflineChip(label: l10n.addEntrySavesOffline),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(height: 14),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: _KindButton(
                            label: l10n.entryIn,
                            icon: Icons.south_west_rounded,
                            selected: _kind == EntryKind.moneyIn,
                            onTap: () =>
                                setState(() => _kind = EntryKind.moneyIn),
                          ),
                        ),
                        const SizedBox(width: 9),
                        Expanded(
                          child: _KindButton(
                            label: l10n.entryOut,
                            icon: Icons.north_east_rounded,
                            selected: _kind == EntryKind.moneyOut,
                            onTap: () =>
                                setState(() => _kind = EntryKind.moneyOut),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    KhushhalCard(
                      radius: 18,
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: <Widget>[
                          Text(
                            l10n.addEntryAmount,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppPalette.hint,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              const Text(
                                '₹ ',
                                style: TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.w700,
                                  color: AppPalette.ink,
                                ),
                              ),
                              IntrinsicWidth(
                                child: TextField(
                                  controller: _amount,
                                  autofocus: true,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  onChanged: (String _) => setState(() {}),
                                  style: const TextStyle(
                                    fontSize: 36,
                                    fontWeight: FontWeight.w700,
                                    color: AppPalette.ink,
                                  ),
                                  decoration: const InputDecoration(
                                    isCollapsed: true,
                                    filled: false,
                                    border: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    // Room for the cursor before any digits.
                                    constraints: BoxConstraints(minWidth: 24),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      l10n.addEntryWhatFor,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppPalette.muted,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 7,
                      runSpacing: 7,
                      children: <Widget>[
                        for (final EntryCategory category
                            in EntryCategory.values)
                          ChoicePill(
                            label: category.label(l10n),
                            selected: _category == category,
                            dashed: category == EntryCategory.other,
                            onTap: () => setState(() => _category = category),
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: Text(
                        l10n.addEntryMonthNote(
                          monthName(context, DateTime.now()),
                          session.health != null
                              ? dayMonth(context, session.health!.nextUpdate)
                              : '—',
                        ),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 11.5,
                          color: AppPalette.faint,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            GradientCtaButton(
              label: l10n.saveCta,
              icon: Icons.check_rounded,
              onPressed: _save,
            ),
          ],
        ),
      ),
    );
  }
}

/// One half of the IN/OUT toggle.
class _KindButton extends StatelessWidget {
  const _KindButton({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color foreground = selected ? AppPalette.onPrimary : AppPalette.body;

    return Material(
      color: Colors.transparent,
      child: Ink(
        decoration: BoxDecoration(
          gradient: selected
              ? const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[AppPalette.forest, AppPalette.leaf],
                )
              : null,
          color: selected ? null : AppPalette.onPrimary,
          border: selected
              ? null
              : Border.all(color: AppPalette.line, width: 1.5),
          borderRadius: BorderRadius.circular(16),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(icon, size: 19, color: foreground),
                const SizedBox(width: 7),
                Flexible(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                      color: foreground,
                      height: 1.2,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// The "saves offline" reassurance chip in the header.
class _SavesOfflineChip extends StatelessWidget {
  const _SavesOfflineChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    // Chips stay chip-sized at accessibility text scales — the header has a
    // title to fit beside this.
    return MediaQuery.withClampedTextScaling(
      maxScaleFactor: 1.0,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: const BoxDecoration(
          color: AppPalette.mintChip,
          borderRadius: BorderRadius.all(Radius.circular(99)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(Icons.check, size: 13, color: AppPalette.leaf),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppPalette.leaf,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
