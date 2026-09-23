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
    return null;
  }

  Future<void> _loadSelectedTeam() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getString(_key);
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
/// Resolves dynamically: if user is member of a child, they have permissions
/// in the parent organizations as well.
@riverpod
Future<bool> hasTeamPermission(Ref ref, {required String userId, required String targetTeamId}) async {
  final repo = ref.watch(teamRepositoryProvider);
  final allTeams = await repo.getAllTeams();

  // Create a map for quick lookup
  final teamMap = {for (var t in allTeams) t.id: t};
  final targetTeam = teamMap[targetTeamId];
  if (targetTeam == null) return false;

  // Real membership check would hit `Membership` collection.
  // For now, assume we can check if ownerId == userId.
  if (targetTeam.ownerId == userId) return true;

  // We need to recursively check two directions:
  // 1. Is the user in ANY child of this team? (Child inherits parent access)
  // 2. Is the user a leader of ANY parent of this team? (Parent leaders inherit child access)

  bool isUserInRelatedTeam(String currentTeamId, Set<String> visited) {
    if (visited.contains(currentTeamId)) return false;
    visited.add(currentTeamId);

    // Direction 1: Check children
    final children = allTeams.where((t) => t.parentIds.contains(currentTeamId));
    for (final child in children) {
      if (child.ownerId == userId) return true;
      if (isUserInRelatedTeam(child.id, visited)) return true;
    }

    // Direction 2: Check parents
    final currentTeamNode = teamMap[currentTeamId];
    if (currentTeamNode != null) {
      for (final parentId in currentTeamNode.parentIds) {
        final parent = teamMap[parentId];
        if (parent != null) {
          if (parent.ownerId == userId) return true;
          if (isUserInRelatedTeam(parentId, visited)) return true;
        }
      }
    }

    return false;
  }

  return isUserInRelatedTeam(targetTeamId, {});
}
