/// The top-4 flagged enterprises card (Officer Portal 5a).
library;

import 'package:flutter/material.dart';

import '../../../domain/enterprise.dart';
import '../../theme/officer_palette.dart';
import '../../widgets/officer_buttons.dart';
import '../../widgets/officer_card.dart';
import '../../widgets/status_chip.dart';

/// Highest-severity flags first, with a "view all" hand-off.
class RiskQueueCard extends StatelessWidget {
  /// Creates the risk queue card.
  const RiskQueueCard({
    super.key,
    required this.enterprises,
    required this.totalFlagged,
    required this.onEnterpriseSelected,
    required this.onViewAll,
  });

  /// Up to four highest-severity enterprises to show.
  final List<Enterprise> enterprises;

  /// Total flagged count, for the "View all N flags" button.
  final int totalFlagged;

  /// Called when a row is tapped.
  final ValueChanged<Enterprise> onEnterpriseSelected;

  /// Called when "View all" is tapped.
  final VoidCallback onViewAll;

  @override
  Widget build(BuildContext context) {
    return OfficerCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Row(
            children: <Widget>[
              Icon(
                Icons.warning_amber_rounded,
                size: 17,
                color: OfficerPalette.statusRed,
              ),
              SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Risk queue',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: OfficerPalette.ink,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          const Text(
            'Highest-severity flags first',
            style: TextStyle(fontSize: 11, color: OfficerPalette.muted),
          ),
          const SizedBox(height: 12),
          for (final Enterprise enterprise in enterprises.take(4)) ...<Widget>[
            InkWell(
              onTap: () => onEnterpriseSelected(enterprise),
              borderRadius: BorderRadius.circular(10),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 4,
                      height: 34,
                      decoration: BoxDecoration(
                        color: enterprise.riskLevel.tone == OfficerTone.red
                            ? OfficerPalette.statusRed
                            : OfficerPalette.statusAmber,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            enterprise.name,
                            style: const TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w700,
                              color: OfficerPalette.ink,
                            ),
                          ),
                          Text(
                            '${enterprise.flagSummary ?? '—'} · ${enterprise.village}',
                            style: const TextStyle(
                              fontSize: 11,
                              color: OfficerPalette.muted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    StatusChip(
                      label: enterprise.riskLevel.label,
                      tone: enterprise.riskLevel.tone,
                    ),
                  ],
                ),
              ),
            ),
          ],
          const SizedBox(height: 4),
          OfficerPrimaryButton(
            label: 'View all $totalFlagged flags →',
            onPressed: onViewAll,
          ),
        ],
      ),
    );
  }
}
