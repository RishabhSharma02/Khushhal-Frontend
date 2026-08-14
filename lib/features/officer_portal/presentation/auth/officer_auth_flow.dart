/// The pre-login stretch: login, sign up, set password, forgot password.
library;

import 'package:flutter/material.dart';

import '../../data/officer_demo_data.dart';
import 'forgot_password_screen.dart';
import 'login_screen.dart';
import 'set_password_screen.dart';
import 'signup_screen.dart';

enum _AuthStep { login, signup, setPassword, forgotPassword }

/// Switches between the four auth screens without a `Navigator`, mirroring
/// the consumer app's `OnboardingFlow`/`SetupFlow`.
class OfficerAuthFlow extends StatefulWidget {
  /// Creates the auth flow.
  const OfficerAuthFlow({super.key, required this.onAuthenticated});

  /// Called once sign-in, sign-up, or password reset completes.
  final VoidCallback onAuthenticated;

  @override
  State<OfficerAuthFlow> createState() => _OfficerAuthFlowState();
}

class _OfficerAuthFlowState extends State<OfficerAuthFlow> {
  _AuthStep _step = _AuthStep.login;
  String _pendingEmail = OfficerDemoData.officer.email;
  SetPasswordMode _passwordMode = SetPasswordMode.signup;

  void _goTo(_AuthStep step) => setState(() => _step = step);

  @override
  Widget build(BuildContext context) {
    return switch (_step) {
      _AuthStep.login => LoginScreen(
        onSignIn: widget.onAuthenticated,
        onForgotPassword: () => _goTo(_AuthStep.forgotPassword),
        onCreateAccount: () => _goTo(_AuthStep.signup),
      ),
      _AuthStep.signup => SignupScreen(
        onContinue: (String email) {
          _pendingEmail = email;
          _passwordMode = SetPasswordMode.signup;
          _goTo(_AuthStep.setPassword);
        },
        onSignIn: () => _goTo(_AuthStep.login),
      ),
      _AuthStep.setPassword => SetPasswordScreen(
        mode: _passwordMode,
        email: _pendingEmail,
        onSubmit: widget.onAuthenticated,
      ),
      _AuthStep.forgotPassword => ForgotPasswordScreen(
        onBackToSignIn: () => _goTo(_AuthStep.login),
      ),
    };
  }
}
