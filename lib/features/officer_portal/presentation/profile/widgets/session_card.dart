/// The current-session card with the "Log out" entry point (Officer
/// Portal 5l).
library;

import 'package:flutter/material.dart';

import '../../../domain/officer_profile.dart';
import '../../theme/officer_palette.dart';
import '../../widgets/officer_buttons.dart';
import '../../widgets/officer_card.dart';

/// Shows when the current session started and offers to log out.
class SessionCard extends StatelessWidget {
  /// Creates the session card.
  const SessionCard({super.key, required this.officer, required this.onLogOut});

  /// The signed-in officer.
  final OfficerProfile officer;

  /// Called when "Log out" is tapped.
  final VoidCallback onLogOut;

  @override
  Widget build(BuildContext context) {
    final DateTime? since = officer.signedInSince;

    return OfficerCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Row(
            children: <Widget>[
              Icon(
                Icons.devices_rounded,
                size: 17,
                color: OfficerPalette.forest,
              ),
              SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Session',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: OfficerPalette.ink,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            since == null
                ? 'Signed in on ${officer.deviceLabel}'
                : 'Signed in since ${_time(since)} · ${officer.deviceLabel}',
            style: const TextStyle(fontSize: 12.5, color: OfficerPalette.body),
          ),
          const Text(
            'Other sessions: none',
            style: TextStyle(fontSize: 12.5, color: OfficerPalette.body),
          ),
          const SizedBox(height: 12),
          OfficerSecondaryButton(
            label: 'Log out ▸',
            expand: false,
            onPressed: onLogOut,
          ),
        ],
      ),
    );
  }

  static String _time(DateTime date) {
    final int hour12 = date.hour % 12 == 0 ? 12 : date.hour % 12;
    final String minute = date.minute.toString().padLeft(2, '0');
    final String period = date.hour >= 12 ? 'pm' : 'am';
    return '$hour12:$minute $period';
  }
}
