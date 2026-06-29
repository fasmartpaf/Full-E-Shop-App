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

  void _ensureFirebaseReady() {
    if (!ref.read(firebaseReadyProvider)) {
      throw FirebaseAuthException(
        code: 'firebase-not-ready',
        message: 'Firebase is not connected. Check your internet and try again.',
      );
    }
  }

  Future<void> signIn(String email, String password) async {
    _ensureFirebaseReady();
    final cred = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    final user = cred.user;
    if (user != null) {
      await UserRepository().upsertOnSignIn(user);
    }
  }

  Future<void> register(String name, String email, String password) async {
    _ensureFirebaseReady();
    final cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    await UserRepository().createProfile(cred.user!, name: name);
  }

  Future<void> signOut() async {
    if (!ref.read(firebaseReadyProvider)) return;
    await FirebaseAuth.instance.signOut();
  }

  static String messageFor(Object error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'firebase-not-ready':
          return error.message ?? 'Firebase is not connected';
        case 'weak-password':
          return 'Password is too weak';
        case 'email-already-in-use':
          return 'Email is already in use';
        case 'invalid-email':
          return 'Invalid email address';
        case 'user-not-found':
          return 'No account found for this email';
        case 'wrong-password':
          return 'Wrong password';
        case 'invalid-credential':
        case 'invalid-login-credentials':
          return 'Incorrect email or password';
        case 'operation-not-allowed':
          return 'Email sign-in is not enabled in Firebase Console';
        case 'network-request-failed':
          return 'Network error — check your connection';
        case 'too-many-requests':
          return 'Too many attempts. Please wait and try again';
        default:
          return error.message ?? 'Auth error (${error.code})';
      }
    }
    return 'An error occurred. Please try again';
  }
}
