// File generated for FlowForge Firebase configuration with environment security.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with FlowForge Firebase backend.
///
/// Credentials are read securely from compile-time environment variables.
/// Pass `--dart-define-from-file=.env` when running or building:
/// ```bash
/// flutter run --dart-define-from-file=.env
/// flutter build web --dart-define-from-file=.env
/// ```
class DefaultFirebaseOptions {
  // Generic fallback API key
  static const String _defaultApiKey = String.fromEnvironment(
    'API',
    defaultValue: String.fromEnvironment('FIREBASE_API_KEY'),
  );

  // Platform-specific API Keys
  static const String _webApiKey = String.fromEnvironment(
    'FIREBASE_WEB_API_KEY',
    defaultValue: _defaultApiKey,
  );
  static const String _androidApiKey = String.fromEnvironment(
    'FIREBASE_ANDROID_API_KEY',
    defaultValue: _defaultApiKey,
  );
  static const String _iosApiKey = String.fromEnvironment(
    'FIREBASE_IOS_API_KEY',
    defaultValue: _defaultApiKey,
  );
  static const String _macosApiKey = String.fromEnvironment(
    'FIREBASE_MACOS_API_KEY',
    defaultValue: _defaultApiKey,
  );
  static const String _windowsApiKey = String.fromEnvironment(
    'FIREBASE_WINDOWS_API_KEY',
    defaultValue: _defaultApiKey,
  );

  // App IDs
  static const String _webAppId = String.fromEnvironment('FIREBASE_WEB_APP_ID');
  static const String _androidAppId = String.fromEnvironment('FIREBASE_ANDROID_APP_ID');
  static const String _iosAppId = String.fromEnvironment('FIREBASE_IOS_APP_ID');
  static const String _macosAppId = String.fromEnvironment('FIREBASE_MACOS_APP_ID', defaultValue: _iosAppId);
  static const String _windowsAppId = String.fromEnvironment('FIREBASE_WINDOWS_APP_ID');

  // Project Info
  static const String _projectId = String.fromEnvironment('FIREBASE_PROJECT_ID');
  static const String _messagingSenderId = String.fromEnvironment('FIREBASE_MESSAGING_SENDER_ID');
  static const String _storageBucket = String.fromEnvironment('FIREBASE_STORAGE_BUCKET');
  static const String _authDomain = String.fromEnvironment('FIREBASE_AUTH_DOMAIN');
  static const String _webMeasurementId = String.fromEnvironment('FIREBASE_WEB_MEASUREMENT_ID');
  static const String _windowsMeasurementId = String.fromEnvironment('FIREBASE_WINDOWS_MEASUREMENT_ID');

  static FirebaseOptions get currentPlatform {
    final FirebaseOptions options;
    if (kIsWeb) {
      options = web;
    } else {
      switch (defaultTargetPlatform) {
        case TargetPlatform.android:
          options = android;
          break;
        case TargetPlatform.iOS:
          options = ios;
          break;
        case TargetPlatform.macOS:
          options = macos;
          break;
        case TargetPlatform.windows:
          options = windows;
          break;
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

    if (options.apiKey.isEmpty) {
      throw StateError(
        'Missing Firebase credentials! Please run Flutter with --dart-define-from-file=.env '
        'or set the appropriate FIREBASE_*_API_KEY / API environment variable.',
      );
    }

    return options;
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: _webApiKey,
    appId: _webAppId,
    messagingSenderId: _messagingSenderId,
    projectId: _projectId,
    authDomain: _authDomain,
    storageBucket: _storageBucket,
    measurementId: _webMeasurementId,
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: _androidApiKey,
    appId: _androidAppId,
    messagingSenderId: _messagingSenderId,
    projectId: _projectId,
    storageBucket: _storageBucket,
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: _iosApiKey,
    appId: _iosAppId,
    messagingSenderId: _messagingSenderId,
    projectId: _projectId,
    storageBucket: _storageBucket,
    iosBundleId: 'com.example.sprintFlow',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: _macosApiKey,
    appId: _macosAppId,
    messagingSenderId: _messagingSenderId,
    projectId: _projectId,
    storageBucket: _storageBucket,
    iosBundleId: 'com.example.sprintFlow',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: _windowsApiKey,
    appId: _windowsAppId,
    messagingSenderId: _messagingSenderId,
    projectId: _projectId,
    authDomain: _authDomain,
    storageBucket: _storageBucket,
    measurementId: _windowsMeasurementId,
  );
}
