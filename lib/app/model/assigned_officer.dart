/// The field officer linked to a consumer's business.
///
/// A very small view of the officer — enough for the home card, the
/// alert-plan "Talk to officer" button and future SMS/WhatsApp handoff.
library;

import 'package:flutter/foundation.dart';

/// A field officer assigned to one owner-side business.
@immutable
class AssignedOfficer {
  /// Creates an assigned-officer record.
  const AssignedOfficer({
    required this.officerId,
    required this.name,
    required this.email,
    required this.mobile,
  });

  /// The department/employee identifier — e.g. "UP-SIT-0482".
  final String officerId;

  /// Officer's full name.
  final String name;

  /// Officer's contact email.
  final String email;

  /// Officer's contact mobile in E.164, e.g. "+917987956779". The "Talk to
  /// field officer" button dials this.
  final String mobile;
}

