import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/local_database_service.dart';
import '../domain/offer.dart';

final offerRepositoryProvider = Provider<OfferRepository>((ref) {
  return OfferRepository(LocalDatabaseService.instance);
});

class OfferRepository {
  final LocalDatabaseService _dbService;

  OfferRepository(this._dbService);

  Future<void> placeOffer(Offer offer) async {
    final db = await _dbService.database;
    // ensure DateTime string is persisted
    final jsonMap = offer.toJson();
    jsonMap['createdAt'] = offer.createdAt.toIso8601String();

    final jsonStr = jsonEncode(jsonMap);
    await db.insert('bids', {
      'id': offer.id,
      'taskId': offer.taskId,
      'providerId': offer.providerId,
      'data': jsonStr,
      'createdAt': offer.createdAt.millisecondsSinceEpoch,
    });
  }

  Future<List<Offer>> getOffersForTask(String taskId) async {
    final db = await _dbService.database;
    final results = await db.query(
      'bids',
      where: 'taskId = ?',
      whereArgs: [taskId],
      orderBy: 'createdAt DESC',
    );

    return results.map((row) {
      final dataStr = row['data'] as String;
      final Map<String, dynamic> json = jsonDecode(dataStr);
      // Ensure createdAt is parsed properly if it was stored as a string map value
      if (json['createdAt'] is String) {
        json['createdAt'] = DateTime.parse(json['createdAt'] as String).toIso8601String();
      }
      return Offer.fromJson(json);
    }).toList();
  }

  Future<List<Offer>> getOffersByProvider(String providerId) async {
    final db = await _dbService.database;
    final results = await db.query(
      'bids',
      where: 'providerId = ?',
      whereArgs: [providerId],
      orderBy: 'createdAt DESC',
    );

    return results.map((row) {
      final dataStr = row['data'] as String;
      final Map<String, dynamic> json = jsonDecode(dataStr);
      // Ensure createdAt is parsed properly if it was stored as a string map value
      if (json['createdAt'] is String) {
        json['createdAt'] = DateTime.parse(json['createdAt'] as String).toIso8601String();
      }
      return Offer.fromJson(json);
    }).toList();
  }
}
