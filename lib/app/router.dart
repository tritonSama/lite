import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../features/auth/presentation/auth_providers.dart';
import '../features/auth/presentation/login_page.dart';
import '../features/auth/presentation/signup_page.dart';
import '../features/board/presentation/board_page.dart';
import '../features/tasks/presentation/task_detail_page.dart';
import '../features/tasks/presentation/create_task_page.dart';
import '../features/bids/presentation/bids_page.dart';
import '../features/bids/presentation/offer_detail_page.dart';
import '../features/teams/presentation/teams_page.dart';
import '../features/teams/presentation/team_detail_page.dart';
import '../features/profile/presentation/profile_page.dart';
import '../features/profile/presentation/public_profile_page.dart';
import '../features/credentials/presentation/credentials_page.dart';

part 'router.g.dart';

// ── Navigator keys (one per tab branch) ──────────────────────────────────────
final _rootKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final _boardKey = GlobalKey<NavigatorState>(debugLabel: 'board');
final _createKey = GlobalKey<NavigatorState>(debugLabel: 'create');
final _bidsKey = GlobalKey<NavigatorState>(debugLabel: 'bids');
final _teamsKey = GlobalKey<NavigatorState>(debugLabel: 'teams');
final _profileKey = GlobalKey<NavigatorState>(debugLabel: 'profile');

// ── Router provider ───────────────────────────────────────────────────────────
@riverpod
GoRouter appRouter(Ref ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    navigatorKey: _rootKey,
    initialLocation: '/board',
    debugLogDiagnostics: true,

    // ── Auth redirect guard ─────────────────────────────────────────────────
    redirect: (context, state) {
      final isLoggedIn = authState.value != null;
      final isAuthRoute =
          state.matchedLocation.startsWith('/login') ||
          state.matchedLocation.startsWith('/signup');

      if (!isLoggedIn && !isAuthRoute) return '/login';
      if (isLoggedIn && isAuthRoute) return '/board';
      return null;
    },

    routes: [
      // ── Auth routes (outside shell — no bottom nav) ─────────────────────
      GoRoute(path: '/login', builder: (_, __) => const LoginPage()),
      GoRoute(path: '/signup', builder: (_, __) => const SignupPage()),

      // ── Main shell with bottom navigation ───────────────────────────────
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => AppShell(shell: shell),
        branches: [
          // 🏠 Board
          StatefulShellBranch(
            navigatorKey: _boardKey,
            routes: [
              GoRoute(
                path: '/board',
                builder: (_, __) => const BoardPage(),
                routes: [
                  GoRoute(
                    path: 'task/:taskId',
                    builder: (_, state) =>
                        TaskDetailPage(taskId: state.pathParameters['taskId']!),
                  ),
                  GoRoute(
                    path: 'user/:userId',
                    builder: (_, state) => PublicProfilePage(
                      userId: state.pathParameters['userId']!,
                    ),
                  ),
                ],
              ),
            ],
          ),

          // ➕ Create
          StatefulShellBranch(
            navigatorKey: _createKey,
            routes: [
              GoRoute(
                path: '/create',
                builder: (_, __) => const CreateTaskPage(),
              ),
            ],
          ),

          // 💰 Bids
          StatefulShellBranch(
            navigatorKey: _bidsKey,
            routes: [
              GoRoute(
                path: '/bids',
                builder: (_, __) => const BidsPage(),
                routes: [
                  GoRoute(
                    path: ':offerId',
                    builder: (_, state) => OfferDetailPage(
                      offerId: state.pathParameters['offerId']!,
                    ),
                  ),
                ],
              ),
            ],
          ),

          // 👥 Teams
          StatefulShellBranch(
            navigatorKey: _teamsKey,
            routes: [
              GoRoute(
                path: '/teams',
                builder: (_, __) => const TeamsPage(),
                routes: [
                  GoRoute(
                    path: ':teamId',
                    builder: (_, state) =>
                        TeamDetailPage(teamId: state.pathParameters['teamId']!),
                  ),
                ],
              ),
            ],
          ),

          // 👤 Profile
          StatefulShellBranch(
            navigatorKey: _profileKey,
            routes: [
              GoRoute(
                path: '/profile',
                builder: (_, __) => const ProfilePage(),
                routes: [
                  GoRoute(
                    path: 'credentials',
                    builder: (_, __) => const CredentialsPage(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

// ── App shell — persistent bottom navigation bar ──────────────────────────────
class AppShell extends StatelessWidget {
  final StatefulNavigationShell shell;
  const AppShell({required this.shell, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: shell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: shell.currentIndex,
        onDestinationSelected: (index) => shell.goBranch(
          index,
          // Re-tapping the active tab pops to the root of that branch
          initialLocation: index == shell.currentIndex,
        ),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Board',
          ),
          NavigationDestination(
            icon: Icon(Icons.add_circle_outline),
            selectedIcon: Icon(Icons.add_circle),
            label: 'Create',
          ),
          NavigationDestination(
            icon: Icon(Icons.gavel_outlined),
            selectedIcon: Icon(Icons.gavel),
            label: 'Bids',
          ),
          NavigationDestination(
            icon: Icon(Icons.group_outlined),
            selectedIcon: Icon(Icons.group),
            label: 'Teams',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
