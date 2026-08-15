/// About Khushhal — what the app does, and how to reach a person.
library;

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/theme/theme.dart';
import '../../../core/widgets/back_header.dart';
import '../../../core/widgets/khushhal_card.dart';
import '../../../core/widgets/page_backdrop.dart';
import '../../../l10n/app_localizations.dart';

/// The support number, as it is shown on screen.
const String helplineDisplay = '+91 7987956779';

/// The same number for the dialer.
const String _helplineDial = '+917987956779';

/// Opens the phone dialer on the helpline.
///
/// Shared with the Settings "Contact us" row so both places call the same
/// number.
Future<void> dialHelpline(BuildContext context) async {
  final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
  final bool opened = await launchUrl(Uri.parse('tel:$_helplineDial'));
  if (!opened) {
    messenger.showSnackBar(
      SnackBar(content: Text('Could not open dialer for $helplineDisplay')),
    );
  }
}

/// Four short lines on what the app is for, then the helpline.
class AboutScreen extends StatelessWidget {
  /// Creates the screen.
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: PageBackdrop(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            BackHeader(title: l10n.settingsAbout),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(top: 14, bottom: 16),
                children: <Widget>[
                  KhushhalCard(
                    radius: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        for (final String line in <String>[
                          l10n.aboutIntro,
                          l10n.aboutHowItWorks,
                          l10n.aboutScore,
                          l10n.aboutOffline,
                        ]) ...<Widget>[
                          Text(
                            line,
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppPalette.cardInk,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],
                        Text(
                          l10n.settingsVersion,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppPalette.hint,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  const _HelplineCard(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The tappable helpline number.
class _HelplineCard extends StatelessWidget {
  const _HelplineCard();

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;

    return KhushhalCard(
      radius: 20,
      onTap: () => dialHelpline(context),
      child: Row(
        children: <Widget>[
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppPalette.mintChip,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.call_rounded,
              size: 19,
              color: AppPalette.forest,
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  l10n.aboutHelpTitle,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppPalette.cardInk,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  helplineDisplay,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: AppPalette.forest,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  l10n.aboutHelpBody,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppPalette.hint,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
