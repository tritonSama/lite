import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/notification_model.dart';
import '../data/notification_repository.dart';

part 'notifications_providers.g.dart';

@riverpod
Stream<List<NotificationModel>> userNotifications(Ref ref) {
  try {
    final repo = ref.watch(notificationRepositoryProvider);
    if (repo == null) return Stream.value([]);
    return repo.watchNotifications().handleError((e, s) {
      return <NotificationModel>[];
    });
  } catch (e) {
    return Stream.value([]);
  }
}
