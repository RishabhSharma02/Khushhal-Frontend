/// The "Forgot password" modal, opened from the sign-in screen. Sends a
/// Firebase password-reset email — no backend call, Firebase owns the
/// officer's password entirely.
library;

import 'package:flutter/material.dart';

import '../../data/officer_api_client.dart';
import '../../data/officer_auth_repository.dart';
import '../theme/officer_palette.dart';
import '../widgets/labeled_field.dart';
import '../widgets/officer_buttons.dart';
import '../widgets/officer_card.dart';

/// Opens the Forgot-password dialog.
Future<void> showForgotPasswordDialog({
  required BuildContext context,
  required OfficerAuthRepository authRepository,
}) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) => _ForgotPasswordDialog(authRepository: authRepository),
  );
}

class _ForgotPasswordDialog extends StatefulWidget {
  const _ForgotPasswordDialog({required this.authRepository});

  final OfficerAuthRepository authRepository;

  @override
  State<_ForgotPasswordDialog> createState() => _ForgotPasswordDialogState();
}

class _ForgotPasswordDialogState extends State<_ForgotPasswordDialog> {
  final TextEditingController _email = TextEditingController();
  bool _submitting = false;
  bool _sent = false;
  String? _error;

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final String email = _email.text.trim();
    if (email.isEmpty) {
      setState(() => _error = 'Enter your email');
      return;
    }

    setState(() {
      _submitting = true;
      _error = null;
    });

    try {
      await widget.authRepository.sendPasswordResetEmail(email);
      if (!mounted) return;
      setState(() {
        _sent = true;
        _submitting = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _submitting = false;
        _error = e is OfficerApiException ? e.message : 'Could not send the reset email';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 360),
        child: OfficerCard(
          padding: const EdgeInsets.all(22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: _sent ? _sentContent() : _formContent(),
          ),
        ),
      ),
    );
  }

  List<Widget> _formContent() {
    return <Widget>[
      Row(
        children: <Widget>[
          const Expanded(
            child: Text(
              'Reset your password',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: OfficerPalette.ink,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close_rounded, size: 18),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      const SizedBox(height: 4),
      const Text(
        'We’ll email you a link to set a new password.',
        style: TextStyle(fontSize: 12.5, color: OfficerPalette.body),
      ),
      const SizedBox(height: 14),
      LabeledField(
        label: 'EMAIL',
        controller: _email,
        keyboardType: TextInputType.emailAddress,
      ),
      if (_error != null) ...<Widget>[
        const SizedBox(height: 10),
        Text(
          _error!,
          style: const TextStyle(fontSize: 12, color: OfficerPalette.statusRed),
        ),
      ],
      const SizedBox(height: 16),
      OfficerPrimaryButton(
        label: _submitting ? 'Sending…' : 'Send reset link →',
        onPressed: _submitting ? null : _submit,
      ),
    ];
  }

  List<Widget> _sentContent() {
    return <Widget>[
      Row(
        children: <Widget>[
          const Expanded(
            child: Text(
              'Check your email',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: OfficerPalette.ink,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close_rounded, size: 18),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      const SizedBox(height: 8),
      Text(
        'If ${_email.text.trim()} has an account, a reset link is on its way.',
        style: const TextStyle(fontSize: 12.5, height: 1.4, color: OfficerPalette.body),
      ),
      const SizedBox(height: 16),
      OfficerSecondaryButton(
        label: 'Done',
        onPressed: () => Navigator.of(context).pop(),
      ),
    ];
  }
}
