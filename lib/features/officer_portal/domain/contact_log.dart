/// An enterprise's visit &amp; call history (Officer Portal 5c).
library;

import 'package:flutter/foundation.dart';

/// Whether a contact-log row was an in-person visit or a phone call.
enum ContactKind {
  /// An in-person visit.
  visit,

  /// A phone call.
  call,
}

/// One row in an enterprise's visit/call history card.
@immutable
class ContactLogEntry {
  /// Creates a history entry.
  const ContactLogEntry({
    required this.date,
    required this.kind,
    required this.note,
  });

  /// When it happened.
  final DateTime date;

  /// Visit or call.
  final ContactKind kind;

  /// What happened, e.g. "verified stock, passbook ✓".
  final String note;
}
