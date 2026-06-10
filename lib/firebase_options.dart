// GENERATED-STYLE TEMPLATE — replace by running: flutterfire configure
//
// This file mirrors the output of the FlutterFire CLI. The placeholder values
// below let the project compile, but you MUST regenerate it against your own
// Firebase project before running on a device:
//
//   1. dart pub global activate flutterfire_cli
//   2. flutterfire configure --project=<your-firebase-project-id>
//
// That command overwrites this file with real API keys and app IDs, and also
// drops android/app/google-services.json and the iOS plist into place.

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
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
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not configured for this platform. '
          'Run `flutterfire configure` to regenerate firebase_options.dart.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBZcz0UgEGT66BKQ9pf1B_cNickEcgclAY',
    appId: '1:207984520716:android:9ff98b2918e57b11834829',
    messagingSenderId: '207984520716',
    projectId: 'quickslot-d9fe6',
    storageBucket: 'quickslot-d9fe6.firebasestorage.app',
  );
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDvAadV-XTUULViCTfp-fb_xoRLZ0tnoy0',
    appId: '1:207984520716:ios:da9d587b31a02566834829',
    messagingSenderId: '207984520716',
    projectId: 'quickslot-d9fe6',
    storageBucket: 'quickslot-d9fe6.firebasestorage.app',
    iosBundleId: 'com.quickslot.quickslot',
  );
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'REPLACE_WITH_WEB_API_KEY',
    appId: 'REPLACE_WITH_WEB_APP_ID',
    messagingSenderId: 'REPLACE_WITH_SENDER_ID',
    projectId: 'REPLACE_WITH_PROJECT_ID',
    authDomain: 'REPLACE_WITH_PROJECT_ID.firebaseapp.com',
    storageBucket: 'REPLACE_WITH_PROJECT_ID.appspot.com',
  );
}
