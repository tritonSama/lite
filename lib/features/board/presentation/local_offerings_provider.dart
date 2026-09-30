import 'package:flutter_riverpod/flutter_riverpod.dart';

final localOfferingsProvider = Provider<List<Map<String, dynamic>>>((ref) {
  return [
    {
      'id': 'seed_1',
      'creatorId': 'team_alpha',
      'data': '{"title":"Cybernetic Armor Repair","description":"Need tactical plating welded for upcoming sector sweep.","category":"Hardware","bounty":"150 ₣"}',
      'listingType': 'forSale',
      'createdAt': DateTime.now().millisecondsSinceEpoch,
    },
    {
      'id': 'seed_2',
      'creatorId': 'team_beta',
      'data': '{"title":"Encrypted Data Relay","description":"Secure package transfer across the neon district.","category":"Intel","bounty":"300 ₣"}',
      'listingType': 'forSale',
      'createdAt': DateTime.now().millisecondsSinceEpoch - 1000,
    },
    {
      'id': 'seed_3',
      'creatorId': 'team_gamma',
      'data': '{"title":"EMP Grenade Cache","description":"Surplus military-grade suppression ordinance.","category":"Weapons","bounty":"500 ₣"}',
      'listingType': 'forSale',
      'createdAt': DateTime.now().millisecondsSinceEpoch - 2000,
    },
  ];
});
