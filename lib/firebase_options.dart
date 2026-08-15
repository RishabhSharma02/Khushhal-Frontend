// Project: khushhal-dd5f6. Android and Web apps are registered with real
// credentials below. No iOS app is registered yet, so iOS falls back to the
// Android values (good enough for Firebase.initializeApp to succeed, but a
// real iOS build needs its own registered app + GoogleService-Info.plist).
// Regenerate with `flutterfire configure --project=khushhal-dd5f6` if that
// changes.

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;
    return android;
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyARuVnrFaOhJyy63soccx7p8YLu6ZlN0GY',
    appId: '1:906569730039:web:112b0c9d5bec94cc8d10f2',
    messagingSenderId: '906569730039',
    projectId: 'khushhal-dd5f6',
    authDomain: 'khushhal-dd5f6.firebaseapp.com',
    storageBucket: 'khushhal-dd5f6.firebasestorage.app',
    measurementId: 'G-E3QK21HSNR',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBy36ZYeeypdwXo59G-QI6mcWjyzaiNTFg',
    appId: '1:906569730039:android:3468c5a59916b11a8d10f2',
    messagingSenderId: '906569730039',
    projectId: 'khushhal-dd5f6',
    storageBucket: 'khushhal-dd5f6.firebasestorage.app',
  );
}
