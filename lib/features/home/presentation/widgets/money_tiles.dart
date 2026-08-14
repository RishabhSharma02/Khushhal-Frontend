/// The 2×2 number tiles under the health card (design 1o).
library;

import 'package:flutter/material.dart';

import '../../../../app/model/business.dart';
import '../../../../app/session.dart';
import '../../../../core/formatting.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/khushhal_card.dart';
import '../../../../l10n/app_localizations.dart';

/// Money IN / Money OUT and the editable Savings / Loan tiles.
///
/// [compact] drops the editable pair — the offline home (1u) shows only the
/// month's IN and OUT.
class MoneyTileGrid extends StatelessWidget {
  /// Creates the grid.
  const MoneyTileGrid({super.key, this.compact = false, this.onEditTap});

  /// True renders just the IN/OUT row (1u).
  final bool compact;

  /// Opens savings & loan (1t) from the editable tiles.
  final VoidCallback? onEditTap;

  /// The figure this tile moved on from, once live entries have taken over.
  ///
  /// The baseline is what the owner typed on the setup wizard for this
  /// business. It is not necessarily what the score was computed from — once
  /// there are entries the backend scores their monthly average instead — so
  /// the wording says where the number came from, not what it decided.
  String? _movedFrom(BuildContext context, AppLocalizations l10n, int amount) {
    final AppSession session = SessionScope.of(context);
    final MonthlyMoney? snap = session.baseline;
    if (snap == null || !session.moneyIsFromLedger) return null;
    if (snap.month == null) {
      return l10n.tileMovedFromPlain(rupees(context, amount));
    }
    return l10n.tileMovedFrom(
      rupees(context, amount),
      monthShort(context, snap.month!),
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final AppSession session = SessionScope.of(context);
    final MonthlyMoney? baseline = session.baseline;

    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: _MoneyTile(
                icon: Icons.south_west_rounded,
                label: l10n.tileMoneyIn,
                amount: rupees(context, session.monthMoneyIn),
                footer: l10n.tileThisMonth,
                subFooter: baseline == null
                    ? null
                    : _movedFrom(context, l10n, baseline.moneyIn),
                footerColor: AppPalette.idle,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _MoneyTile(
                icon: Icons.north_east_rounded,
                label: l10n.tileMoneyOut,
                amount: rupees(context, session.monthMoneyOut),
                footer: l10n.tileThisMonth,
                subFooter: baseline == null
                    ? null
                    : _movedFrom(context, l10n, baseline.moneyOut),
                footerColor: AppPalette.idle,
              ),
            ),
          ],
        ),
        if (!compact) ...<Widget>[
          const SizedBox(height: 10),
          Row(
            children: <Widget>[
              Expanded(
                child: _MoneyTile(
                  label: '${l10n.tileSavings} ✎',
                  amount: rupees(context, session.savingsInr),
                  footer: l10n.tileTapToEdit,
                  footerColor: AppPalette.leaf,
                  onTap: onEditTap,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _MoneyTile(
                  label: '${l10n.tileLoan} ✎',
                  amount: rupees(context, session.loanInr),
                  footer: l10n.tileTapToEdit,
                  footerColor: AppPalette.leaf,
                  onTap: onEditTap,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

/// One tile: label, amount, footer.
class _MoneyTile extends StatelessWidget {
  const _MoneyTile({
    this.icon,
    required this.label,
    required this.amount,
    required this.footer,
    required this.footerColor,
    this.subFooter,
    this.onTap,
  });

  final IconData? icon;
  final String label;
  final String amount;
  final String footer;

  /// Optional second footer line — the figure this tile moved on from.
  final String? subFooter;
  final Color footerColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return KhushhalCard(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              if (icon != null) ...<Widget>[
                Icon(icon, size: 13, color: AppPalette.hint),
                const SizedBox(width: 5),
              ],
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppPalette.hint,
                    height: 1.3,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 3),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              amount,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: AppPalette.cardInk,
                height: 1.3,
              ),
            ),
          ),
          Text(
            footer,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 11,
              fontWeight: footerColor == AppPalette.leaf
                  ? FontWeight.w500
                  : FontWeight.w400,
              color: footerColor,
              height: 1.3,
            ),
          ),
          if (subFooter != null)
            Text(
              subFooter!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 11,
                color: AppPalette.hint,
                height: 1.3,
              ),
            ),
        ],
      ),
    );
  }
}
