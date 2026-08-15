/// Standalone entry point for the Officer Portal.
///
/// Run with `flutter run -t lib/officer_portal_main.dart`. Kept separate
/// from the consumer app's `main.dart` since the two serve different
/// personas (field officer vs. business owner) with independent logins.
library;

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'features/officer_portal/presentation/officer_portal_root.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Web requires FirebaseOptions to be passed explicitly (unlike
  // Android/iOS, which read native config files automatically) — omitting
  // it throws immediately and leaves no default app for FirebaseAuth calls
  // to attach to. Caught here so the UI still renders even before a real
  // Firebase project is wired in via `flutterfire configure`; widget tests
  // never call main() so they're unaffected either way.
  try {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  } catch (e) {
    debugPrint('Firebase.initializeApp failed (no project configured yet?): $e');
  }
  runApp(const OfficerPortalRoot());
}
