import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

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
        _error = 'The PINs do not match. Try again.';
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
    final title = _stage == _Stage.enter ? 'Create your PIN' : 'Type it again';
    final subtitle = _stage == _Stage.enter
        ? 'Pick 4 digits you will remember.\nNext time you open the app, just enter this.'
        : 'Enter the same 4 digits once more to confirm.';
    return Scaffold(
      body: AuthBackdrop(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 8, 22, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 12),
              const _VerifiedChip(),
              const SizedBox(height: 26),
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

class _VerifiedChip extends StatelessWidget {
  const _VerifiedChip();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
          decoration: BoxDecoration(
            color: const Color(0xFFE7F5EC),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check, size: 16, color: Color(0xFF1F7A45)),
              const SizedBox(width: 8),
              Text('Number verified',
                  style: GoogleFonts.lexend(
                    fontSize: 13, fontWeight: FontWeight.w600, color: const Color(0xFF1F7A45),
                  )),
            ],
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
