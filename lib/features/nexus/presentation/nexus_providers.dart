import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/nexus_waitlist_entry.dart';
import '../data/nexus_waitlist_repository.dart';
import '../../auth/presentation/auth_providers.dart';

part 'nexus_providers.g.dart';

@riverpod
class NexusWaitlistController extends _$NexusWaitlistController {
  @override
  FutureOr<void> build() {}

  Future<void> joinWaitlist(String name, String email) async {
    final user = ref.read(authStateProvider).value;
    if (user == null) {
      throw Exception('Must be logged in to join waitlist');
    }

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final entry = NexusWaitlistEntry(
        userId: user.uid,
        name: name,
        email: email,
        joinedAt: DateTime.now(),
      );

      final repo = ref.read(nexusWaitlistRepositoryProvider);
      await repo.joinWaitlist(entry);

      // Invalidate the check provider so the UI updates
      ref.invalidate(isUserOnWaitlistProvider);
    });
  }
}
