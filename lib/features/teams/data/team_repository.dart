import 'dart:convert';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/team.dart';
import '../../../core/services/local_database_service.dart';

part 'team_repository.g.dart';

@riverpod
TeamRepository teamRepository(Ref ref) => TeamRepository();

class TeamRepository {
  final _dbService = LocalDatabaseService.instance;

  Future<void> createTeam(Team team) async {
    final db = await _dbService.database;

    await db.insert('teams', {
      'id': team.id,
      'ownerId': team.ownerId,
      'data': jsonEncode(team.toJson()),
      'createdAt': DateTime.now().millisecondsSinceEpoch,
    });
  }

  Future<List<Team>> getTeamsByOwner(String ownerId) async {
    final db = await _dbService.database;

    final maps = await db.query(
      'teams',
      where: 'ownerId = ?',
      whereArgs: [ownerId],
      orderBy: 'createdAt DESC',
    );

    return maps.map((m) {
      final dataMap = jsonDecode(m['data'] as String) as Map<String, dynamic>;
      return Team.fromJson(dataMap);
    }).toList();
  }

  Future<Team?> getTeamById(String teamId) async {
    final db = await _dbService.database;

    final maps = await db.query(
      'teams',
      where: 'id = ?',
      whereArgs: [teamId],
      limit: 1,
    );

    if (maps.isNotEmpty) {
      final dataMap =
          jsonDecode(maps.first['data'] as String) as Map<String, dynamic>;
      return Team.fromJson(dataMap);
    }
    return null;
  }
}
