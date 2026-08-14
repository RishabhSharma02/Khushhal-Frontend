/// Officer login (Officer Portal 5h).
library;

import 'package:flutter/material.dart';

import '../../data/officer_demo_data.dart';
import '../theme/officer_palette.dart';
import '../widgets/labeled_field.dart';
import '../widgets/officer_avatar.dart';
import '../widgets/officer_buttons.dart';
import 'widgets/auth_scaffold.dart';

/// The sign-in form. There is no backend, so any email/password combination
/// signs the officer in as the demo officer.
class LoginScreen extends StatefulWidget {
  /// Creates the login screen.
  const LoginScreen({
    super.key,
    required this.onSignIn,
    required this.onForgotPassword,
    required this.onCreateAccount,
  });

  /// Called once the officer submits the sign-in form.
  final VoidCallback onSignIn;

  /// Called when "Forgot password?" is tapped.
  final VoidCallback onForgotPassword;

  /// Called when "Create account" is tapped.
  final VoidCallback onCreateAccount;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final TextEditingController _email = TextEditingController(
    text: OfficerDemoData.officer.email,
  );
  final TextEditingController _password = TextEditingController(
    text: 'khushhal123',
  );
  bool _obscure = true;
  bool _rememberMe = true;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      logo: const OfficerAvatar(text: '☘', size: 56, fontSize: 26),
      title: "KHUSH-HAL Officers' Portal",
      subtitle: 'Sign in to your account',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          LabeledField(label: 'EMAIL', controller: _email),
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
                _obscure
                    ? Icons.visibility_rounded
                    : Icons.visibility_off_rounded,
              ),
              onPressed: () => setState(() => _obscure = !_obscure),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 6,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: <Widget>[
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(
                    width: 22,
                    height: 22,
                    child: Checkbox(
                      value: _rememberMe,
                      activeColor: OfficerPalette.forest,
                      onChanged: (bool? value) =>
                          setState(() => _rememberMe = value ?? true),
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Text(
                    'Remember me',
                    style: TextStyle(fontSize: 12, color: OfficerPalette.body),
                  ),
                ],
              ),
              TextButton(
                onPressed: widget.onForgotPassword,
                style: TextButton.styleFrom(
                  foregroundColor: OfficerPalette.forest,
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text(
                  'Forgot password?',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          OfficerPrimaryButton(label: 'Sign in →', onPressed: widget.onSignIn),
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
