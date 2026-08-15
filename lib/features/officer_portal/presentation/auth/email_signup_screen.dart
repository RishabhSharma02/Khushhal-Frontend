/// New officer sign-up via Firebase email/password + backend registration.
library;

import 'package:flutter/material.dart';

import '../../data/officer_api_client.dart';
import '../../data/officer_auth_repository.dart';
import '../../domain/officer_profile.dart';
import '../theme/officer_palette.dart';
import '../widgets/labeled_field.dart';
import '../widgets/officer_buttons.dart';
import 'widgets/auth_scaffold.dart';

/// Collects officer details + a password, creates the Firebase account, and
/// registers the matching `officers` row on the backend — all in one step.
class EmailSignupScreen extends StatefulWidget {
  /// Creates the sign-up screen.
  const EmailSignupScreen({
    super.key,
    required this.authRepository,
    required this.onAuthenticated,
    required this.onSignIn,
  });

  final OfficerAuthRepository authRepository;

  /// Called once the account is created and registered, with the profile.
  final void Function(OfficerProfile profile) onAuthenticated;

  /// Called when "Sign in" is tapped instead.
  final VoidCallback onSignIn;

  @override
  State<EmailSignupScreen> createState() => _EmailSignupScreenState();
}

class _EmailSignupScreenState extends State<EmailSignupScreen> {
  final TextEditingController _fullName = TextEditingController();
  final TextEditingController _employeeId = TextEditingController();
  final TextEditingController _mobile = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirm = TextEditingController();
  bool _obscure = true;
  bool _submitting = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _password.addListener(() => setState(() {}));
    _confirm.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _fullName.dispose();
    _employeeId.dispose();
    _mobile.dispose();
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  bool get _hasMinLength => _password.text.length >= 8;
  bool get _hasNumber => _password.text.contains(RegExp('[0-9]'));
  bool get _hasSymbol => _password.text.contains(RegExp(r'[^a-zA-Z0-9]'));
  int get _metCount => (_hasMinLength ? 1 : 0) + (_hasNumber ? 1 : 0) + (_hasSymbol ? 1 : 0);

  String get _strengthLabel {
    if (_password.text.isEmpty) return 'Strength: —';
    return switch (_metCount) {
      0 || 1 => 'Strength: weak',
      2 => 'Strength: good',
      _ => 'Strength: strong',
    };
  }

  bool get _confirmMatches => _confirm.text.isNotEmpty && _confirm.text == _password.text;
  bool get _passwordOk => _hasMinLength && _hasNumber && _confirmMatches;

  Future<void> _submit() async {
    if (_fullName.text.trim().isEmpty ||
        _employeeId.text.trim().isEmpty ||
        _email.text.trim().isEmpty) {
      setState(() => _error = 'Fill in your name, employee ID and email first');
      return;
    }
    if (!_passwordOk) {
      setState(() => _error = 'Check the password requirements below');
      return;
    }

    setState(() {
      _submitting = true;
      _error = null;
    });

    try {
      final OfficerProfile profile = await widget.authRepository.register(
        email: _email.text.trim(),
        password: _password.text,
        employeeId: _employeeId.text.trim(),
        fullName: _fullName.text.trim(),
        mobile: _mobile.text.trim().isEmpty ? null : _mobile.text.trim(),
      );
      if (!mounted) return;
      widget.onAuthenticated(profile);
    } on Exception catch (e) {
      if (!mounted) return;
      setState(() => _error = e is OfficerApiException ? e.message : 'Could not create the account');
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      title: 'Create new account',
      subtitle: 'Your details, then a password',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          LabeledField(label: 'FULL NAME', controller: _fullName),
          const SizedBox(height: 14),
          LabeledField(label: 'EMPLOYEE ID', controller: _employeeId),
          const SizedBox(height: 14),
          LabeledField(
            label: 'MOBILE (OPTIONAL)',
            controller: _mobile,
            keyboardType: TextInputType.phone,
            hintText: '+91XXXXXXXXXX — can add later',
          ),
          const SizedBox(height: 14),
          LabeledField(
            label: 'EMAIL',
            controller: _email,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 14),
          LabeledField(
            label: 'PASSWORD',
            controller: _password,
            obscureText: _obscure,
            trailing: IconButton(
              padding: EdgeInsets.zero,
              iconSize: 18,
              color: OfficerPalette.muted,
              icon: Icon(
                _obscure ? Icons.visibility_rounded : Icons.visibility_off_rounded,
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
                    filled: i < (_password.text.isEmpty ? 0 : 1 + _metCount).clamp(0, 4),
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
                    color: _confirmMatches ? OfficerPalette.statusGreen : OfficerPalette.statusRed,
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
                _Requirement(label: 'At least 8 characters', met: _hasMinLength),
                const SizedBox(height: 4),
                _Requirement(label: 'One number', met: _hasNumber),
                const SizedBox(height: 4),
                _Requirement(label: 'One symbol (recommended)', met: _hasSymbol),
              ],
            ),
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
            label: _submitting ? 'Creating…' : 'Create account ✓',
            onPressed: _submitting ? null : _submit,
          ),
          const SizedBox(height: 14),
          Center(
            child: Wrap(
              alignment: WrapAlignment.center,
              children: <Widget>[
                const Text(
                  'Already have an account? ',
                  style: TextStyle(fontSize: 12.5, color: OfficerPalette.muted),
                ),
                GestureDetector(
                  onTap: widget.onSignIn,
                  child: const Text(
                    'Sign in',
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                      color: OfficerPalette.forest,
                    ),
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
