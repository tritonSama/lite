import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_providers.g.dart';

@riverpod
Stream<User?> authState(Ref ref) => FirebaseAuth.instance.authStateChanges();

@riverpod
User? currentUser(Ref ref) => ref.watch(authStateProvider).value;

// ── Auth actions notifier ─────────────────────────────────────────────────────
@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  Future<void> signInWithEmail(String email, String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      ),
    );
  }

  Future<void> signUpWithEmail({
    required String email,
    required String password,
    required String displayName,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await cred.user?.updateDisplayName(displayName);

      // Create Firestore user document
      if (cred.user != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(cred.user!.uid)
            .set({
              'id': cred.user!.uid,
              'email': email,
              'displayName': displayName,
              'createdAt': FieldValue.serverTimestamp(),
              'reputation': 0,
            });
      }
    });
  }

  Future<void> signOut() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(FirebaseAuth.instance.signOut);
  }
}
