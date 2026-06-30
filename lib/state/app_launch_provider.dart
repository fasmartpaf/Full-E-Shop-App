import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _onboardingKey = 'onboarding_complete';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences must be overridden in main.dart');
});

final onboardingCompleteProvider = FutureProvider<bool>((ref) async {
  final prefs = ref.watch(sharedPreferencesProvider);
  return prefs.getBool(_onboardingKey) ?? false;
});

class OnboardingController {
  OnboardingController(this._prefs);

  final SharedPreferences _prefs;

  Future<void> complete() async {
    await _prefs.setBool(_onboardingKey, true);
  }

  Future<void> reset() async {
    await _prefs.remove(_onboardingKey);
  }
}

final onboardingControllerProvider = Provider<OnboardingController>((ref) {
  return OnboardingController(ref.watch(sharedPreferencesProvider));
});
