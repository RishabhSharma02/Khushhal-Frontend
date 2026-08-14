/// Standalone entry point for the Officer Portal.
///
/// Run with `flutter run -t lib/officer_portal_main.dart`. Kept separate
/// from the consumer app's `main.dart` since the two serve different
/// personas (field officer vs. business owner) with independent logins.
library;

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'features/officer_portal/presentation/officer_portal_root.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Requires platform Firebase config (google-services.json /
  // GoogleService-Info.plist / web FirebaseOptions, wired via
  // `flutterfire configure`) that isn't in this repo yet — see
  // Khushhal-Backend's officer portal plan. Without it this throws; caught
  // here so the UI still renders (phone/OTP screens show a clear error only
  // once an officer actually tries to sign in) instead of a blank app.
  // Widget tests never call main() so they're unaffected either way.
  try {
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint('Firebase.initializeApp failed (no project configured yet?): $e');
  }
  runApp(const OfficerPortalRoot());
}
