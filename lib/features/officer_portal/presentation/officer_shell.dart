/// The rail-navigated shell around the portal proper (5a, 5b, 5d, 5e, 5l).
library;

import 'package:flutter/material.dart';

import 'dashboard/dashboard_screen.dart';
import 'enterprises/enterprise_list_screen.dart';
import 'profile/profile_screen.dart';
import 'reports/reports_screen.dart';
import 'visits/visits_screen.dart';
import 'widgets/officer_nav_rail.dart';

/// Switches between the five rail sections; deeper screens (enterprise
/// detail, data sync, add visit) are pushed or shown as dialogs on top,
/// exactly as in the mocks.
class OfficerShell extends StatefulWidget {
  /// Creates the shell.
  const OfficerShell({super.key, required this.onLoggedOut});

  /// Called once the officer confirms logging out.
  final VoidCallback onLoggedOut;

  @override
  State<OfficerShell> createState() => _OfficerShellState();
}

class _OfficerShellState extends State<OfficerShell> {
  OfficerSection _section = OfficerSection.dashboard;

  void _select(OfficerSection section) => setState(() => _section = section);

  @override
  Widget build(BuildContext context) {
    return switch (_section) {
      OfficerSection.dashboard => DashboardScreen(onSectionSelected: _select),
      OfficerSection.enterprises => EnterpriseListScreen(
        onSectionSelected: _select,
      ),
      OfficerSection.visits => VisitsScreen(onSectionSelected: _select),
      OfficerSection.reports => ReportsScreen(onSectionSelected: _select),
      OfficerSection.profile => ProfileScreen(
        onSectionSelected: _select,
        onLoggedOut: widget.onLoggedOut,
      ),
    };
  }
}
