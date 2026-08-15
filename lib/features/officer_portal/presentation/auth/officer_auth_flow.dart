/// The pre-login stretch: sign in, or create a new account.
library;

import 'package:flutter/material.dart';

import '../../data/officer_auth_repository.dart';
import '../../domain/officer_profile.dart';
import 'email_login_screen.dart';
import 'email_signup_screen.dart';

enum _AuthStep { login, signup }

/// Switches between the login and signup screens without a `Navigator`,
/// mirroring the consumer app's `OnboardingFlow`/`SetupFlow`.
class OfficerAuthFlow extends StatefulWidget {
  /// Creates the auth flow.
  const OfficerAuthFlow({
    super.key,
    required this.onAuthenticated,
    required this.authRepository,
  });

  /// Called once sign-in or sign-up succeeds, with the officer's profile.
  final void Function(OfficerProfile profile) onAuthenticated;

  /// Firebase-backed by default; tests inject a fake.
  final OfficerAuthRepository authRepository;

  @override
  State<OfficerAuthFlow> createState() => _OfficerAuthFlowState();
}

class _OfficerAuthFlowState extends State<OfficerAuthFlow> {
  _AuthStep _step = _AuthStep.login;

  @override
  Widget build(BuildContext context) {
    return switch (_step) {
      _AuthStep.login => EmailLoginScreen(
        authRepository: widget.authRepository,
        onAuthenticated: widget.onAuthenticated,
        onCreateAccount: () => setState(() => _step = _AuthStep.signup),
      ),
      _AuthStep.signup => EmailSignupScreen(
        authRepository: widget.authRepository,
        onAuthenticated: widget.onAuthenticated,
        onSignIn: () => setState(() => _step = _AuthStep.login),
      ),
    };
  }
}
