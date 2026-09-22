import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
