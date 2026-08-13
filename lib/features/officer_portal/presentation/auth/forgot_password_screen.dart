/// Password reset request (Officer Portal 5k).
library;

import 'package:flutter/material.dart';

import '../../data/officer_demo_data.dart';
import '../theme/officer_palette.dart';
import '../widgets/labeled_field.dart';
import '../widgets/officer_buttons.dart';
import 'widgets/auth_scaffold.dart';

/// Requests a reset link by email, then shows a "sent" confirmation.
class ForgotPasswordScreen extends StatefulWidget {
  /// Creates the forgot-password screen.
  const ForgotPasswordScreen({super.key, required this.onBackToSignIn});

  /// Called when "Back to sign in" is tapped.
  final VoidCallback onBackToSignIn;

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _email = TextEditingController(
    text: OfficerDemoData.officer.email,
  );
  bool _sent = false;

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      title: 'Reset your password',
      subtitle: "We'll email you a reset link",
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          LabeledField(label: 'EMAIL', controller: _email),
          const SizedBox(height: 16),
          OfficerPrimaryButton(
            label: 'Send reset link 📧',
            onPressed: () => setState(() => _sent = true),
          ),
          if (_sent) ...<Widget>[
            const SizedBox(height: 14),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: OfficerPalette.chipGreenBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                '✓ Link sent — check your inbox.\n'
                'Valid 30 min · Resend (0:52)',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  height: 1.5,
                  color: OfficerPalette.chipGreenInk,
                ),
              ),
            ),
          ],
          const SizedBox(height: 14),
          Center(
            child: GestureDetector(
              onTap: widget.onBackToSignIn,
              child: const Text(
                '← Back to sign in',
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  color: OfficerPalette.forest,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
