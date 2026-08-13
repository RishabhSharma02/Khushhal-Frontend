/// The visit &amp; call history card (Officer Portal 5c).
library;

import 'package:flutter/material.dart';

import '../../../domain/contact_log.dart';
import '../../theme/officer_palette.dart';
import '../../widgets/officer_buttons.dart';
import '../../widgets/officer_card.dart';

/// A short, newest-first log of visits and calls.
class ContactHistoryCard extends StatefulWidget {
  /// Creates the contact history card.
  const ContactHistoryCard({
    super.key,
    required this.entries,
    required this.onAddNote,
  });

  /// The log entries, newest first.
  final List<ContactLogEntry> entries;

  /// Called when "+ Add note" is tapped.
  final VoidCallback onAddNote;

  /// How many entries show before "View all" is needed.
  static const int previewCount = 3;

  @override
  State<ContactHistoryCard> createState() => _ContactHistoryCardState();
}

class _ContactHistoryCardState extends State<ContactHistoryCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final List<ContactLogEntry> entries = widget.entries;
    final bool canCollapse = entries.length > ContactHistoryCard.previewCount;
    final List<ContactLogEntry> shown = _expanded || !canCollapse
        ? entries
        : entries.take(ContactHistoryCard.previewCount).toList();

    return OfficerCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Row(
            children: <Widget>[
              Icon(
                Icons.history_rounded,
                size: 17,
                color: OfficerPalette.forest,
              ),
              SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Visit & call history',
                  style: TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w800,
                    color: OfficerPalette.ink,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          for (final ContactLogEntry entry in shown)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Icon(
                    entry.kind == ContactKind.visit
                        ? Icons.event_note_rounded
                        : Icons.call_rounded,
                    size: 13,
                    color: OfficerPalette.muted,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text.rich(
                      TextSpan(
                        children: <InlineSpan>[
                          TextSpan(
                            text: _date(entry.date),
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              color: OfficerPalette.ink,
                            ),
                          ),
                          TextSpan(
                            text:
                                ' · ${entry.kind == ContactKind.visit ? 'Visit' : 'Call'} — ${entry.note}',
                          ),
                        ],
                      ),
                      style: const TextStyle(
                        fontSize: 12,
                        color: OfficerPalette.body,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          if (canCollapse)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: InkWell(
                onTap: () => setState(() => _expanded = !_expanded),
                borderRadius: BorderRadius.circular(8),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      _expanded ? 'Show less' : 'View all ${entries.length}',
                      style: const TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        color: OfficerPalette.forest,
                      ),
                    ),
                    Icon(
                      _expanded
                          ? Icons.keyboard_arrow_up_rounded
                          : Icons.keyboard_arrow_down_rounded,
                      size: 16,
                      color: OfficerPalette.forest,
                    ),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 8),
          OfficerSecondaryButton(
            label: '+ Add note',
            onPressed: widget.onAddNote,
          ),
        ],
      ),
    );
  }

  static String _date(DateTime date) {
    const List<String> months = <String>[
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${date.day.toString().padLeft(2, '0')} ${months[date.month - 1]}';
  }
}
