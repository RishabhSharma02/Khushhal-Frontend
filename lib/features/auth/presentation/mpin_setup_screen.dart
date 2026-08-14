import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/theme.dart';
import '../../../l10n/app_localizations.dart';
import '../../onboarding/domain/usp_slide.dart' show OnboardingAssets;
import '../bloc/lock_cubit.dart';
import 'widgets/auth_backdrop.dart';
import 'widgets/pin_dots.dart';

/// Designs 1g2 (create) + confirm reuses the same layout with different copy
/// per the design note: "Confirm step reuses the same screen with 'Type it
/// again'". Shown once, right after the first OTP succeeds.
class MpinSetupScreen extends StatefulWidget {
  const MpinSetupScreen({super.key});

  @override
  State<MpinSetupScreen> createState() => _MpinSetupScreenState();
}

enum _Stage { enter, confirm }

class _MpinSetupScreenState extends State<MpinSetupScreen> {
  final _controller = TextEditingController();
  final _focus = FocusNode();
  _Stage _stage = _Stage.enter;
  String? _firstPin;
  String? _error;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onChange);
    WidgetsBinding.instance.addPostFrameCallback((_) => _focus.requestFocus());
  }

  void _onChange() {
    setState(() {}); // repaint dots
    if (_controller.text.length != 4) return;

    if (_stage == _Stage.enter) {
      _firstPin = _controller.text;
      _controller.clear();
      setState(() {
        _stage = _Stage.confirm;
        _error = null;
      });
      return;
    }

    // Confirm stage.
    if (_controller.text == _firstPin) {
      context.read<LockCubit>().confirmSetup(_controller.text);
    } else {
      setState(() {
        _error = AppLocalizations.of(context)!.authPinMismatch;
        _stage = _Stage.enter;
        _firstPin = null;
      });
      _controller.clear();
    }
  }

  @override
  void dispose() {
    _focus.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final title = _stage == _Stage.enter ? l10n.authCreatePinTitle : l10n.authConfirmPinTitle;
    final subtitle = _stage == _Stage.enter
        ? l10n.authCreatePinSubtitle
        : l10n.authConfirmPinSubtitle;
    return Scaffold(
      body: AuthBackdrop(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 8, 22, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 12),
              const _BrandMark(),
              const SizedBox(height: 20),
              const Center(child: _LockIcon()),
              const SizedBox(height: 12),
              Text(title,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.lexend(
                    fontSize: 22, fontWeight: FontWeight.w600, color: const Color(0xFF123B27),
                  )),
              const SizedBox(height: 5),
              Text(subtitle,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.lexend(
                    fontSize: 14, height: 1.5, color: const Color(0xFF5C6B62),
                  )),
              const SizedBox(height: 24),
              Stack(
                alignment: Alignment.center,
                children: [
                  PinDots(filled: _controller.text.length),
                  SizedBox(
                    width: 1, height: 1,
                    child: Opacity(
                      opacity: 0,
                      child: TextField(
                        controller: _controller,
                        focusNode: _focus,
                        keyboardType: TextInputType.number,
                        obscureText: true,
                        maxLength: 4,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        showCursor: false,
                        decoration: const InputDecoration(counterText: '', border: InputBorder.none),
                      ),
                    ),
                  ),
                ],
              ),
              if (_error != null) ...[
                const SizedBox(height: 14),
                Text(_error!,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lexend(
                      fontSize: 13, color: Theme.of(context).colorScheme.error,
                    )),
              ],
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

/// Small brand badge shared with the phone-login screen so the mPIN setup
/// step doesn't feel blank at the top.
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
        const SizedBox(height: 8),
        Text(
          l10n.brandName,
          style: GoogleFonts.lexend(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.9,
            color: AppPalette.ink,
          ),
        ),
      ],
    );
  }
}

class _LockIcon extends StatelessWidget {
  const _LockIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56, height: 56,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [BoxShadow(color: Color(0x66175235), blurRadius: 26, spreadRadius: -14, offset: Offset(0, 12))],
      ),
      alignment: Alignment.center,
      child: const Icon(Icons.lock_outline, size: 26, color: Color(0xFF175235)),
    );
  }
}
