import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'firebase_options.dart';
import 'state/app_launch_provider.dart';
import 'state/firebase_status.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Avoid network font fetches in web preview sandboxes.
  if (kIsWeb) {
    GoogleFonts.config.allowRuntimeFetching = false;
  }

  final prefs = await SharedPreferences.getInstance();

  var firebaseReady = false;
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    firebaseReady = true;
  } catch (_) {
    // Firebase unavailable — app still runs on local mock data.
  }

  runApp(
    ProviderScope(
      overrides: [
        firebaseReadyProvider.overrideWithValue(firebaseReady),
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const FlutterGoApp(),
    ),
  );
}
