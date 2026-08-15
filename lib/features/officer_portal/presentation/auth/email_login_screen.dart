/// Officer sign-in via Firebase email/password.
library;

import 'package:flutter/material.dart';

import '../../data/officer_api_client.dart';
import '../../data/officer_auth_repository.dart';
import '../../domain/officer_profile.dart';
import '../theme/officer_palette.dart';
import '../widgets/labeled_field.dart';
import '../widgets/officer_avatar.dart';
import '../widgets/officer_buttons.dart';
import 'forgot_password_dialog.dart';
import 'widgets/auth_scaffold.dart';

/// The sign-in form: email + password against Firebase Auth.
class EmailLoginScreen extends StatefulWidget {
  /// Creates the login screen.
  const EmailLoginScreen({
    super.key,
    required this.authRepository,
    required this.onAuthenticated,
    required this.onCreateAccount,
  });

  final OfficerAuthRepository authRepository;

  /// Called once sign-in succeeds, with the officer's profile.
  final void Function(OfficerProfile profile) onAuthenticated;

  /// Called when "Create account" is tapped.
  final VoidCallback onCreateAccount;

  @override
  State<EmailLoginScreen> createState() => _EmailLoginScreenState();
}

class _EmailLoginScreenState extends State<EmailLoginScreen> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool _obscure = true;
  bool _submitting = false;
  String? _error;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final String email = _email.text.trim();
    final String password = _password.text;
    if (email.isEmpty || password.isEmpty) {
      setState(() => _error = 'Enter your email and password');
      return;
    }

    setState(() {
      _submitting = true;
      _error = null;
    });

    try {
      final OfficerProfile profile = await widget.authRepository.signIn(
        email: email,
        password: password,
      );
      if (!mounted) return;
      widget.onAuthenticated(profile);
    } on Exception catch (e) {
      if (!mounted) return;
      setState(() => _error = e is OfficerApiException ? e.message : 'Could not sign in');
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      logo: const OfficerAvatar.logo(
        imageAsset: 'assets/images/khushhal_logo.jpg',
        size: 56,
      ),
      title: "KHUSH-HAL Officers' Portal",
      subtitle: 'Sign in to your account',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          LabeledField(
            label: 'EMAIL',
            controller: _email,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 14),
          LabeledField(
            label: 'PASSWORD',
            controller: _password,
            obscureText: _obscure,
            trailing: IconButton(
              padding: EdgeInsets.zero,
              iconSize: 18,
              color: OfficerPalette.muted,
              icon: Icon(
                _obscure ? Icons.visibility_rounded : Icons.visibility_off_rounded,
              ),
              onPressed: () => setState(() => _obscure = !_obscure),
            ),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () => showForgotPasswordDialog(
                context: context,
                authRepository: widget.authRepository,
              ),
              child: const Text(
                'Forgot password?',
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  color: OfficerPalette.forest,
                ),
              ),
            ),
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
            label: _submitting ? 'Signing in…' : 'Sign in →',
            onPressed: _submitting ? null : _submit,
          ),
          const SizedBox(height: 14),
          Center(
            child: Wrap(
              alignment: WrapAlignment.center,
              children: <Widget>[
                const Text(
                  'New officer? ',
                  style: TextStyle(fontSize: 12.5, color: OfficerPalette.muted),
                ),
                GestureDetector(
                  onTap: widget.onCreateAccount,
                  child: const Text(
                    'Create account',
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                      color: OfficerPalette.forest,
                    ),
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
