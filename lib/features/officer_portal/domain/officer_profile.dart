/// The signed-in officer's own details (Officer Portal 5h–5m, 5l).
library;

import 'package:flutter/foundation.dart';

/// The officer's coverage stats, shown on the Profile screen (5l).
@immutable
class OfficerCoverage {
  /// Creates a coverage summary.
  const OfficerCoverage({
    required this.enterpriseCount,
    required this.villageCount,
    required this.visitsThisMonth,
    required this.flagsResolvedLast30Days,
  });

  /// Enterprises on this officer's beat.
  final int enterpriseCount;

  /// Distinct villages covered.
  final int villageCount;

  /// Visits completed this month.
  final int visitsThisMonth;

  /// Flags resolved in the last 30 days.
  final int flagsResolvedLast30Days;
}

/// A signed-in field officer.
@immutable
class OfficerProfile {
  /// Creates an officer profile.
  const OfficerProfile({
    required this.fullName,
    required this.employeeId,
    required this.employeeIdVerified,
    required this.pincode,
    required this.block,
    required this.state,
    required this.email,
    required this.mobile,
    this.signedInSince,
    this.deviceLabel = 'this device',
  });

  /// Officer's full name.
  final String fullName;

  /// Department employee ID, e.g. "UP-SIT-0482".
  final String employeeId;

  /// Whether the employee ID was checked against the department register.
  final bool employeeIdVerified;

  /// Posting-area pincode, entered at signup.
  final String pincode;

  /// Block derived from the pincode.
  final String block;

  /// State derived from the pincode.
  final String state;

  /// Login email.
  final String email;

  /// Contact mobile number — not used for sign-in (that's email/password),
  /// so it's optional; an officer can add it later via profile edit.
  final String? mobile;

  /// When the current session started; `null` before login.
  final DateTime? signedInSince;

  /// Human label for the current device/browser.
  final String deviceLabel;

  /// Two-letter-ish initials for the avatar, e.g. "RV".
  String get initials {
    final List<String> parts = fullName.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) {
      return '';
    }
    final String first = parts.first.isNotEmpty ? parts.first[0] : '';
    final String last = parts.length > 1 && parts.last.isNotEmpty
        ? parts.last[0]
        : '';
    return (first + last).toUpperCase();
  }

  /// A copy with [signedInSince] set, used right after login.
  OfficerProfile withSignedInSince(DateTime time) {
    return OfficerProfile(
      fullName: fullName,
      employeeId: employeeId,
      employeeIdVerified: employeeIdVerified,
      pincode: pincode,
      block: block,
      state: state,
      email: email,
      mobile: mobile,
      signedInSince: time,
      deviceLabel: deviceLabel,
    );
  }
}
