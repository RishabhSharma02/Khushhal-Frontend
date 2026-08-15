/// Small "your field officer" card, shown below the money tiles on home.
library;

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../app/model/assigned_officer.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/khushhal_card.dart';
import '../../../../l10n/app_localizations.dart';

/// Compact card showing the officer linked to the active business — name,
/// email, mobile, and a one-tap dialer.
class OfficerCard extends StatelessWidget {
  const OfficerCard({super.key, required this.officer});

  final AssignedOfficer officer;

  Future<void> _call(BuildContext context) async {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final Uri uri = Uri.parse('tel:${officer.mobile}');
    if (!await launchUrl(uri)) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.homeOfficerCallFailed(officer.mobile))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    return KhushhalCard(
      radius: 16,
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            l10n.homeOfficerCardTitle,
            style: const TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              color: AppPalette.muted,
              height: 1.3,
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: AppPalette.mintChip,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.support_agent_rounded,
                  size: 20,
                  color: AppPalette.forest,
                ),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      officer.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppPalette.cardInk,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      l10n.homeOfficerId(officer.officerId),
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppPalette.hint,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      officer.email,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 11.5,
                        color: AppPalette.body,
                        height: 1.3,
                      ),
                    ),
                    Text(
                      officer.mobile,
                      style: const TextStyle(
                        fontSize: 11.5,
                        color: AppPalette.body,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Material(
                color: AppPalette.forest,
                shape: const CircleBorder(),
                child: InkWell(
                  onTap: () => _call(context),
                  customBorder: const CircleBorder(),
                  child: Padding(
                    padding: const EdgeInsets.all(9),
                    child: Tooltip(
                      message: l10n.homeOfficerCallTooltip,
                      child: const Icon(
                        Icons.call_rounded,
                        size: 18,
                        color: AppPalette.onPrimary,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
