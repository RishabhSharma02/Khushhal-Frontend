/// Officer sign-in, step 2: OTP entry.
library;

import 'package:flutter/material.dart';

import '../../data/officer_api_client.dart';
import '../../data/officer_auth_repository.dart';
import '../../domain/officer_profile.dart';
import '../theme/officer_palette.dart';
import '../widgets/officer_avatar.dart';
import '../widgets/officer_buttons.dart';
import 'widgets/auth_scaffold.dart';

/// Collects the 6-digit code sent to [phoneE164] and completes sign-in via
/// [OfficerAuthRepository.verifyOtp].
class OtpScreen extends StatefulWidget {
  const OtpScreen({
    super.key,
    required this.authRepository,
    required this.phoneE164,
    required this.verificationId,
    required this.onVerified,
    required this.onResend,
    required this.onBackToPhone,
  });

  final OfficerAuthRepository authRepository;
  final String phoneE164;
  final String verificationId;
  final void Function(OfficerProfile profile) onVerified;
  final VoidCallback onResend;
  final VoidCallback onBackToPhone;

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController _code = TextEditingController();
  bool _submitting = false;
  String? _error;
  bool _notRegistered = false;

  @override
  void dispose() {
    _code.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final String code = _code.text.trim();
    if (code.length != 6) {
      setState(() => _error = 'Enter the 6-digit code');
      return;
    }

    setState(() {
      _submitting = true;
      _error = null;
      _notRegistered = false;
    });

    try {
      final OfficerProfile profile = await widget.authRepository.verifyOtp(
        verificationId: widget.verificationId,
        smsCode: code,
      );
      if (!mounted) return;
      widget.onVerified(profile);
    } on OfficerNotRegisteredException {
      if (!mounted) return;
      setState(() {
        _notRegistered = true;
        _error = 'No officer account is registered for this number. Contact your admin.';
      });
    } on Exception catch (e) {
      if (!mounted) return;
      setState(() => _error = e is OfficerApiException ? e.message : 'That code was not accepted');
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      logo: const OfficerAvatar(text: '☘', size: 56, fontSize: 26),
      title: 'Enter the code',
      subtitle: 'We sent a 6-digit code to ${widget.phoneE164}',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextField(
            controller: _code,
            keyboardType: TextInputType.number,
            maxLength: 6,
            decoration: const InputDecoration(counterText: '', hintText: 'OTP'),
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
            label: _submitting ? 'Verifying…' : 'Verify →',
            onPressed: _submitting ? null : _submit,
          ),
          const SizedBox(height: 14),
          Center(
            child: Wrap(
              alignment: WrapAlignment.center,
              spacing: 12,
              children: <Widget>[
                if (!_notRegistered)
                  TextButton(
                    onPressed: _submitting ? null : widget.onResend,
                    style: TextButton.styleFrom(
                      foregroundColor: OfficerPalette.forest,
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text(
                      'Resend code',
                      style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700),
                    ),
                  ),
                GestureDetector(
                  onTap: widget.onBackToPhone,
                  child: const Text(
                    '← Change number',
                    style: TextStyle(fontSize: 12.5, color: OfficerPalette.muted),
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
