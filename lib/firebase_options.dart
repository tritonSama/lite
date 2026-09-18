// GENERATED FILE — DO NOT EDIT MANUALLY
//
// Run the FlutterFire CLI to regenerate this file:
//   dart pub global activate flutterfire_cli
//   flutterfire configure
//
// This placeholder will cause a compile error until you run the above command.
// See: https://firebase.flutter.dev/docs/cli

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) throw UnsupportedError('Web not configured.');
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        throw UnsupportedError(
            'DefaultFirebaseOptions not configured for this platform.');
    }
  }

  // ── MOCK FIREBASE CONFIG (REPLACE LATER) ────────────
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'mock-android-api-key',
    appId: '1:1234567890:android:mockappid',
    messagingSenderId: '1234567890',
    projectId: 'mock-firebase-project',
    storageBucket: 'mock-firebase-project.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'mock-ios-api-key',
    appId: '1:1234567890:ios:mockappid',
    messagingSenderId: '1234567890',
    projectId: 'mock-firebase-project',
    storageBucket: 'mock-firebase-project.appspot.com',
    iosBundleId: 'com.heavenlybond.hblite',
  );
}
