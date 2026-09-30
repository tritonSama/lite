import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../domain/team.dart';
import '../data/team_repository.dart';

part 'team_providers.g.dart';

@riverpod
class SelectedTeam extends _$SelectedTeam {
  static const _key = 'selected_elemental_team';

  @override
  String? build() {
    _loadSelectedTeam();
    return 'team_alpha'; // Default immediately so board never hesitates
  }

  Future<void> _loadSelectedTeam() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_key);
    if (saved != null) {
      state = saved;
    }
  }

  Future<void> selectTeam(String teamId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, teamId);
    state = teamId;
  }
}

@riverpod
Future<List<Team>> teams(Ref ref) async {
  return ref.watch(teamRepositoryProvider).getAllTeams();
}

/// Helper provider to get permissions for a user in a team.
@riverpod
Future<bool> hasTeamPermission(
  Ref ref, {
  required String userId,
  required String targetTeamId,
}) async {
  final repo = ref.watch(teamRepositoryProvider);
  final allTeams = await repo.getAllTeams();

  final teamMap = {for (var t in allTeams) t.id: t};
  final targetTeam = teamMap[targetTeamId];
  if (targetTeam == null) return false;

  if (targetTeam.ownerId == userId) return true;

  bool isUserInChild(String currentTeamId, Set<String> visited) {
    if (visited.contains(currentTeamId)) return false;
    visited.add(currentTeamId);

    final children = allTeams.where((t) => t.parentIds.contains(currentTeamId));
    for (final child in children) {
      if (child.ownerId == userId) return true;
      if (isUserInChild(child.id, visited)) return true;
    }
    return false;
  }

  if (isUserInChild(targetTeamId, {})) return true;

  bool isUserInParent(String currentTeamId, Set<String> visited) {
    if (visited.contains(currentTeamId)) return false;
    visited.add(currentTeamId);

    final currentTeamNode = teamMap[currentTeamId];
    if (currentTeamNode != null) {
      for (final parentId in currentTeamNode.parentIds) {
        final parent = teamMap[parentId];
        if (parent != null) {
          if (parent.ownerId == userId) return true;
          if (isUserInParent(parentId, visited)) return true;
        }
      }
    }
    return false;
  }

  return isUserInParent(targetTeamId, {});
}
