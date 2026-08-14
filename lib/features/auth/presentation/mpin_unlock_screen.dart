import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../app/session.dart';
import '../../../l10n/app_localizations.dart';
import '../../../main.dart' show ChangeNumberScope;
import '../bloc/lock_cubit.dart';
import 'widgets/auth_backdrop.dart';
import 'widgets/pin_dots.dart';

/// Design 1g3 — returning user's mPIN login (works offline).
///
/// Avatar with the owner's initial, "Welcome back, {name}", 4 dots, and a
/// "Forgot PIN? Login with OTP" escape hatch that hard-resets the mPIN and
/// bounces back to the phone screen.
class MpinUnlockScreen extends StatefulWidget {
  const MpinUnlockScreen({super.key});

  @override
  State<MpinUnlockScreen> createState() => _MpinUnlockScreenState();
}

class _MpinUnlockScreenState extends State<MpinUnlockScreen> {
  final _controller = TextEditingController();
  final _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onChange);
    WidgetsBinding.instance.addPostFrameCallback((_) => _focus.requestFocus());
  }

  void _onChange() {
    setState(() {}); // repaint dots
    if (_controller.text.length == 4) {
      context.read<LockCubit>().unlock(_controller.text);
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
    final session = SessionScope.of(context);
    final name = (session.ownerName ?? '').trim();
    final firstName = name.isEmpty ? 'there' : name.split(' ').first;
    final initial = name.isEmpty ? '?' : name[0].toUpperCase();

    return Scaffold(
      body: AuthBackdrop(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 8, 22, 12),
          child: BlocBuilder<LockCubit, AppLockState>(
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 34),
                  Center(child: _Avatar(initial: initial)),
                  const SizedBox(height: 12),
                  Text(AppLocalizations.of(context)!.authWelcomeBack(firstName),
                      textAlign: TextAlign.center,
                      style: GoogleFonts.lexend(
                        fontSize: 22, fontWeight: FontWeight.w600, color: const Color(0xFF123B27),
                      )),
                  const SizedBox(height: 4),
                  Text(AppLocalizations.of(context)!.authEnterPin,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.lexend(
                        fontSize: 14, color: const Color(0xFF5C6B62),
                      )),
                  const SizedBox(height: 26),
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
                  if (state.error != null) ...[
                    const SizedBox(height: 14),
                    Text(state.error!,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.lexend(
                          fontSize: 13, color: Theme.of(context).colorScheme.error,
                        )),
                  ],
                  const SizedBox(height: 24),
                  GestureDetector(
                    onTap: () {
                      // Do NOT clear the PIN or sign Firebase out yet —
                      // we only want to route to the phone screen so a
                      // new number can be entered. The stored PIN and
                      // cached identity are wiped only after that OTP
                      // verifies (see `_AuthGate`'s BlocListener). If
                      // the user drops out or kills the app before then,
                      // the next launch drops them right back onto this
                      // unlock screen with their existing account.
                      ChangeNumberScope.request(context);
                    },
                    child: Text(AppLocalizations.of(context)!.authForgotPin,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.lexend(
                          fontSize: 13.5, color: const Color(0xFF5C6B62),
                          decoration: TextDecoration.underline,
                        )),
                  ),
                  const Spacer(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.initial});
  final String initial;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 66, height: 66,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF175235), Color(0xFF2F9E5F)],
        ),
        boxShadow: [BoxShadow(color: Color(0x80175235), blurRadius: 26, spreadRadius: -14, offset: Offset(0, 12))],
      ),
      alignment: Alignment.center,
      child: Text(initial,
          style: GoogleFonts.lexend(
            fontSize: 27, fontWeight: FontWeight.w700, color: Colors.white,
          )),
    );
  }
}
