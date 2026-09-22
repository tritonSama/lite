import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/local_database_service.dart';

final localOfferingsProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final dbService = LocalDatabaseService.instance;
  final db = await dbService.database;
  final results = await db.query('tasks', orderBy: 'createdAt DESC');
  return results.map((e) => Map<String, dynamic>.from(e)).toList();
});
