/// Sets a password — sign-up's step 2, and the tail of the reset flow
/// (Officer Portal 5j).
library;

import 'package:flutter/material.dart';

import '../theme/officer_palette.dart';
import '../widgets/labeled_field.dart';
import '../widgets/officer_buttons.dart';
import 'widgets/auth_scaffold.dart';

/// Which journey landed the officer on this screen — only the copy differs.
enum SetPasswordMode {
  /// Step 2 of sign-up.
  signup,

  /// Tail of "forgot password".
  reset,
}

/// The password + confirm form shared by sign-up and password reset.
class SetPasswordScreen extends StatefulWidget {
  /// Creates the set-password screen.
  const SetPasswordScreen({
    super.key,
    required this.mode,
    required this.email,
    required this.onSubmit,
  });

  /// Which journey this screen is serving.
  final SetPasswordMode mode;

  /// The email the new password is for.
  final String email;

  /// Called once the officer confirms the new password.
  final VoidCallback onSubmit;

  @override
  State<SetPasswordScreen> createState() => _SetPasswordScreenState();
}

class _SetPasswordScreenState extends State<SetPasswordScreen> {
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirm = TextEditingController();
  bool _obscure = true;

  @override
  void initState() {
    super.initState();
    _password.addListener(() => setState(() {}));
    _confirm.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  bool get _hasMinLength => _password.text.length >= 8;
  bool get _hasNumber => _password.text.contains(RegExp('[0-9]'));
  bool get _hasSymbol =>
      _password.text.contains(RegExp(r'[^a-zA-Z0-9]'));

  int get _metCount =>
      (_hasMinLength ? 1 : 0) + (_hasNumber ? 1 : 0) + (_hasSymbol ? 1 : 0);

  String get _strengthLabel {
    if (_password.text.isEmpty) return 'Strength: —';
    return switch (_metCount) {
      0 || 1 => 'Strength: weak',
      2 => 'Strength: good',
      _ => 'Strength: strong',
    };
  }

  bool get _confirmMatches =>
      _confirm.text.isNotEmpty && _confirm.text == _password.text;

  bool get _canSubmit =>
      _hasMinLength && _hasNumber && _confirmMatches;

  @override
  Widget build(BuildContext context) {
    final bool isSignup = widget.mode == SetPasswordMode.signup;

    return AuthScaffold(
      title: isSignup ? 'Set your password' : 'Set a new password',
      subtitle: isSignup
          ? 'Step 2 of 2 · for ${widget.email}'
          : 'For ${widget.email}',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          LabeledField(
            label: 'NEW PASSWORD',
            controller: _password,
            obscureText: _obscure,
            trailing: IconButton(
              padding: EdgeInsets.zero,
              iconSize: 18,
              color: OfficerPalette.muted,
              icon: Icon(
                _obscure
                    ? Icons.visibility_rounded
                    : Icons.visibility_off_rounded,
              ),
              onPressed: () => setState(() => _obscure = !_obscure),
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: <Widget>[
              for (int i = 0; i < 4; i++) ...<Widget>[
                if (i != 0) const SizedBox(width: 4),
                Expanded(
                  child: _StrengthBar(
                    filled:
                        i <
                        (_password.text.isEmpty ? 0 : 1 + _metCount).clamp(
                          0,
                          4,
                        ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 4),
          Text(
            _strengthLabel,
            style: const TextStyle(fontSize: 10.5, color: OfficerPalette.muted),
          ),
          const SizedBox(height: 14),
          LabeledField(
            label: 'CONFIRM PASSWORD',
            controller: _confirm,
            obscureText: _obscure,
            trailing: _confirm.text.isEmpty
                ? null
                : Icon(
                    _confirmMatches ? Icons.check_rounded : Icons.close_rounded,
                    size: 18,
                    color: _confirmMatches
                        ? OfficerPalette.statusGreen
                        : OfficerPalette.statusRed,
                  ),
          ),
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: OfficerPalette.soft,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _Requirement(
                  label: 'At least 8 characters',
                  met: _hasMinLength,
                ),
                const SizedBox(height: 4),
                _Requirement(label: 'One number', met: _hasNumber),
                const SizedBox(height: 4),
                _Requirement(
                  label: 'One symbol (recommended)',
                  met: _hasSymbol,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          OfficerPrimaryButton(
            label: isSignup ? 'Create account ✓' : 'Save password ✓',
            onPressed: _canSubmit ? widget.onSubmit : null,
          ),
        ],
      ),
    );
  }
}

class _StrengthBar extends StatelessWidget {
  const _StrengthBar({required this.filled});

  final bool filled;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 5,
      decoration: BoxDecoration(
        color: filled ? OfficerPalette.statusGreen : OfficerPalette.soft,
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}

class _Requirement extends StatelessWidget {
  const _Requirement({required this.label, required this.met});

  final String label;
  final bool met;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Text(
          met ? '✓' : '○',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: met ? OfficerPalette.forest : OfficerPalette.muted,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: met ? FontWeight.w700 : FontWeight.w400,
            color: met ? OfficerPalette.forest : OfficerPalette.body,
          ),
        ),
      ],
    );
  }
}
