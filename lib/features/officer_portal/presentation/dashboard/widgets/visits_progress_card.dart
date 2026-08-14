/// The "visits this week" donut card (Officer Portal 5a).
library;

import 'package:flutter/material.dart';

import '../../../domain/visit.dart';
import '../../theme/officer_palette.dart';
import '../../widgets/officer_buttons.dart';
import '../../widgets/officer_card.dart';

/// Completed-of-planned donut plus the next visit's summary.
class VisitsProgressCard extends StatelessWidget {
  /// Creates the visits progress card.
  const VisitsProgressCard({
    super.key,
    required this.nextVisit,
    required this.visitsDoneThisWeek,
    required this.visitsPlannedThisWeek,
    required this.onPlanRoute,
  });

  /// The next visit to surface, if any.
  final Visit? nextVisit;

  /// Visits completed this week.
  final int visitsDoneThisWeek;

  /// Visits planned this week.
  final int visitsPlannedThisWeek;

  /// Called when "Plan route" is tapped.
  final VoidCallback onPlanRoute;

  @override
  Widget build(BuildContext context) {
    final int done = visitsDoneThisWeek;
    final int planned = visitsPlannedThisWeek;

    return OfficerCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Row(
            children: <Widget>[
              Icon(
                Icons.event_available_rounded,
                size: 17,
                color: OfficerPalette.forest,
              ),
              SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Visits this week',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: OfficerPalette.ink,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          const Text(
            'Completed of planned',
            style: TextStyle(fontSize: 11, color: OfficerPalette.muted),
          ),
          const SizedBox(height: 14),
          Center(
            child: SizedBox(
              width: 130,
              height: 130,
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  CustomPaint(
                    size: const Size(130, 130),
                    painter: _DonutPainter(planned == 0 ? 0.0 : done / planned),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text.rich(
                        TextSpan(
                          children: <InlineSpan>[
                            TextSpan(
                              text: '$done',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                color: OfficerPalette.ink,
                              ),
                            ),
                            TextSpan(
                              text: '/$planned done',
                              style: const TextStyle(
                                fontSize: 14,
                                color: OfficerPalette.muted,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: nextVisit == null
                ? const Text(
                    'No more visits planned this week',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11.5,
                      color: OfficerPalette.muted,
                    ),
                  )
                : Column(
                    children: <Widget>[
                      Text(
                        'Next: ${nextVisit!.enterpriseName}',
                        style: const TextStyle(
                          fontSize: 11.5,
                          color: OfficerPalette.muted,
                        ),
                      ),
                      Text(
                        _time(nextVisit!.date),
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          color: OfficerPalette.ink,
                        ),
                      ),
                    ],
                  ),
          ),
          const SizedBox(height: 12),
          OfficerSecondaryButton(
            label: 'Plan route 🗺',
            expand: true,
            onPressed: onPlanRoute,
          ),
        ],
      ),
    );
  }

  static String _time(DateTime date) {
    const List<String> weekdays = <String>[
      'Mon',
      'Tue',
      'Wed',
      'Thu',
      'Fri',
      'Sat',
      'Sun',
    ];
    final int hour12 = date.hour % 12 == 0 ? 12 : date.hour % 12;
    final String minute = date.minute.toString().padLeft(2, '0');
    final String period = date.hour >= 12 ? 'pm' : 'am';
    return '${weekdays[date.weekday - 1]} $hour12:$minute $period';
  }
}

class _DonutPainter extends CustomPainter {
  _DonutPainter(this.fraction);

  final double fraction;

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = Offset(size.width / 2, size.height / 2);
    final double radius = size.width / 2;
    const double strokeWidth = 15;

    canvas.drawCircle(
      center,
      radius - strokeWidth / 2,
      Paint()
        ..color = OfficerPalette.recordedOut
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth,
    );

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
      -1.5708,
      6.2832 * fraction.clamp(0, 1),
      false,
      Paint()
        ..color = OfficerPalette.forest
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant _DonutPainter oldDelegate) =>
      oldDelegate.fraction != fraction;
}
