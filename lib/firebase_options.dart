// File generated for SprintFlow Firebase configuration.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with SprintFlow Firebase backend.
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
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCUhq7P5Mt4-aJmN5tMSo9pxyMzJJxGf88',
    appId: '1:1074995737633:web:4861940cf12eca0ef55f60',
    messagingSenderId: '1074995737633',
    projectId: 'flowforge-a21d8',
    authDomain: 'flowforge-a21d8.firebaseapp.com',
    storageBucket: 'flowforge-a21d8.firebasestorage.app',
    measurementId: 'G-F459XSL574',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAEaj5xt7jzzrLdRy84awEfe7lTRw1Sz2k',
    appId: '1:1074995737633:android:3a66b34bb8fda3a6f55f60',
    messagingSenderId: '1074995737633',
    projectId: 'flowforge-a21d8',
    storageBucket: 'flowforge-a21d8.firebasestorage.app',
  );
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBleUIL_4PfTQE8-qlKd7Aj0D3BwBYCOjY',
    appId: '1:1074995737633:ios:397c3749e20f7f71f55f60',
    messagingSenderId: '1074995737633',
    projectId: 'flowforge-a21d8',
    storageBucket: 'flowforge-a21d8.firebasestorage.app',
    iosBundleId: 'com.example.sprintFlow',
  );
  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBleUIL_4PfTQE8-qlKd7Aj0D3BwBYCOjY',
    appId: '1:1074995737633:ios:397c3749e20f7f71f55f60',
    messagingSenderId: '1074995737633',
    projectId: 'flowforge-a21d8',
    storageBucket: 'flowforge-a21d8.firebasestorage.app',
    iosBundleId: 'com.example.sprintFlow',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCUhq7P5Mt4-aJmN5tMSo9pxyMzJJxGf88',
    appId: '1:1074995737633:web:51f67ff48e178675f55f60',
    messagingSenderId: '1074995737633',
    projectId: 'flowforge-a21d8',
    authDomain: 'flowforge-a21d8.firebaseapp.com',
    storageBucket: 'flowforge-a21d8.firebasestorage.app',
    measurementId: 'G-8WGYG447QG',
  );
}
