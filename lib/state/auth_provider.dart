/// The signed-in user's Firestore profile document (`users/{uid}`).
final userProfileProvider =
    StreamProvider.autoDispose<Map<String, dynamic>?>((ref) {
  final user = ref.watch(currentUserProvider);
  if (!ref.watch(firebaseReadyProvider) || user == null) {
    return Stream<Map<String, dynamic>?>.value(null);
  }
  return UserRepository().watch(user.uid);
});

final authControllerProvider =
    Provider<AuthController>((ref) => AuthController(ref));