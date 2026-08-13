/// The "N enterprises haven't synced" notice (Officer Portal 5a).
library;

import 'package:flutter/material.dart';

import '../../theme/officer_palette.dart';

/// A soft banner linking through to the Data sync screen.
class StaleSyncBanner extends StatelessWidget {
  /// Creates the stale-sync banner.
  const StaleSyncBanner({
    super.key,
    required this.staleCount,
    required this.onSeeList,
  });

  /// How many enterprises are stale.
  final int staleCount;

  /// Called when "See list" is tapped.
  final VoidCallback onSeeList;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: OfficerPalette.soft,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: <Widget>[
          const Text('📡', style: TextStyle(fontSize: 14)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              '$staleCount enterprises haven’t synced in 7+ days — scores use last-known data.',
              style: const TextStyle(
                fontSize: 12.5,
                color: OfficerPalette.body,
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onSeeList,
            child: const Text(
              'See list →',
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                color: OfficerPalette.forest,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
