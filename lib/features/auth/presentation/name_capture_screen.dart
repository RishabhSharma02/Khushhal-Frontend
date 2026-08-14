import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../app/session.dart';
import '../../../core/sync/sync_engine.dart';
import '../../../core/widgets/gradient_cta_button.dart';
import '../../../l10n/app_localizations.dart';
import '../data/profile_repository.dart';
import 'widgets/auth_backdrop.dart';

/// One-shot "who are we saving?" screen — shown right after the mPIN gets
/// set for the first time so Settings + the mPIN unlock avatar have a real
/// name instead of the phone number.
class NameCaptureScreen extends StatefulWidget {
  const NameCaptureScreen({super.key, required this.onDone});

  final VoidCallback onDone;

  @override
  State<NameCaptureScreen> createState() => _NameCaptureScreenState();
}

class _NameCaptureScreenState extends State<NameCaptureScreen> {
  final _first = TextEditingController();
  final _last = TextEditingController();
  bool _saving = false;
  String? _error;

  @override
  void dispose() {
    _first.dispose();
    _last.dispose();
    super.dispose();
  }

  bool get _isValid => _first.text.trim().isNotEmpty;

  Future<void> _submit() async {
    if (!_isValid || _saving) return;
    final name = [_first.text.trim(), _last.text.trim()]
        .where((s) => s.isNotEmpty)
        .join(' ');
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      // Local-first: the name lands in SQLite and the PATCH is queued. The
      // old bare PATCH left a user on a weak connection stuck on this form
      // with no way past it, even though they had already set their mPIN.
      await context.read<ProfileRepository>().setName(name);
      if (!mounted) return;
      SessionScope.of(context).applyProfile(
        name: name,
        phone: SessionScope.of(context).ownerPhone,
      );
      // Nudge the sync engine so the PATCH /me goes out right now instead of
      // waiting for the 5-minute poll. Without this, signing in on another
      // device (or on this one after uninstall) before the poll fires means
      // the backend still has `name = null` and the name-capture screen
      // asks for the name a second time.
      try {
        // ignore: discarded_futures
        context.read<SyncEngine>().syncNow();
      } catch (_) {/* engine may not be provided in tests */}
      widget.onDone();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _saving = false;
        _error = AppLocalizations.of(context)!.authSaveFailed(e.toString());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: AuthBackdrop(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 8, 22, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              Text(l10n.authWelcomeTitle,
                  style: GoogleFonts.lexend(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF123B27),
                  )),
              const SizedBox(height: 5),
              Text(l10n.authWhatToCallYou,
                  style: GoogleFonts.lexend(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF1C2B24),
                  )),
              const SizedBox(height: 28),
              _NameField(controller: _first, label: l10n.authFirstName, autofocus: true, onChanged: (_) => setState(() {})),
              const SizedBox(height: 12),
              _NameField(controller: _last, label: l10n.authLastNameOptional, autofocus: false, onChanged: (_) => setState(() {})),
              if (_error != null) ...[
                const SizedBox(height: 12),
                Text(_error!, style: TextStyle(color: Theme.of(context).colorScheme.error, fontSize: 13)),
              ],
              const Spacer(),
              if (_saving) const Padding(
                padding: EdgeInsets.only(bottom: 12),
                child: LinearProgressIndicator(minHeight: 2),
              ),
              GradientCtaButton(
                label: _saving ? l10n.authSaving : l10n.authContinue,
                onPressed: (_isValid && !_saving) ? _submit : () {},
              ),
              // Keeps the color right when disabled — hint to the eye.
              if (!_isValid) const SizedBox(height: 4),
            ],
          ),
        ),
      ),
    );
  }
}

class _NameField extends StatelessWidget {
  const _NameField({
    required this.controller,
    required this.label,
    required this.autofocus,
    required this.onChanged,
  });

  final TextEditingController controller;
  final String label;
  final bool autofocus;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF175235), width: 1.5),
      ),
      child: TextField(
        controller: controller,
        autofocus: autofocus,
        textCapitalization: TextCapitalization.words,
        onChanged: onChanged,
        style: GoogleFonts.lexend(fontSize: 17, fontWeight: FontWeight.w500, color: const Color(0xFF1C2B24)),
        decoration: InputDecoration(
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          focusedErrorBorder: InputBorder.none,
          labelText: label,
          labelStyle: GoogleFonts.lexend(fontSize: 13, color: const Color(0xFF5C6B62)),
        ),
      ),
    );
  }
}
