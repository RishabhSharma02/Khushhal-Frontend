import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../l10n/app_localizations.dart';
import '../bloc/auth_bloc.dart';
import 'widgets/auth_backdrop.dart';
import 'widgets/otp_boxes.dart';

/// Design 1g — OTP verify with auto-read.
///
/// 4 boxes (not 6) per the imported mock; auto-submits the code the moment
/// the fourth digit lands. A muted 30-second countdown offers "Resend"
/// once expired; the "change" link pops back to phone entry.
class OtpVerifyScreen extends StatefulWidget {
  const OtpVerifyScreen({super.key});

  @override
  State<OtpVerifyScreen> createState() => _OtpVerifyScreenState();
}

class _OtpVerifyScreenState extends State<OtpVerifyScreen> {
  final _controller = TextEditingController();
  final _focus = FocusNode();
  Timer? _timer;
  int _secondsLeft = 30;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
    _controller.addListener(_maybeSubmit);
    WidgetsBinding.instance.addPostFrameCallback((_) => _focus.requestFocus());
  }

  void _startResendTimer() {
    _timer?.cancel();
    setState(() => _secondsLeft = 30);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      setState(() => _secondsLeft--);
      if (_secondsLeft <= 0) t.cancel();
    });
  }

  void _maybeSubmit() {
    if (_controller.text.length == 6) {
      context.read<AuthBloc>().add(AuthOtpSubmitted(_controller.text));
    }
    setState(() {}); // repaint OTP boxes
  }

  @override
  void dispose() {
    _timer?.cancel();
    _focus.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listenWhen: (a, b) => a.status != b.status || a.errorMessage != b.errorMessage,
      listener: (context, state) {
        if (state.status == AuthStatus.authenticated) {
          Navigator.of(context).popUntil((r) => r.isFirst);
        } else if (state.status == AuthStatus.error && state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage!)),
          );
          _controller.clear();
        }
      },
      builder: (context, state) {
        final busy = state.status == AuthStatus.verifying || state.status == AuthStatus.sendingCode;
        final phone = state.phoneE164 ?? '';
        return Scaffold(
          body: AuthBackdrop(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(22, 8, 22, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: InkResponse(
                      onTap: () => Navigator.of(context).maybePop(),
                      radius: 22,
                      child: const Padding(
                        padding: EdgeInsets.all(4),
                        child: Icon(Icons.arrow_back_rounded, size: 24, color: Color(0xFF175235)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(AppLocalizations.of(context)!.authEnterCode,
                      style: GoogleFonts.lexend(
                        fontSize: 22, fontWeight: FontWeight.w600, color: const Color(0xFF123B27),
                      )),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Text(AppLocalizations.of(context)!.authSentTo(phone),
                          style: GoogleFonts.lexend(
                            fontSize: 13.5, color: const Color(0xFF5C6B62),
                          )),
                      GestureDetector(
                        onTap: () => Navigator.of(context).maybePop(),
                        child: Text('change',
                            style: GoogleFonts.lexend(
                              fontSize: 13.5,
                              color: const Color(0xFF5C6B62),
                              decoration: TextDecoration.underline,
                            )),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      OtpBoxes(value: _controller.text),
                      // Invisible input drives the boxes above; keyboard opens
                      // on this. Zero-size + zero-opacity so it never draws.
                      SizedBox(
                        width: 1, height: 1,
                        child: Opacity(
                          opacity: 0,
                          child: TextField(
                            controller: _controller,
                            focusNode: _focus,
                            keyboardType: TextInputType.number,
                            maxLength: 6,
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            enableSuggestions: false,
                            autocorrect: false,
                            showCursor: false,
                            decoration: const InputDecoration(counterText: '', border: InputBorder.none),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Center(
                    child: _secondsLeft > 0
                        ? Text(
                            AppLocalizations.of(context)!.authResendIn(
                              _secondsLeft.toString().padLeft(2, '0'),
                            ),
                            style: GoogleFonts.lexend(
                              fontSize: 13.5, color: const Color(0xFF5C6B62),
                            ))
                        : GestureDetector(
                            onTap: busy ? null : () {
                              context.read<AuthBloc>().add(const AuthResendRequested());
                              _startResendTimer();
                            },
                            child: Text(AppLocalizations.of(context)!.authResendCode,
                                style: GoogleFonts.lexend(
                                  fontSize: 13.5, color: const Color(0xFF175235),
                                  fontWeight: FontWeight.w600,
                                  decoration: TextDecoration.underline,
                                )),
                          ),
                  ),
                  if (busy) const Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Center(child: SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2.5))),
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

