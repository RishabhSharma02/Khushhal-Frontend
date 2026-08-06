/// The "Watch" card under the tiles (design 1o).
library;

import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/khushhal_card.dart';
import '../../../../l10n/app_localizations.dart';

/// One warning with its next step, in plain words.
///
/// The card body opens the alerts list (1r); the underlined "Do this" line
/// jumps straight to the plan (1s).
class WatchCard extends StatelessWidget {
  /// Creates the card.
  const WatchCard({
    super.key,
    required this.riskMonthLabel,
    required this.fromForecast,
    this.onOpenAlerts,
    this.onOpenPlan,
  });

  /// Short label of the flagged month ("Nov").
  final String riskMonthLabel;

  /// True cites the fresh forecast (1o2) instead of the mandi feed (1o).
  final bool fromForecast;

  /// Opens the alerts list (1r).
  final VoidCallback? onOpenAlerts;

  /// Opens the plan (1s).
  final VoidCallback? onOpenPlan;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final String reason = fromForecast
        ? l10n.watchReasonForecast
        : l10n.watchReasonMandi;

    return KhushhalCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      onTap: onOpenAlerts,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text('⚠️', style: TextStyle(fontSize: 13.5, height: 1.4)),
              const SizedBox(width: 8),
              Expanded(
                child: Text.rich(
                  TextSpan(
                    children: <InlineSpan>[
                      TextSpan(
                        text: l10n.watchTitle(riskMonthLabel),
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      TextSpan(text: ' — $reason'),
                    ],
                  ),
                  style: const TextStyle(
                    fontSize: 13.5,
                    color: AppPalette.cardInk,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsetsDirectional.only(start: 26),
            child: InkWell(
              onTap: onOpenPlan,
              borderRadius: BorderRadius.circular(6),
              child: Text(
                l10n.watchAction,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppPalette.forest,
                  decoration: TextDecoration.underline,
                  height: 1.4,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
