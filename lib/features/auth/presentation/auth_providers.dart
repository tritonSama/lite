import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

      final user = cred.user;
      if (user != null) {
        await user.updateDisplayName(displayName);

        // Persist UserProfile to Firestore
        final userProfile = UserProfile(
          uid: user.uid,
          displayName: displayName,
          createdAt: DateTime.now(),
        );

        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .set(userProfile.toJson());
      }
    });
  }

  Future<void> signOut() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(FirebaseAuth.instance.signOut);
  }
}
