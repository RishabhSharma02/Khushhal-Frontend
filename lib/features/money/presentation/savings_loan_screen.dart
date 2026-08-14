/// Savings and loan (design 1t).
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/session.dart';
import '../../businesses/data/business_repository.dart';
import '../../../core/formatting.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/back_header.dart';
import '../../../core/widgets/khushhal_card.dart';
import '../../../core/widgets/page_backdrop.dart';
import '../../../l10n/app_localizations.dart';

/// Two editable numbers — no schedules or history asked.
///
/// Every edit re-runs the forecast, so correcting a number is always safe
/// and always worthwhile.
class SavingsLoanScreen extends StatelessWidget {
  /// Creates the screen.
  const SavingsLoanScreen({super.key});

  /// Writes both numbers to SQLite against the active business and queues the
  /// PATCH.
  ///
  /// Savings and loan belong to a business, not the household, so this rides
  /// the business update op — which means it works offline like every other
  /// business edit. Both numbers go out together even when one changed, since
  /// they are read back as a pair.
  Future<void> _persist(BuildContext context, AppSession session) async {
    final int? businessId = session.activeBackendBusinessId;
    if (businessId == null) return;

    final BusinessRepository repo;
    try {
      repo = context.read<BusinessRepository>();
    } catch (_) {
      // No repository (demo mode) — the session value is all there is.
      return;
    }

    final String? clientId = await repo.clientIdFor(businessId);
    if (clientId == null) return;

    await repo.update(
      clientId,
      savingsInr: session.savingsInr,
      loanInr: session.loanInr,
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final AppSession session = SessionScope.of(context);

    return Scaffold(
      body: PageBackdrop(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            BackHeader(title: l10n.savingsLoanTitle),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(height: 16),
                    _AmountCard(
                      label: l10n.tileSavings,
                      amount: session.savingsInr,
                      hint: l10n.savingsHint,
                      onChanged: (int value) {
                        session.savingsInr = value;
                        // ignore: discarded_futures
                        _persist(context, session);
                      },
                    ),
                    const SizedBox(height: 10),
                    _AmountCard(
                      label: l10n.tileLoan,
                      amount: session.loanInr,
                      hint: l10n.loanHint,
                      onChanged: (int value) {
                        session.loanInr = value;
                        // ignore: discarded_futures
                        _persist(context, session);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// One of the two big editable numbers.
class _AmountCard extends StatelessWidget {
  const _AmountCard({
    required this.label,
    required this.amount,
    required this.hint,
    required this.onChanged,
  });

  final String label;
  final int amount;
  final String hint;
  final ValueChanged<int> onChanged;

  Future<void> _edit(BuildContext context) async {
    final int? updated = await showDialog<int>(
      context: context,
      builder: (BuildContext _) => _AmountDialog(label: label, initial: amount),
    );

    if (updated != null) {
      onChanged(updated);
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;

    return KhushhalCard(
      radius: 20,
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppPalette.cardInk,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Material(
                color: AppPalette.onPrimary,
                shape: const StadiumBorder(
                  side: BorderSide(color: AppPalette.outline, width: 1.5),
                ),
                child: InkWell(
                  onTap: () => _edit(context),
                  customBorder: const StadiumBorder(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        const Icon(
                          Icons.edit_outlined,
                          size: 14,
                          color: AppPalette.forest,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          l10n.changeCta,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppPalette.forest,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Scales down rather than clips at accessibility text sizes.
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              rupees(context, amount),
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w700,
                color: AppPalette.ink,
                height: 1.1,
              ),
            ),
          ),
          const SizedBox(height: 3),
          Text(
            hint,
            style: const TextStyle(fontSize: 12, color: AppPalette.hint),
          ),
        ],
      ),
    );
  }
}

/// The edit dialog; owns its controller so it outlives the exit animation.
class _AmountDialog extends StatefulWidget {
  const _AmountDialog({required this.label, required this.initial});

  final String label;
  final int initial;

  @override
  State<_AmountDialog> createState() => _AmountDialogState();
}

class _AmountDialogState extends State<_AmountDialog> {
  late final TextEditingController _controller = TextEditingController(
    text: '${widget.initial}',
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;

    return AlertDialog(
      backgroundColor: AppPalette.onPrimary,
      title: Text(
        widget.label,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppPalette.ink,
        ),
      ),
      content: TextField(
        controller: _controller,
        autofocus: true,
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly,
        ],
        decoration: const InputDecoration(prefixText: '₹ '),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancelCta),
        ),
        FilledButton(
          onPressed: () {
            Navigator.of(context).pop(int.tryParse(_controller.text.trim()));
          },
          child: Text(l10n.saveCta),
        ),
      ],
    );
  }
}
