class TeamWar {
  final String id;
  final String challengerTeamId;
  final String defenderTeamId;
  final String status; // 'pending', 'active', 'ceasefire', 'victory', 'defeat'
  final int challengerScore;
  final int defenderScore;
  final String? message;
  final int declaredAt;

  const TeamWar({
    required this.id,
    required this.challengerTeamId,
    required this.defenderTeamId,
    required this.status,
    this.challengerScore = 0,
    this.defenderScore = 0,
    this.message,
    required this.declaredAt,
  });

  factory TeamWar.fromMap(Map<String, dynamic> map) {
    return TeamWar(
      id: map['id'] as String,
      challengerTeamId: map['challengerTeamId'] as String,
      defenderTeamId: map['defenderTeamId'] as String,
      status: map['status'] as String,
      challengerScore: (map['challengerScore'] as int?) ?? 0,
      defenderScore: (map['defenderScore'] as int?) ?? 0,
      message: map['message'] as String?,
      declaredAt: map['declaredAt'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'challengerTeamId': challengerTeamId,
      'defenderTeamId': defenderTeamId,
      'status': status,
      'challengerScore': challengerScore,
      'defenderScore': defenderScore,
      'message': message,
      'declaredAt': declaredAt,
    };
  }
}
