import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hblite/features/teams/data/team_repository.dart';
import 'package:hblite/features/teams/domain/team.dart';
import 'package:hblite/features/teams/presentation/team_providers.dart';

// A mock repository that returns a predefined set of teams for testing
class MockTeamRepository extends TeamRepository {
  final List<Team> mockedTeams;

  MockTeamRepository(this.mockedTeams);

  @override
  Future<List<Team>> getAllTeams() async {
    return mockedTeams;
  }
}

void main() {
  group('hasTeamPermission Provider Tests', () {
    late ProviderContainer container;

    // Build a mock network of teams
    // Hierarchy:
    // Mother Org (owner: user_mother)
    //  ├── Cliq A (owner: user_cliq_a)  [parentIds: mother]
    //  │    └── Sub-Cliq A1 (owner: user_sub_cliq) [parentIds: cliq_a]
    //  └── Cliq B (owner: user_cliq_b)  [parentIds: mother]
    // Independent Team (owner: user_indie)

    final now = DateTime.now();

    final motherOrg = Team(
      id: 'mother',
      name: 'Mother Org',
      ownerId: 'user_mother',
      createdAt: now,
    );

    final cliqA = Team(
      id: 'cliq_a',
      name: 'Cliq A',
      ownerId: 'user_cliq_a',
      parentIds: ['mother'],
      createdAt: now,
    );

    final subCliqA1 = Team(
      id: 'sub_cliq_a1',
      name: 'Sub-Cliq A1',
      ownerId: 'user_sub_cliq',
      parentIds: ['cliq_a'],
      createdAt: now,
    );

    final cliqB = Team(
      id: 'cliq_b',
      name: 'Cliq B',
      ownerId: 'user_cliq_b',
      parentIds: ['mother'],
      createdAt: now,
    );

    final independentTeam = Team(
      id: 'indie',
      name: 'Indie Team',
      ownerId: 'user_indie',
      createdAt: now,
    );

    final allMockTeams = [motherOrg, cliqA, subCliqA1, cliqB, independentTeam];

    setUp(() {
      container = ProviderContainer(
        overrides: [
          teamRepositoryProvider.overrideWithValue(MockTeamRepository(allMockTeams)),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('User has permission if they are the direct owner', () async {
      final result = await container.read(
        hasTeamPermissionProvider(userId: 'user_mother', targetTeamId: 'mother').future,
      );
      expect(result, isTrue);
    });

    test('Child member implicitly inherits permission to parent organization', () async {
      // user_cliq_a should have permission to 'mother'
      final result = await container.read(
        hasTeamPermissionProvider(userId: 'user_cliq_a', targetTeamId: 'mother').future,
      );
      expect(result, isTrue);
    });

    test('Deeply nested child member implicitly inherits permission to root organization', () async {
      // user_sub_cliq should have permission to 'mother'
      final result = await container.read(
        hasTeamPermissionProvider(userId: 'user_sub_cliq', targetTeamId: 'mother').future,
      );
      expect(result, isTrue);
    });

    test('Parent leader implicitly inherits permission to child organization', () async {
      // user_mother should have permission to 'cliq_a'
      final result = await container.read(
        hasTeamPermissionProvider(userId: 'user_mother', targetTeamId: 'cliq_a').future,
      );
      expect(result, isTrue);
    });

    test('Deep parent leader implicitly inherits permission to deeply nested child', () async {
      // user_mother should have permission to 'sub_cliq_a1'
      final result = await container.read(
        hasTeamPermissionProvider(userId: 'user_mother', targetTeamId: 'sub_cliq_a1').future,
      );
      expect(result, isTrue);
    });

    test('Sibling cliq members do NOT inherit permissions across branches', () async {
      // user_cliq_a should NOT have permission to 'cliq_b'
      final result = await container.read(
        hasTeamPermissionProvider(userId: 'user_cliq_a', targetTeamId: 'cliq_b').future,
      );
      expect(result, isFalse);
    });

    test('Independent team member does NOT have permission to other orgs', () async {
      final result = await container.read(
        hasTeamPermissionProvider(userId: 'user_indie', targetTeamId: 'mother').future,
      );
      expect(result, isFalse);
    });
  });
}
