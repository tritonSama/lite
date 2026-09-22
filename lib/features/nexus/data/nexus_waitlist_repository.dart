import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/nexus_waitlist_entry.dart';
import '../../auth/presentation/auth_providers.dart';

part 'nexus_waitlist_repository.g.dart';

class NexusWaitlistRepository {
  final FirebaseFirestore _firestore;

  NexusWaitlistRepository(this._firestore);

  CollectionReference<NexusWaitlistEntry> get _waitlistRef => _firestore
      .collection('nexus_waitlist')
      .withConverter<NexusWaitlistEntry>(
        fromFirestore: (snapshot, _) =>
            NexusWaitlistEntry.fromJson(snapshot.data()!),
        toFirestore: (entry, _) => entry.toJson(),
      );

  Future<void> joinWaitlist(NexusWaitlistEntry entry) async {
    await _waitlistRef.doc(entry.userId).set(entry);
  }

  Future<bool> isOnWaitlist(String userId) async {
    final doc = await _waitlistRef.doc(userId).get();
    return doc.exists;
  }
}

@riverpod
NexusWaitlistRepository nexusWaitlistRepository(Ref ref) {
  return NexusWaitlistRepository(FirebaseFirestore.instance);
}

@riverpod
Future<bool> isUserOnWaitlist(Ref ref) async {
  final user = ref.watch(authStateProvider).value;
  if (user == null) return false;

  final repo = ref.watch(nexusWaitlistRepositoryProvider);
  return repo.isOnWaitlist(user.uid);
}
