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
        return macos;
      case TargetPlatform.windows:
        return windows;
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
    apiKey: 'AIzaSyBRUa_g02Tvq7r63946qzNufqlMEIhvqYQ',
    appId: '1:521526436063:web:35b326e6f411278837896a',
    messagingSenderId: '521526436063',
    projectId: 'flutterchat-e5565',
    authDomain: 'flutterchat-e5565.firebaseapp.com',
    storageBucket: 'flutterchat-e5565.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBWZ7rHV_N1rqrmCz-eHWQuL_HDzoi9gpE',
    appId: '1:521526436063:android:0e513bb85c8d736037896a',
    messagingSenderId: '521526436063',
    projectId: 'flutterchat-e5565',
    storageBucket: 'flutterchat-e5565.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBDe3YI1jf6eeU2cOM9zSBxuWhCDpWtU0E',
    appId: '1:521526436063:ios:01f5c27c07ff561637896a',
    messagingSenderId: '521526436063',
    projectId: 'flutterchat-e5565',
    storageBucket: 'flutterchat-e5565.appspot.com',
    iosBundleId: 'com.example.flutterChat',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBDe3YI1jf6eeU2cOM9zSBxuWhCDpWtU0E',
    appId: '1:521526436063:ios:01f5c27c07ff561637896a',
    messagingSenderId: '521526436063',
    projectId: 'flutterchat-e5565',
    storageBucket: 'flutterchat-e5565.appspot.com',
    iosBundleId: 'com.example.flutterChat',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBRUa_g02Tvq7r63946qzNufqlMEIhvqYQ',
    appId: '1:521526436063:web:226a3874631c8f6837896a',
    messagingSenderId: '521526436063',
    projectId: 'flutterchat-e5565',
    authDomain: 'flutterchat-e5565.firebaseapp.com',
    storageBucket: 'flutterchat-e5565.appspot.com',
  );

}