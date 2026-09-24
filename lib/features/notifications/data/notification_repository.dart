import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../auth/presentation/auth_providers.dart';
import '../domain/notification_model.dart';

part 'notification_repository.g.dart';

class NotificationRepository {
  final String userId;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  NotificationRepository({required this.userId});

  CollectionReference<NotificationModel> get _collection => _db
      .collection('users')
      .doc(userId)
      .collection('notifications')
      .withConverter(
        fromFirestore: (snap, _) =>
            NotificationModel.fromJson({...snap.data()!, 'id': snap.id}),
        toFirestore: (notif, _) {
          final json = notif.toJson();
          json.remove('id');
          return json;
        },
      );

  Stream<List<NotificationModel>> watchNotifications() {
    return _collection
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map((d) => d.data()).toList());
  }

  Future<void> markAsRead(String notificationId) async {
    await _collection.doc(notificationId).update({'isRead': true});
  }

  Future<void> markAllAsRead() async {
    final snap = await _collection.where('isRead', isEqualTo: false).get();
    final batch = _db.batch();
    for (final doc in snap.docs) {
      batch.update(doc.reference, {'isRead': true});
    }
    await batch.commit();
  }
}

@riverpod
NotificationRepository? notificationRepository(Ref ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) return null;
  return NotificationRepository(userId: user.uid);
}
