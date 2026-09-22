import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final selectedTeamProvider = StateNotifierProvider<SelectedTeamNotifier, String?>((ref) {
  return SelectedTeamNotifier();
});

class SelectedTeamNotifier extends StateNotifier<String?> {
  SelectedTeamNotifier() : super(null) {
    _loadSelectedTeam();
  }

  static const _key = 'selected_elemental_team';

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
