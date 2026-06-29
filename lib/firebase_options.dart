import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
    apiKey: 'AIzaSyDummyKeyForWebPlatform',
    appId: '1:123456789:web:abcdef1234567890',
    messagingSenderId: '123456789',
    projectId: 'testing-app-project',
    authDomain: 'testing-app-project.firebaseapp.com',
    databaseURL: 'https://testing-app-project.firebaseio.com',
    storageBucket: 'testing-app-project.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDummyKeyForAndroid',
    appId: '1:123456789:android:abcdef1234567890',
    messagingSenderId: '123456789',
    projectId: 'testing-app-project',
    databaseURL: 'https://testing-app-project.firebaseio.com',
    storageBucket: 'testing-app-project.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDummyKeyForIOS',
    appId: '1:123456789:ios:abcdef1234567890',
    messagingSenderId: '123456789',
    projectId: 'testing-app-project',
    databaseURL: 'https://testing-app-project.firebaseio.com',
    storageBucket: 'testing-app-project.appspot.com',
    iosBundleId: 'com.open-design.testing-app-brief',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDummyKeyForMacOS',
    appId: '1:123456789:macos:abcdef1234567890',
    messagingSenderId: '123456789',
    projectId: 'testing-app-project',
    databaseURL: 'https://testing-app-project.firebaseio.com',
    storageBucket: 'testing-app-project.appspot.com',
    iosBundleId: 'com.open-design.testing-app-brief',
  );
}
