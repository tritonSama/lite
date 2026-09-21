import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../shared/models/user_profile.dart';

part 'auth_providers.g.dart';

@riverpod
Stream<User?> authState(Ref ref) =>
    FirebaseAuth.instance.authStateChanges();

@riverpod
User? currentUser(Ref ref) =>
    ref.watch(authStateProvider).value;

// ── Auth actions notifier ─────────────────────────────────────────────────────
@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  Future<void> _createUserDocumentIfNeeded(User user, String? displayName) async {
    final doc = FirebaseFirestore.instance.collection('users').doc(user.uid);
    final snapshot = await doc.get();

    if (!snapshot.exists) {
      final profile = UserProfile(
        uid: user.uid,
        displayName: displayName ?? user.displayName ?? 'New User',
        photoUrl: user.photoURL,
        createdAt: DateTime.now(),
      );
      await doc.set(profile.toJson());
    }
  }

  Future<void> signInWithGoogle() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        throw Exception('Google sign in aborted');
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final cred = await FirebaseAuth.instance.signInWithCredential(credential);

      if (cred.user != null) {
        await _createUserDocumentIfNeeded(cred.user!, null);
      }
    });
  }

  Future<void> signInWithEmail(String email, String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password),
    );
  }

  Future<void> signUpWithEmail({
    required String email,
    required String password,
    required String displayName,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final cred = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      await cred.user?.updateDisplayName(displayName);

      if (cred.user != null) {
        await _createUserDocumentIfNeeded(cred.user!, displayName);
      }
    });
  }

  Future<void> signOut() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(FirebaseAuth.instance.signOut);
  }
}
