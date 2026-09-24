import 'package:flutter/material.dart';

class TeamDetailPage extends StatelessWidget {
  final String teamId;
  const TeamDetailPage({required this.teamId, super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Team')),
    body: Center(child: Text('Team: $teamId — Sprint 8')),
  );
}
