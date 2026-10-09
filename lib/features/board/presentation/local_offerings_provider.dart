import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/local_database_service.dart';

final localOfferingsNotifierProvider =
    NotifierProvider<LocalOfferingsNotifier, List<Map<String, dynamic>>>(
        () => LocalOfferingsNotifier());

class LocalOfferingsNotifier extends Notifier<List<Map<String, dynamic>>> {
  @override
  List<Map<String, dynamic>> build() {
    loadOfferings();
    return [];
  }

  Future<void> loadOfferings() async {
    final dbService = LocalDatabaseService.instance;
    final db = await dbService.database;

    List<Map<String, dynamic>> rows =
        await db.query('tasks', orderBy: 'createdAt DESC');

    if (rows.isEmpty) {
      // Seed initial tasks
      final seeds = [
        {
          'id': 'seed_1',
          'creatorId': 'water',
          'data': jsonEncode({
            'title': 'Cybernetic Armor Repair',
            'description': 'Need tactical plating welded for upcoming sector sweep.',
            'category': 'Hardware',
            'bounty': '150 ₣',
            'zipCode': '78701'
          }),
          'listingType': 'forSale',
          'createdAt': DateTime.now().millisecondsSinceEpoch,
        },
        {
          'id': 'seed_2',
          'creatorId': 'fire',
          'data': jsonEncode({
            'title': 'Encrypted Data Relay',
            'description': 'Secure package transfer across the neon district.',
            'category': 'Intel',
            'bounty': '300 ₣',
            'zipCode': '78702'
          }),
          'listingType': 'forSale',
          'createdAt': DateTime.now().millisecondsSinceEpoch - 1000,
        },
        {
          'id': 'seed_3',
          'creatorId': 'earth',
          'data': jsonEncode({
            'title': 'EMP Grenade Cache',
            'description': 'Surplus military-grade suppression ordinance.',
            'category': 'Weapons',
            'bounty': '500 ₣',
            'zipCode': '78704'
          }),
          'listingType': 'forSale',
          'createdAt': DateTime.now().millisecondsSinceEpoch - 2000,
        },
      ];

      for (var seed in seeds) {
        await db.insert('tasks', seed);
      }
      rows = await db.query('tasks', orderBy: 'createdAt DESC');
    }

    state = rows;
  }

  Future<void> refresh() async {
    await loadOfferings();
  }
}

final localOfferingsProvider = Provider<List<Map<String, dynamic>>>((ref) {
  return ref.watch(localOfferingsNotifierProvider);
});

// ── Bids / Interactions Provider ──────────────────────────────────────────────
final userBidsNotifierProvider =
    NotifierProvider<UserBidsNotifier, List<Map<String, dynamic>>>(
        () => UserBidsNotifier());

class UserBidsNotifier extends Notifier<List<Map<String, dynamic>>> {
  @override
  List<Map<String, dynamic>> build() {
    loadBids();
    return [];
  }

  Future<void> loadBids() async {
    final dbService = LocalDatabaseService.instance;
    final db = await dbService.database;

    final rows = await db.query('bids', orderBy: 'createdAt DESC');
    state = rows;
  }

  Future<void> refresh() async {
    await loadBids();
  }
}

final userBidsProvider = Provider<List<Map<String, dynamic>>>((ref) {
  return ref.watch(userBidsNotifierProvider);
});
