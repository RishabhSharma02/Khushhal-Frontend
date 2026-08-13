/// The "Edit profile" modal, opened from the profile header's Edit button
/// (Officer Portal 5l).
library;

import 'package:flutter/material.dart';

import '../../officer_session.dart';
import '../../theme/officer_palette.dart';
import '../../widgets/labeled_field.dart';
import '../../widgets/officer_buttons.dart';
import '../../widgets/officer_card.dart';

/// Opens the Edit-profile dialog.
Future<void> showEditProfileDialog({required BuildContext context}) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) => const _EditProfileDialog(),
  );
}

class _EditProfileDialog extends StatefulWidget {
  const _EditProfileDialog();

  @override
  State<_EditProfileDialog> createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends State<_EditProfileDialog> {
  late final TextEditingController _fullName;
  late final TextEditingController _mobile;

  @override
  void initState() {
    super.initState();
    final OfficerSession session = OfficerSessionScope.of(context);
    _fullName = TextEditingController(text: session.profile.fullName);
    _mobile = TextEditingController(text: session.profile.mobile);
  }

  @override
  void dispose() {
    _fullName.dispose();
    _mobile.dispose();
    super.dispose();
  }

  void _submit() {
    if (_fullName.text.trim().isEmpty || _mobile.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Name and mobile can’t be empty.')),
      );
      return;
    }

    OfficerSessionScope.of(context).updateProfile(
      fullName: _fullName.text.trim(),
      mobile: _mobile.text.trim(),
    );

    Navigator.of(context).pop();
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
                  const Text(
                    'Edit profile',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: OfficerPalette.ink,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, size: 18),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              LabeledField(label: 'FULL NAME', controller: _fullName),
              const SizedBox(height: 12),
              LabeledField(
                label: 'MOBILE',
                controller: _mobile,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              OfficerPrimaryButton(label: 'Save changes ✓', onPressed: _submit),
            ],
          ),
        ),
      ),
    );
  }
}
