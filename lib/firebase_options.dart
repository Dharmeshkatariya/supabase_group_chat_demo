// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
    apiKey: 'AIzaSyDY9f-KSrPAImAp-nMaYeE-P5eKoTnS7Mg',
    appId: '1:993994292711:web:0202a50ab5873bbace9142',
    messagingSenderId: '993994292711',
    projectId: 'custom-widget-e85c3',
    authDomain: 'custom-widget-e85c3.firebaseapp.com',
    storageBucket: 'custom-widget-e85c3.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDpNxE041FQTVJ191xp4tIrMsXIPE38gIA',
    appId: '1:993994292711:android:c2cc6c75c52cecf7ce9142',
    messagingSenderId: '993994292711',
    projectId: 'custom-widget-e85c3',
    storageBucket: 'custom-widget-e85c3.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDlLlqAgEGhK2wI4m-Sei1OmyF4Iwli48w',
    appId: '1:993994292711:ios:0f4cfae6720400fdce9142',
    messagingSenderId: '993994292711',
    projectId: 'custom-widget-e85c3',
    storageBucket: 'custom-widget-e85c3.appspot.com',
    androidClientId:
        '993994292711-emfg0k7vn4idfq5plc5jivlrq7b7agmq.apps.googleusercontent.com',
    iosClientId:
        '993994292711-2mpjed1r9joeg894ij6miu8t7574dkjg.apps.googleusercontent.com',
    iosBundleId: 'com.example.supabaseAppDemo',
  );
}
