import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const onboardingCompleteKey = 'onboarding_complete';

/// Survives hot reload so prefs stay available when ProviderScope overrides reset.
SharedPreferences? _sharedPreferencesCache;

Future<SharedPreferences> bootstrapSharedPreferences() async {
  return _sharedPreferencesCache ??= await SharedPreferences.getInstance();
}

void setSharedPreferencesCache(SharedPreferences prefs) {
  _sharedPreferencesCache = prefs;
}

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  final cached = _sharedPreferencesCache;
  if (cached != null) return cached;
  throw UnimplementedError(
    'SharedPreferences not ready. Call bootstrapSharedPreferences() in main().',
  );
});

/// Whether the user has finished onboarding. Backed by SharedPreferences.
final onboardingCompleteProvider = Provider<bool>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return prefs.getBool(onboardingCompleteKey) ?? false;
});

class OnboardingController {
  OnboardingController(this._prefs);

  final SharedPreferences _prefs;

  Future<void> complete() async {
    await _prefs.setBool(onboardingCompleteKey, true);
  }

  Future<void> reset() async {
    await _prefs.remove(onboardingCompleteKey);
  }
}

final onboardingControllerProvider = Provider<OnboardingController>((ref) {
  return OnboardingController(ref.watch(sharedPreferencesProvider));
});
