/// Shown when "Plan route" is tapped — route planning isn't built yet, but
/// logging a visit already is (Officer Portal 5a).
library;

import 'package:flutter/material.dart';

import '../../theme/officer_palette.dart';
import '../../visits/widgets/add_visit_dialog.dart';
import '../../widgets/officer_buttons.dart';
import '../../widgets/officer_card.dart';

/// Opens the "Plan route — coming soon" dialog.
Future<void> showPlanRouteComingSoonDialog({required BuildContext context}) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) => const _PlanRouteComingSoonDialog(),
  );
}

class _PlanRouteComingSoonDialog extends StatelessWidget {
  const _PlanRouteComingSoonDialog();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 360),
        child: OfficerCard(
          padding: const EdgeInsets.all(22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  const Expanded(
                    child: Text(
                      'Route planning — coming soon 🗺',
                      style: TextStyle(
                        fontSize: 16,
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
              const SizedBox(height: 8),
              const Text(
                "We haven't built automatic route planning yet. For now, "
                'you can log a visit directly — no route needed.',
                style: TextStyle(
                  fontSize: 13,
                  height: 1.4,
                  color: OfficerPalette.body,
                ),
              ),
              const SizedBox(height: 18),
              OfficerPrimaryButton(
                label: '+ Log a visit',
                onPressed: () {
                  Navigator.of(context).pop();
                  showAddVisitDialog(context: context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
