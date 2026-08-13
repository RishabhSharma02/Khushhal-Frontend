/// One row on the Visits week list (Officer Portal 5d).
library;

import 'package:flutter/material.dart';

import '../../../domain/visit.dart';
import '../../theme/officer_palette.dart';
import '../../widgets/officer_avatar.dart';
import '../../widgets/officer_card.dart';
import '../../widgets/status_chip.dart';

/// A single planned/completed visit — done rows are greyed, the next one
/// outlined, upcoming ones plain.
class VisitListCard extends StatelessWidget {
  /// Creates a visit row.
  const VisitListCard({
    super.key,
    required this.visit,
    required this.orderInWeek,
  });

  /// The visit to show.
  final Visit visit;

  /// 1-based position among non-done visits, shown as the leading number.
  final int orderInWeek;

  @override
  Widget build(BuildContext context) {
    final bool done = visit.status == VisitStatus.done;
    final bool next = visit.status == VisitStatus.next;

    return OfficerCard(
      outlined: next,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      child: Row(
        children: <Widget>[
          OfficerAvatar(
            text: done ? '✓' : '$orderInWeek',
            size: 34,
            fontSize: 13,
            background: done
                ? OfficerPalette.recordedOut
                : OfficerPalette.forest,
            foreground: done ? OfficerPalette.body : OfficerPalette.onForest,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text.rich(
                  TextSpan(
                    children: <InlineSpan>[
                      TextSpan(
                        text: visit.enterpriseName,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: OfficerPalette.ink,
                        ),
                      ),
                      TextSpan(text: ' · ${visit.village} · '),
                      TextSpan(
                        text: _dateTime(visit.date),
                        style: const TextStyle(color: OfficerPalette.muted),
                      ),
                    ],
                  ),
                  style: const TextStyle(fontSize: 12.5),
                ),
                const SizedBox(height: 2),
                Text(
                  visit.agenda,
                  style: const TextStyle(
                    fontSize: 11.5,
                    color: OfficerPalette.body,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (visit.riskLevel != null)
                StatusChip(
                  label: '● ${visit.riskLevel!.label}',
                  tone: visit.riskLevel!.tone,
                ),
              if (visit.distanceKm != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    '${visit.distanceKm!.toStringAsFixed(0)} km',
                    style: const TextStyle(
                      fontSize: 11,
                      color: OfficerPalette.muted,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  static String _dateTime(DateTime date) {
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
    return '${weekdays[date.weekday - 1]} ${date.day}, $hour12:$minute $period';
  }
}
