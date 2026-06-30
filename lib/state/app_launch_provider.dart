import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const onboardingCompleteKey = 'onboarding_complete';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences must be overridden in main.dart');
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
