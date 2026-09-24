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

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'mock-api-key',
    appId: '1:615673989451:web:mock1234567890abcdef',
    messagingSenderId: '615673989451',
    projectId: 'heavenlysent-680ac',
    authDomain: 'heavenlysent-680ac.firebaseapp.com',
    storageBucket: 'heavenlysent-680ac.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBJoLx3brTuHywaAJY5Tc1gnnW0TESaKhM',
    appId: '1:615673989451:android:3990859e07765c9cf2c0ce',
    messagingSenderId: '615673989451',
    projectId: 'heavenlysent-680ac',
    storageBucket: 'heavenlysent-680ac.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBJoLx3brTuHywaAJY5Tc1gnnW0TESaKhM',
    appId: '1:615673989451:ios:mock1234567890abcdef',
    messagingSenderId: '615673989451',
    projectId: 'heavenlysent-680ac',
    storageBucket: 'heavenlysent-680ac.firebasestorage.app',
    iosBundleId: 'com.example.hblite',
  );
}
