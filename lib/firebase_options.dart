// GENERATED PLACEHOLDER — REPLACE via `flutterfire configure`.
//
// This file is a stand-in so the project compiles before Firebase is wired
// to a real project. Once you have created the Firebase project and enabled
// Phone Authentication, run:
//
//   dart pub global activate flutterfire_cli
//   flutterfire configure --project=<your-firebase-project-id>
//
// which will overwrite this file with the actual `DefaultFirebaseOptions`
// for the platforms you support.
//
// Until then, calling `Firebase.initializeApp()` with these options will
// throw at runtime. The app entrypoint tolerates that in debug mode and
// falls back to the X-Debug-Firebase-Uid dev shim against the backend.

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return _placeholder;
    return _placeholder;
  }

  // Values below come from Android google-services.json (project khushhal-dd5f6).
  // They're good enough to let Firebase.initializeApp succeed on every
  // platform, but for a real production iOS build you should also register
  // an iOS app in the Firebase console and drop the resulting
  // GoogleService-Info.plist into ios/Runner/. Running `flutterfire configure`
  // will regenerate this file with per-platform options.
  static const FirebaseOptions _placeholder = FirebaseOptions(
    apiKey: 'AIzaSyBy36ZYeeypdwXo59G-QI6mcWjyzaiNTFg',
    appId: '1:906569730039:android:3468c5a59916b11a8d10f2',
    messagingSenderId: '906569730039',
    projectId: 'khushhal-dd5f6',
    storageBucket: 'khushhal-dd5f6.firebasestorage.app',
  );
}
