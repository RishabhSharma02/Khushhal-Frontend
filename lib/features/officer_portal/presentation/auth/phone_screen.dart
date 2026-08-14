/// Officer sign-in, step 1: phone number entry.
library;

import 'package:flutter/material.dart';

import '../../data/officer_api_client.dart';
import '../../data/officer_auth_repository.dart';
import '../theme/officer_palette.dart';
import '../widgets/officer_avatar.dart';
import '../widgets/officer_buttons.dart';
import 'widgets/auth_scaffold.dart';

/// Collects a 10-digit mobile number and requests an OTP via
/// [OfficerAuthRepository.sendOtp].
class PhoneScreen extends StatefulWidget {
  const PhoneScreen({
    super.key,
    required this.authRepository,
    required this.onCodeSent,
  });

  final OfficerAuthRepository authRepository;

  /// Called with the E.164 phone number and the resulting verification
  /// handle once the OTP has been sent.
  final void Function(String phoneE164, String verificationId) onCodeSent;

  @override
  State<PhoneScreen> createState() => _PhoneScreenState();
}

class _PhoneScreenState extends State<PhoneScreen> {
  final TextEditingController _phone = TextEditingController();
  bool _submitting = false;
  String? _error;

  @override
  void dispose() {
    _phone.dispose();
    super.dispose();
  }

  String? get _e164 {
    final String digits = _phone.text.trim();
    if (digits.length != 10) return null;
    return '+91$digits';
  }

  Future<void> _submit() async {
    final String? phoneE164 = _e164;
    if (phoneE164 == null) {
      setState(() => _error = 'Enter a 10-digit mobile number');
      return;
    }

    setState(() {
      _submitting = true;
      _error = null;
    });

    try {
      final String verificationId = await widget.authRepository.sendOtp(phoneE164);
      if (!mounted) return;
      widget.onCodeSent(phoneE164, verificationId);
    } on Exception catch (e) {
      if (!mounted) return;
      setState(() => _error = e is OfficerApiException ? e.message : 'Could not send the OTP');
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      logo: const OfficerAvatar(text: '☘', size: 56, fontSize: 26),
      title: "KHUSH-HAL Officers' Portal",
      subtitle: "Sign in with your registered mobile number",
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                decoration: BoxDecoration(
                  color: OfficerPalette.soft,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  '+91',
                  style: TextStyle(fontSize: 14, color: OfficerPalette.ink),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: _phone,
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                  decoration: const InputDecoration(
                    counterText: '',
                    hintText: 'MOBILE NUMBER',
                  ),
                ),
              ),
            ],
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
            label: _submitting ? 'Sending…' : 'Send OTP →',
            onPressed: _submitting ? null : _submit,
          ),
        ],
      ),
    );
  }
}
