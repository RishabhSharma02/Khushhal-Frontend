/// The "Change password" modal, opened from Account details' Password row
/// (Officer Portal 5l). Re-authenticates with the current password (Firebase
/// requires a recent sign-in for this), then updates it — no backend call
/// involved, the password lives entirely in Firebase.
library;

import 'package:flutter/material.dart';

import '../../officer_session.dart';
import '../../theme/officer_palette.dart';
import '../../widgets/labeled_field.dart';
import '../../widgets/officer_buttons.dart';
import '../../widgets/officer_card.dart';

/// Opens the Change-password dialog.
Future<void> showChangePasswordDialog({required BuildContext context}) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) => const _ChangePasswordDialog(),
  );
}

class _ChangePasswordDialog extends StatefulWidget {
  const _ChangePasswordDialog();

  @override
  State<_ChangePasswordDialog> createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<_ChangePasswordDialog> {
  final TextEditingController _current = TextEditingController();
  final TextEditingController _newPassword = TextEditingController();
  final TextEditingController _confirm = TextEditingController();
  bool _obscure = true;
  bool _submitting = false;
  String? _error;

  @override
  void dispose() {
    _current.dispose();
    _newPassword.dispose();
    _confirm.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_current.text.isEmpty || _newPassword.text.isEmpty) {
      setState(() => _error = 'Fill in your current and new password.');
      return;
    }
    if (_newPassword.text.length < 8) {
      setState(() => _error = 'New password must be at least 8 characters.');
      return;
    }
    if (_newPassword.text != _confirm.text) {
      setState(() => _error = 'New password and confirmation don’t match.');
      return;
    }

    setState(() {
      _submitting = true;
      _error = null;
    });

    try {
      await OfficerSessionScope.of(context).profileRepository?.changePassword(
        currentPassword: _current.text,
        newPassword: _newPassword.text,
      );
      if (!mounted) return;
      Navigator.of(context).pop();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Password changed.')));
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _submitting = false;
        _error = '$e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 380),
        child: OfficerCard(
          padding: const EdgeInsets.all(22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                children: <Widget>[
                  const Expanded(
                    child: Text(
                      'Change password',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: OfficerPalette.ink,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, size: 18),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              LabeledField(
                label: 'CURRENT PASSWORD',
                controller: _current,
                obscureText: _obscure,
              ),
              const SizedBox(height: 12),
              LabeledField(
                label: 'NEW PASSWORD',
                controller: _newPassword,
                obscureText: _obscure,
              ),
              const SizedBox(height: 12),
              LabeledField(
                label: 'CONFIRM NEW PASSWORD',
                controller: _confirm,
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
              if (_error != null) ...<Widget>[
                const SizedBox(height: 10),
                Text(
                  _error!,
                  style: const TextStyle(fontSize: 12, color: OfficerPalette.statusRed),
                ),
              ],
              const SizedBox(height: 16),
              OfficerPrimaryButton(
                label: _submitting ? 'Saving…' : 'Save password ✓',
                onPressed: _submitting ? null : _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
