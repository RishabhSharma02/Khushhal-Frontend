import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/theme.dart';
import '../../../core/widgets/online_required_notice.dart';
import '../../../l10n/app_localizations.dart';
import '../../onboarding/domain/usp_slide.dart' show OnboardingAssets;
import '../bloc/auth_bloc.dart';
import 'otp_verify_screen.dart';
import 'widgets/auth_backdrop.dart';

/// Design 1f — mobile number entry.
///
/// Layout matches the imported mock exactly: gradient bg, "Enter your
/// mobile number" title, muted subtitle, single field with a fixed +91
/// prefix, and a gradient "Get OTP" CTA pinned to the bottom.
class PhoneLoginScreen extends StatefulWidget {
  const PhoneLoginScreen({super.key});

  @override
  State<PhoneLoginScreen> createState() => _PhoneLoginScreenState();
}

class _PhoneLoginScreenState extends State<PhoneLoginScreen> {
  final _controller = TextEditingController();
  bool _isValid = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      final v = _controller.text.length == 10;
      if (v != _isValid) setState(() => _isValid = v);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_isValid) return;
    // Firebase has to reach its servers to send an SMS; queueing this would
    // just mean a code the user never receives.
    if (!requireOnline(context, 'sign in')) return;
    context.read<AuthBloc>().add(
      AuthPhoneSubmitted('+91${_controller.text.trim()}'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listenWhen: (a, b) => a.status != b.status,
      listener: (context, state) {
        if (state.status == AuthStatus.codeSent) {
          Navigator.of(context).push(
            MaterialPageRoute<void>(builder: (_) => const OtpVerifyScreen()),
          );
        } else if (state.status == AuthStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? 'Something went wrong'),
            ),
          );
        }
      },
      builder: (context, state) {
        final sending = state.status == AuthStatus.sendingCode;
        return Scaffold(
          body: AuthBackdrop(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(22, 8, 22, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const _StatusBarSpacer(),
                  const SizedBox(height: 18),
                  const _BrandMark(),
                  const SizedBox(height: 24),
                  Text(
                    AppLocalizations.of(context)!.authPhoneTitle,
                    style: GoogleFonts.lexend(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF123B27),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    AppLocalizations.of(context)!.authPhoneSubtitle,
                    style: GoogleFonts.lexend(
                      fontSize: 13.5,
                      height: 1.5,
                      color: const Color(0xFF5C6B62),
                    ),
                  ),
                  const SizedBox(height: 18),
                  _PhoneField(controller: _controller),
                  const Spacer(),
                  if (sending)
                    const Padding(
                      padding: EdgeInsets.only(bottom: 12),
                      child: LinearProgressIndicator(minHeight: 2),
                    ),
                  _GradientCta(
                    label: sending
                        ? AppLocalizations.of(context)!.authSending
                        : AppLocalizations.of(context)!.authGetOtp,
                    enabled: _isValid && !sending,
                    onTap: _submit,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _StatusBarSpacer extends StatelessWidget {
  const _StatusBarSpacer();

  @override
  Widget build(BuildContext context) {
    // Design shows the system 9:41 + battery/signal row; on iOS we already
    // pad via SafeArea inside AuthBackdrop, so nothing to draw here.
    return const SizedBox.shrink();
  }
}

/// Compact brand mark shown at the top of auth screens (design 1a shrunk
/// to a badge). Keeps the phone / PIN screens from feeling empty.
class _BrandMark extends StatelessWidget {
  const _BrandMark();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      children: <Widget>[
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: AppPalette.onPrimary,
            shape: BoxShape.circle,
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: AppPalette.forest.withValues(alpha: 0.35),
                offset: const Offset(0, 10),
                blurRadius: 18,
                spreadRadius: -12,
              ),
            ],
          ),
          child: ClipOval(
            child: Transform.scale(
              scale: 2.1,
              child: Image.asset(
                OnboardingAssets.logo,
                fit: BoxFit.cover,
                semanticLabel: l10n.brandName,
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          l10n.brandName,
          style: GoogleFonts.lexend(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.9,
            color: AppPalette.ink,
          ),
        ),
      ],
    );
  }
}

class _PhoneField extends StatelessWidget {
  const _PhoneField({required this.controller});
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF175235), width: 1.5),
      ),
      child: Row(
        children: [
          Text(
            '+91',
            style: GoogleFonts.lexend(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF7A8A7F),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.phone,
              maxLength: 10,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              autofocus: true,
              style: GoogleFonts.lexend(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1C2B24),
                letterSpacing: 2,
              ),
              decoration: InputDecoration(
                counterText: '',
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                focusedErrorBorder: InputBorder.none,
                hintText: '98765 43210',
                hintStyle: GoogleFonts.lexend(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFAFC4B3),
                  letterSpacing: 2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GradientCta extends StatelessWidget {
  const _GradientCta({
    required this.label,
    required this.enabled,
    required this.onTap,
  });
  final String label;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: enabled ? 1 : 0.55,
      child: GestureDetector(
        onTap: enabled ? onTap : null,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 17),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF1F7A45), Color(0xFF2F9E5F)],
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x8C1F7A45), // rgba(31,122,69,.55)
                blurRadius: 30,
                spreadRadius: -14,
                offset: Offset(0, 14),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: GoogleFonts.lexend(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
