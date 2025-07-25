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
    apiKey: 'AIzaSyBcRNy1ENo7Va3734gYHHcG2_KPzAizpN4',
    appId: '1:551003132497:web:423e0f5447717f98899e70',
    messagingSenderId: '551003132497',
    projectId: 'autoescola-sistema-86ed8',
    authDomain: 'autoescola-sistema-86ed8.firebaseapp.com',
    storageBucket: 'autoescola-sistema-86ed8.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBQl87n87ykVd-uS3NGkay5HPP8beA0vPM',
    appId: '1:551003132497:android:4670f27f9c07c855899e70',
    messagingSenderId: '551003132497',
    projectId: 'autoescola-sistema-86ed8',
    storageBucket: 'autoescola-sistema-86ed8.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBYBPA3VXw4oSxIYKnD1efH4tiErEVffLI',
    appId: '1:551003132497:ios:49abe8843c183678899e70',
    messagingSenderId: '551003132497',
    projectId: 'autoescola-sistema-86ed8',
    storageBucket: 'autoescola-sistema-86ed8.firebasestorage.app',
    iosBundleId: 'com.example.escolaConducao',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBYBPA3VXw4oSxIYKnD1efH4tiErEVffLI',
    appId:
        '1:551003132497:ios:49abe8843c183678899e70', // Reutiliza o App ID do iOS para macOS
    messagingSenderId: '551003132497',
    projectId: 'autoescola-sistema-86ed8',
    storageBucket: 'autoescola-sistema-86ed8.firebasestorage.app',
    iosBundleId:
        'com.example.escolaConducao', // Reutiliza o Bundle ID do iOS para macOS
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey:
        'AIzaSyB-vM7E6Y2S2R8X1N1Q0P9L7K6J5H4G3F2E1D', // Exemplo: Substituir pela sua chave real
    appId:
        '1:551003132497:web:xxxxxxxxxxxxxxxxxxxxxxxx', // Exemplo: Substituir pelo seu App ID real
    messagingSenderId: '551003132497',
    projectId: 'autoescola-sistema-86ed8',
    authDomain: 'autoescola-sistema-86ed8.firebaseapp.com',
    storageBucket: 'autoescola-sistema-86ed8.firebasestorage.app',
  );
}
