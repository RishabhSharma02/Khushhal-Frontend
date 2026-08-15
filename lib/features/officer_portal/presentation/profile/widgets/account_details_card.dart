/// Email, mobile, password, language rows (Officer Portal 5l).
library;

import 'package:flutter/material.dart';

import '../../../domain/officer_profile.dart';
import '../../theme/officer_palette.dart';
import '../../widgets/officer_card.dart';
import 'change_password_dialog.dart';
import 'edit_profile_dialog.dart';

/// A read-only rundown of the officer's account, with a "change" link on
/// the rows that can actually be edited.
class AccountDetailsCard extends StatelessWidget {
  /// Creates the account details card.
  const AccountDetailsCard({super.key, required this.officer});

  /// The signed-in officer.
  final OfficerProfile officer;

  @override
  Widget build(BuildContext context) {
    return OfficerCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Row(
            children: <Widget>[
              Icon(
                Icons.badge_outlined,
                size: 17,
                color: OfficerPalette.forest,
              ),
              SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Account details',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: OfficerPalette.ink,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _Row(label: 'Email', value: officer.email),
          _Row(
            label: 'Mobile',
            value: officer.mobile ?? 'Not provided',
            onChange: () => showEditProfileDialog(context: context),
          ),
          _Row(
            label: 'Password',
            value: '••••••••',
            onChange: () => showChangePasswordDialog(context: context),
          ),
          _Row(label: 'Language', value: 'English · हिंदी ▾', divider: false),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({
    required this.label,
    required this.value,
    this.onChange,
    this.divider = true,
  });

  final String label;
  final String value;

  /// Shown as a "change" link when non-null; omitted entirely otherwise
  /// (Email/Language have nothing wired up to change yet).
  final VoidCallback? onChange;
  final bool divider;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        border: divider
            ? const Border(bottom: BorderSide(color: OfficerPalette.line))
            : null,
      ),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 68,
            child: Text(
              label,
              style: const TextStyle(fontSize: 12.5, color: OfficerPalette.body),
            ),
          ),
          Expanded(
            child: Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                color: OfficerPalette.ink,
              ),
            ),
          ),
          if (onChange != null) ...<Widget>[
            const SizedBox(width: 6),
            GestureDetector(
              onTap: onChange,
              child: const Text(
                'change',
                style: TextStyle(fontSize: 12.5, color: OfficerPalette.forest),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
