/// Log-out confirmation, then the signed-out acknowledgement (5m).
library;

import 'package:flutter/material.dart';

import '../theme/officer_palette.dart';
import '../widgets/officer_buttons.dart';
import '../widgets/officer_card.dart';

/// Opens the log-out confirmation as a modal popup over the current screen.
///
/// Shows a confirm/cancel card first; once confirmed, shows a brief
/// signed-out acknowledgement before handing back to [onSignedOut], which
/// resets the session and returns to login.
Future<void> showLogoutDialog({
  required BuildContext context,
  required VoidCallback onSignedOut,
}) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) => LogoutScreen(onSignedOut: onSignedOut),
  );
}

/// The log-out confirmation popup's content.
class LogoutScreen extends StatefulWidget {
  /// Creates the logout dialog content.
  const LogoutScreen({super.key, required this.onSignedOut});

  /// Called once the officer taps "Sign in again" after confirming logout.
  final VoidCallback onSignedOut;

  @override
  State<LogoutScreen> createState() => _LogoutScreenState();
}

class _LogoutScreenState extends State<LogoutScreen> {
  bool _confirmed = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 360),
        child: _confirmed
            ? _SignedOutCard(onSignedOut: widget.onSignedOut)
            : _buildConfirmCard(),
      ),
    );
  }

  Widget _buildConfirmCard() {
    return OfficerCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'Log out of KHUSH-HAL?',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: OfficerPalette.ink,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Unsaved visit notes are already synced ✓. '
            "You'll need your email and password to sign back in.",
            style: TextStyle(
              fontSize: 12.5,
              height: 1.5,
              color: OfficerPalette.body,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: <Widget>[
              Expanded(
                child: OfficerSecondaryButton(
                  label: 'Cancel',
                  expand: true,
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OfficerPrimaryButton(
                  label: 'Log out ▸',
                  destructive: true,
                  onPressed: () => setState(() => _confirmed = true),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SignedOutCard extends StatelessWidget {
  const _SignedOutCard({required this.onSignedOut});

  final VoidCallback onSignedOut;

  @override
  Widget build(BuildContext context) {
    return OfficerCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Text('👋', style: TextStyle(fontSize: 26)),
          const SizedBox(height: 8),
          const Text(
            "You're signed out",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: OfficerPalette.ink,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Session ended',
            style: TextStyle(fontSize: 12, color: OfficerPalette.muted),
          ),
          const SizedBox(height: 10),
          OfficerSecondaryButton(
            label: 'Sign in again →',
            expand: true,
            onPressed: () {
              Navigator.of(context).pop();
              onSignedOut();
            },
          ),
        ],
      ),
    );
  }
}
