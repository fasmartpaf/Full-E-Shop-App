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
    apiKey: 'AIzaSyCAtIgtEWg615FcvP4VY8tpvCXfUpQSCU8',
    appId: '1:676626617385:web:6e85f38928505f042e7838',
    messagingSenderId: '676626617385',
    projectId: 'ara-store-32144',
    authDomain: 'ara-store-32144.firebaseapp.com',
    storageBucket: 'ara-store-32144.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD06b1R_2AyoZynwm_mDo1dftw8lbTi0E0',
    appId: '1:676626617385:android:ad03df0c6dc006c12e7838',
    messagingSenderId: '676626617385',
    projectId: 'ara-store-32144',
    storageBucket: 'ara-store-32144.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCAtIgtEWg615FcvP4VY8tpvCXfUpQSCU8',
    appId: '1:676626617385:ios:86558d9a7ce2fbb02e7838',
    messagingSenderId: '676626617385',
    projectId: 'ara-store-32144',
    storageBucket: 'ara-store-32144.firebasestorage.app',
    iosBundleId: 'com.opendesign.testingAppBrief',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCAtIgtEWg615FcvP4VY8tpvCXfUpQSCU8',
    appId: '1:676626617385:ios:86558d9a7ce2fbb02e7838',
    messagingSenderId: '676626617385',
    projectId: 'ara-store-32144',
    storageBucket: 'ara-store-32144.firebasestorage.app',
    iosBundleId: 'com.opendesign.testingAppBrief',
  );
}
