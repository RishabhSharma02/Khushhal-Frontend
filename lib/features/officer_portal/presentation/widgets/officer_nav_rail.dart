/// The left icon rail shared by every shell screen (5a, 5b, 5d, 5e, 5l).
library;

import 'package:flutter/material.dart';

import '../../data/officer_demo_data.dart';
import '../theme/officer_palette.dart';
import 'officer_avatar.dart';

/// The four primary destinations plus profile, matching the mocks' rail.
enum OfficerSection { dashboard, enterprises, visits, reports, profile }

/// The solid rail stuck to the left edge of every shell screen — not a
/// floating pill, just a simple full-height strip of symbols.
///
/// Data sync (5f) has no rail icon in the mocks — it's reached only from
/// the dashboard's stale-sync banner — so it isn't a section here.
class OfficerNavRail extends StatelessWidget {
  /// Creates the nav rail.
  const OfficerNavRail({
    super.key,
    required this.current,
    required this.onSelected,
  });

  /// The currently active section.
  final OfficerSection current;

  /// Called when the officer taps a different section.
  final ValueChanged<OfficerSection> onSelected;

  static const List<(OfficerSection, IconData)> _items =
      <(OfficerSection, IconData)>[
        (OfficerSection.dashboard, Icons.grid_view_rounded),
        (OfficerSection.enterprises, Icons.storefront_rounded),
        (OfficerSection.visits, Icons.event_note_rounded),
        (OfficerSection.reports, Icons.bar_chart_rounded),
      ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72,
      color: OfficerPalette.forest,
      child: SafeArea(
        right: false,
        child: Column(
          children: <Widget>[
            const SizedBox(height: 20),
            const OfficerAvatar(
              text: '☘',
              size: 38,
              fontSize: 17,
              background: OfficerPalette.onForest,
              foreground: OfficerPalette.forest,
            ),
            const SizedBox(height: 24),
            for (final (OfficerSection section, IconData icon) in _items)
              _RailIcon(
                icon: icon,
                active: current == section,
                onTap: () => onSelected(section),
              ),
            const Spacer(),
            _RailIcon(
              icon: Icons.settings_rounded,
              active: current == OfficerSection.profile,
              onTap: () => onSelected(OfficerSection.profile),
            ),
            const SizedBox(height: 8),
            OfficerAvatar(
              text: OfficerDemoData.officer.initials,
              size: 34,
              fontSize: 12,
              background: OfficerPalette.onForest,
              foreground: OfficerPalette.forest,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _RailIcon extends StatelessWidget {
  const _RailIcon({
    required this.icon,
    required this.active,
    required this.onTap,
  });

  final IconData icon;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          width: 44,
          height: 44,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: active ? OfficerPalette.forestDark : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(
            icon,
            size: 21,
            color: active
                ? OfficerPalette.onForest
                : OfficerPalette.onForest.withValues(alpha: 0.65),
          ),
        ),
      ),
    );
  }
}
