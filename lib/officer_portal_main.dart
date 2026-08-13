/// Standalone entry point for the Officer Portal.
///
/// Run with `flutter run -t lib/officer_portal_main.dart`. Kept separate
/// from the consumer app's `main.dart` since the two serve different
/// personas (field officer vs. business owner) with independent logins.
library;

import 'package:flutter/material.dart';

import 'features/officer_portal/presentation/officer_portal_root.dart';

void main() {
  runApp(const OfficerPortalRoot());
}
