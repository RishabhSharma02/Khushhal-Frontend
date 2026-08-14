/// The officer's identity card (Officer Portal 5l).
library;

import 'package:flutter/material.dart';

import '../../../domain/officer_profile.dart';
import '../../theme/officer_palette.dart';
import '../../widgets/officer_avatar.dart';
import '../../widgets/officer_buttons.dart';
import '../../widgets/officer_card.dart';
import '../../widgets/status_chip.dart';

/// Avatar, name, role, employee ID (verified), and coverage area.
class ProfileHeaderCard extends StatelessWidget {
  /// Creates the profile header card.
  const ProfileHeaderCard({super.key, required this.officer, required this.onEdit});

  /// The signed-in officer.
  final OfficerProfile officer;

  /// Called when "Edit" is tapped.
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return OfficerCard(
      child: Row(
        children: <Widget>[
          OfficerAvatar(text: officer.initials, size: 64, fontSize: 22),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  officer.fullName,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: OfficerPalette.ink,
                  ),
                ),
                Wrap(
                  spacing: 6,
                  runSpacing: 2,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: <Widget>[
                    Text(
                      'Field Officer · ${officer.employeeId}',
                      style: const TextStyle(
                        fontSize: 12.5,
                        color: OfficerPalette.body,
                      ),
                    ),
                    if (officer.employeeIdVerified)
                      const StatusChip(
                        label: '✓ verified',
                        tone: OfficerTone.green,
                        dense: true,
                      ),
                  ],
                ),
                Text(
                  '${officer.block} block, ${officer.state} · Pincode: ${officer.pincode}',
                  style: const TextStyle(
                    fontSize: 12.5,
                    color: OfficerPalette.body,
                  ),
                ),
              ],
            ),
          ),
          OfficerSecondaryButton(label: '✎ Edit', onPressed: onEdit),
        ],
      ),
    );
  }
}
