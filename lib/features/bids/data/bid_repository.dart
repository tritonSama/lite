import 'dart:convert';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/offer.dart';
import '../../../core/services/local_database_service.dart';

part 'bid_repository.g.dart';

@riverpod
BidRepository bidRepository(Ref ref) => BidRepository();

class BidRepository {
  final _dbService = LocalDatabaseService.instance;

  Future<void> createOffer(Offer offer) async {
    final db = await _dbService.database;

    // Convert GeoPoint and Timestamp manually if needed, but since we are saving
    // directly to SQLite as JSON, our Freezed generated toJson() might need
    // to bypass the Firebase Converters. For now, we will assume standard JSON.
    final Map<String, dynamic> jsonData = offer.toJson();

    // Strip non-primitive values from JSON if there are any Firebase-specific
    // serializers. Since this is local, we store it as a pure string map.
    await db.insert('bids', {
      'id': offer.id,
      'taskId': offer.taskId,
      'providerId': offer.providerId,
      'data': jsonEncode(jsonData),
      'createdAt': DateTime.now().millisecondsSinceEpoch,
    });
  }

  Future<List<Offer>> getOffersForTask(String taskId) async {
    final db = await _dbService.database;

    final maps = await db.query(
      'bids',
      where: 'taskId = ?',
      whereArgs: [taskId],
      orderBy: 'createdAt DESC',
    );

    return maps.map((m) {
      final dataMap = jsonDecode(m['data'] as String) as Map<String, dynamic>;
      return Offer.fromJson(dataMap);
    }).toList();
  }

  Future<List<Offer>> getOffersByProvider(String providerId) async {
    final db = await _dbService.database;

    final maps = await db.query(
      'bids',
      where: 'providerId = ?',
      whereArgs: [providerId],
      orderBy: 'createdAt DESC',
    );

    return maps.map((m) {
      final dataMap = jsonDecode(m['data'] as String) as Map<String, dynamic>;
      return Offer.fromJson(dataMap);
    }).toList();
  }
}
