/// The officer's visit log (Officer Portal 5d).
library;

import 'package:flutter/material.dart';

import '../../domain/visit.dart';
import '../officer_session.dart';
import '../theme/officer_palette.dart';
import '../widgets/officer_buttons.dart';
import '../widgets/officer_nav_rail.dart';
import '../widgets/officer_shell_scaffold.dart';
import '../widgets/responsive_header.dart';
import 'widgets/add_visit_dialog.dart';
import 'widgets/visit_list_card.dart';

/// A log of visits that have actually happened — not a scheduler. Officers
/// log a visit (with its outcome status) once it's done; there's nothing
/// here to plan ahead of time.
class VisitsScreen extends StatelessWidget {
  /// Creates the visits screen.
  const VisitsScreen({super.key, required this.onSectionSelected});

  /// Called when a rail section is tapped.
  final ValueChanged<OfficerSection> onSectionSelected;

  @override
  Widget build(BuildContext context) {
    final OfficerSession session = OfficerSessionScope.of(context);
    final List<Visit> logged =
        session.visits.where((Visit v) => v.status == VisitStatus.done).toList()
          ..sort((Visit a, Visit b) => b.date.compareTo(a.date));

    return OfficerShellScaffold(
      section: OfficerSection.visits,
      onSectionSelected: onSectionSelected,
      children: <Widget>[
        ResponsiveHeader(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text(
                'Visits',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: OfficerPalette.ink,
                ),
              ),
              Text(
                '${logged.length} visit${logged.length == 1 ? '' : 's'} logged',
                style: const TextStyle(fontSize: 13, color: OfficerPalette.muted),
              ),
            ],
          ),
          actions: <Widget>[
            OfficerPrimaryButton(
              label: '+ Log visit',
              expand: false,
              onPressed: () => showAddVisitDialog(context: context),
            ),
          ],
        ),
        for (final Visit visit in logged)
          VisitListCard(visit: visit, orderInWeek: 0),
        if (logged.isEmpty)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            decoration: BoxDecoration(
              color: OfficerPalette.soft,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Text(
              'No visits logged yet. Once you finish a visit, log it here with '
              'its outcome status.',
              style: TextStyle(fontSize: 12, color: OfficerPalette.body),
            ),
          ),
      ],
    );
  }
}
