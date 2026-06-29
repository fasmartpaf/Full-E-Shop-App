import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'firebase_options.dart';
import 'state/firebase_status.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  var firebaseReady = false;
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    firebaseReady = true;
  } catch (e) {
    debugPrint('Firebase init failed — running in local mode: $e');
  }

  runApp(
    ProviderScope(
      overrides: [firebaseReadyProvider.overrideWithValue(firebaseReady)],
      child: const FlutterGoApp(),
    ),
  );
}