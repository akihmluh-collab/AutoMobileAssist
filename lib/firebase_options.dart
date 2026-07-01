// ignore_for_file: type=lint
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
    apiKey: 'AIzaSyA5K0GjxMzQzg8sgSVfcNDbW40mEO9a8fI',
    appId: '1:366049864476:web:7b23e1f293a6ad9eaba8d9',
    messagingSenderId: '366049864476',
    projectId: 'auto-mobile-assist',
    authDomain: 'auto-mobile-assist.firebaseapp.com',
    storageBucket: 'auto-mobile-assist.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA5K0GjxMzQzg8sgSVfcNDbW40mEO9a8fI',
    appId: '1:366049864476:android:7b23e1f293a6ad9eaba8d9',
    messagingSenderId: '366049864476',
    projectId: 'auto-mobile-assist',
    storageBucket: 'auto-mobile-assist.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA5K0GjxMzQzg8sgSVfcNDbW40mEO9a8fI',
    appId: '1:366049864476:ios:7b23e1f293a6ad9eaba8d9',
    messagingSenderId: '366049864476',
    projectId: 'auto-mobile-assist',
    storageBucket: 'auto-mobile-assist.firebasestorage.app',
    iosClientId: '366049864476-pg20cibrgnvv4jefl5q658n66ojt7lsq.apps.googleusercontent.com',
    iosBundleId: 'com.autoassist.auto_mobile_assist',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyA5K0GjxMzQzg8sgSVfcNDbW40mEO9a8fI',
    appId: '1:366049864476:ios:7b23e1f293a6ad9eaba8d9',
    messagingSenderId: '366049864476',
    projectId: 'auto-mobile-assist',
    storageBucket: 'auto-mobile-assist.firebasestorage.app',
    iosClientId: '366049864476-pg20cibrgnvv4jefl5q658n66ojt7lsq.apps.googleusercontent.com',
    iosBundleId: 'com.autoassist.auto_mobile_assist',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyA5K0GjxMzQzg8sgSVfcNDbW40mEO9a8fI',
    appId: '1:366049864476:web:7b23e1f293a6ad9eaba8d9',
    messagingSenderId: '366049864476',
    projectId: 'auto-mobile-assist',
    authDomain: 'auto-mobile-assist.firebaseapp.com',
    storageBucket: 'auto-mobile-assist.firebasestorage.app',
  );
}