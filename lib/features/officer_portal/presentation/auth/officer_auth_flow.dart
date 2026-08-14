/// The pre-login stretch: phone number, then OTP.
library;

import 'package:flutter/material.dart';

import '../../data/officer_auth_repository.dart';
import '../../domain/officer_profile.dart';
import 'otp_screen.dart';
import 'phone_screen.dart';

enum _AuthStep { phone, otp }

/// Switches between the phone and OTP screens without a `Navigator`,
/// mirroring the consumer app's `OnboardingFlow`/`SetupFlow`.
class OfficerAuthFlow extends StatefulWidget {
  /// Creates the auth flow.
  const OfficerAuthFlow({
    super.key,
    required this.onAuthenticated,
    required this.authRepository,
  });

  /// Called once OTP verification succeeds, with the officer's profile.
  final void Function(OfficerProfile profile) onAuthenticated;

  /// Firebase-backed by default; tests inject a fake.
  final OfficerAuthRepository authRepository;

  @override
  State<OfficerAuthFlow> createState() => _OfficerAuthFlowState();
}

class _OfficerAuthFlowState extends State<OfficerAuthFlow> {
  _AuthStep _step = _AuthStep.phone;
  String _phoneE164 = '';
  String _verificationId = '';

  void _handleCodeSent(String phoneE164, String verificationId) {
    setState(() {
      _phoneE164 = phoneE164;
      _verificationId = verificationId;
      _step = _AuthStep.otp;
    });
  }

  Future<void> _handleResend() async {
    final String verificationId = await widget.authRepository.sendOtp(_phoneE164);
    if (!mounted) return;
    setState(() => _verificationId = verificationId);
  }

  @override
  Widget build(BuildContext context) {
    return switch (_step) {
      _AuthStep.phone => PhoneScreen(
        authRepository: widget.authRepository,
        onCodeSent: _handleCodeSent,
      ),
      _AuthStep.otp => OtpScreen(
        authRepository: widget.authRepository,
        phoneE164: _phoneE164,
        verificationId: _verificationId,
        onVerified: widget.onAuthenticated,
        onResend: _handleResend,
        onBackToPhone: () => setState(() => _step = _AuthStep.phone),
      ),
    };
  }
}
