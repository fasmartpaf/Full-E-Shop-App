import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Persists the signed-in user's profile to Firestore at `users/{uid}`.
/// Rules allow each user to read/write only their own document.
class UserRepository {
  DocumentReference<Map<String, dynamic>> _doc(String uid) =>
      FirebaseFirestore.instance.collection('users').doc(uid);

  /// Called right after account creation — writes the full profile.
  Future<void> createProfile(
    User user, {
    required String name,
  }) async {
    await _doc(user.uid).set({
      'uid': user.uid,
      'name': name.trim(),
      'email': user.email,
      'photoUrl': user.photoURL,
      'provider': user.providerData.isNotEmpty
          ? user.providerData.first.providerId
          : 'password',
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  /// Called on sign-in — ensures a profile exists and refreshes basics.
  Future<void> upsertOnSignIn(User user) async {
    await _doc(user.uid).set({
      'uid': user.uid,
      'name': user.displayName ?? '',
      'email': user.email,
      'photoUrl': user.photoURL,
      'lastLoginAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Stream<Map<String, dynamic>?> watch(String uid) =>
      _doc(uid).snapshots().map((s) => s.data());
}
