/// The sync-status chip pinned to the top-right of the main screens.
library;

import 'package:flutter/material.dart';

import '../../app/session.dart';
import '../../l10n/app_localizations.dart';
import '../theme/theme.dart';

/// Shows the network state and opens the sync screen (1w) on tap.
///
/// Synced and syncing are calm green; offline turns amber with a dashed
/// border — a first-class state, never styled as an error.
class SyncChip extends StatelessWidget {
  /// Creates the chip for [status].
  const SyncChip({super.key, required this.status, this.onTap});

  /// Network state to show.
  final ConnectivityStatus status;

  /// Usually a push of the sync screen (1w).
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final bool offline = status == ConnectivityStatus.offline;

    final String label = switch (status) {
      ConnectivityStatus.synced => l10n.chipSynced,
      ConnectivityStatus.syncing => l10n.chipSyncing,
      ConnectivityStatus.offline => l10n.chipOffline,
    };

    return Material(
      color: offline ? const Color(0xFFFBF6E3) : AppPalette.mintChip,
      shape: StadiumBorder(
        side: offline
            ? const BorderSide(color: Color(0xFFD9C88F), width: 1.5)
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: onTap,
        customBorder: const StadiumBorder(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (status == ConnectivityStatus.synced) ...<Widget>[
                const Icon(Icons.check, size: 13, color: AppPalette.leaf),
                const SizedBox(width: 4),
              ],
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: offline ? const Color(0xFF8A6D00) : AppPalette.leaf,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
