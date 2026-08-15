/// Standalone entry point for the Officer Portal.
///
/// Run with `flutter run -t lib/officer_portal_main.dart`. Kept separate
/// from the consumer app's `main.dart` since the two serve different
/// personas (field officer vs. business owner) with independent logins.
library;

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'features/officer_portal/presentation/officer_portal_root.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('hi');
  await initializeDateFormatting('en');
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint(
      'Firebase.initializeApp failed (no project configured yet?): $e',
    );
  }
  runApp(const OfficerPortalRoot());
}
