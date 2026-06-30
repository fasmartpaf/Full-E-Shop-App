import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Survives hot reload so Firebase readiness survives ProviderScope override loss.
bool _firebaseReadyCache = false;

void setFirebaseReadyCache(bool ready) {
  _firebaseReadyCache = ready;
}

/// True when Firebase.initializeApp() succeeded.
/// Everything Firebase-dependent reads this first and falls back to local
/// behaviour when it is false, so the app always runs.
final firebaseReadyProvider = Provider<bool>((_) => _firebaseReadyCache);
