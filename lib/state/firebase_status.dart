import 'package:flutter_riverpod/flutter_riverpod.dart';

/// True when Firebase.initializeApp() succeeded. Overridden in main().
/// Everything Firebase-dependent reads this first and falls back to local
/// behaviour when it is false, so the app always runs.
final firebaseReadyProvider = Provider<bool>((_) => false);
