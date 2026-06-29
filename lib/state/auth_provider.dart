import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/user_repository.dart';
import 'firebase_status.dart';

final currentUserProvider = StreamProvider<User?>((ref) {
  if (!ref.watch(firebaseReadyProvider)) {
    return Stream<User?>.value(null);
  }
  return FirebaseAuth.instance.authStateChanges();
});

final userProfileProvider =
    StreamProvider.autoDispose<Map<String, dynamic>?>((ref) {
  final user = ref.watch(currentUserProvider).value;
  if (!ref.watch(firebaseReadyProvider) || user == null) {
    return Stream<Map<String, dynamic>?>.value(null);
  }
  return UserRepository().watch(user.uid);
});

final authControllerProvider = Provider<AuthController>(
  (ref) => AuthController(ref),
);

class AuthController {
  AuthController(this.ref);

  final Ref ref;

  Future<void> signIn(String email, String password) async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> register(String name, String email, String password) async {
    final cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    await UserRepository().createProfile(cred.user!, name: name);
  }

  Future<void> signOut() => FirebaseAuth.instance.signOut();

  static String messageFor(Object error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'weak-password':
          return 'Password is too weak';
        case 'email-already-in-use':
          return 'Email is already in use';
        case 'invalid-email':
          return 'Invalid email address';
        case 'user-not-found':
          return 'User not found';
        case 'wrong-password':
          return 'Wrong password';
        default:
          return error.message ?? 'Auth error';
      }
    }
    return 'An error occurred';
  }
}
