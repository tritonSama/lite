import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme.dart';
import 'providers/game_provider.dart';
import 'providers/game_state.dart' as game_state;
import 'providers/game_state.dart' hide Card;

class GamePage extends ConsumerStatefulWidget {
  const GamePage({super.key});

  @override
  ConsumerState<GamePage> createState() => _GamePageState();
}

class _GamePageState extends ConsumerState<GamePage> {
  SetupItemType _selectedSetupItem = SetupItemType.piece;
  game_state.Card? _selectedSetupCard;

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(gameProvider);
    final notifier = ref.read(gameProvider.notifier);

    return Scaffold(
      backgroundColor: const Color(0xFF0C0F1D), // Deep neutral
      appBar: AppBar(
        title: const Text(
          'Terminal Game',
          style: TextStyle(
            fontFamily: 'Space Grotesk',
            fontWeight: FontWeight.bold,
            color: HBColors.primary,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildStatusPanel(gameState, PlayerId.p2),
          const Divider(color: HBColors.primary, height: 1),

          Expanded(
            child: Center(
              child: AspectRatio(
                aspectRatio: 1,
                child: _buildBoard(gameState, notifier),
              ),
            ),
          ),

          const Divider(color: HBColors.primary, height: 1),
          if (gameState.phase == GamePhase.setup)
            _buildSetupControls(gameState, notifier),
          if (gameState.phase == GamePhase.playing)
            _buildActionControls(gameState, notifier),
          if (gameState.phase == GamePhase.gameOver) _buildGameOver(gameState),

          _buildStatusPanel(gameState, PlayerId.p1),
        ],
      ),
    );
  }

  Widget _buildStatusPanel(GameState state, PlayerId player) {
    final pState = state.players[player]!;
    final isCurrent = state.currentPlayer == player;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: isCurrent && state.phase != GamePhase.gameOver
          ? HBColors.primary.withValues(alpha: 0.1)
          : Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            player == PlayerId.p1 ? 'PLAYER 1' : 'PLAYER 2',
            style: TextStyle(
              color: player == PlayerId.p1
                  ? HBColors.primary
                  : HBColors.secondary, // Cyberpunk cyan / gold
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          Row(
            children: [
              const Icon(Icons.favorite, color: Colors.redAccent, size: 20),
              const SizedBox(width: 4),
              Text(
                '${pState.hp} HP',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBoard(GameState state, GameNotifier notifier) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 9,
          ),
          itemCount: 81,
          itemBuilder: (context, index) {
            final x = index % 9;
            final y = index ~/ 9;
            final point = Point(x, y);

            return GestureDetector(
              onTap: () => _onTileTap(point, state, notifier),
              child: _buildTile(point, state),
            );
          },
        );
      },
    );
  }

  Widget _buildTile(Point point, GameState state) {
    final isP1Zone = point.y > 4;
    final isP2Zone = point.y < 4;

    Color tileColor = (point.x + point.y) % 2 == 0
        ? Colors.white10
        : Colors.black12;
    if (state.phase == GamePhase.setup) {
      if (state.currentPlayer == PlayerId.p1 && isP1Zone) {
        tileColor = HBColors.primary.withValues(alpha: 0.2);
      } else if (state.currentPlayer == PlayerId.p2 && isP2Zone) {
        tileColor = HBColors.secondary.withValues(alpha: 0.2);
      }
    }

    if (state.selectedPiece == point) {
      tileColor = Colors.white30; // Highlight selected
    } else if (state.pendingTrapLocation == point) {
      tileColor = Colors.red.withValues(alpha: 0.5); // Trap triggered
    } else if (state.pendingCombatLocation == point) {
      tileColor = Colors.orange.withValues(alpha: 0.5); // Combat happening
    }

    final hasPiece = state.pieces.containsKey(point);
    final hasTrap = state.traps.containsKey(point);
    final hasFlag = state.flags.containsKey(point);

    return Container(
      decoration: BoxDecoration(
        color: tileColor,
        border: Border.all(color: Colors.white12),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Traps (hidden unless it's your own, or game over)
          if (hasTrap)
            if (state.traps[point]!.key == state.currentPlayer ||
                state.phase == GamePhase.gameOver)
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.redAccent, width: 2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Center(
                      child: Text(
                        '${state.traps[point]!.value.value}',
                        style: const TextStyle(
                          color: Colors.redAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

          // Flags
          if (hasFlag)
            Icon(
              Icons.flag,
              color: state.flags[point] == PlayerId.p1
                  ? HBColors.primary
                  : HBColors.secondary,
            ),

          // Pieces
          if (hasPiece)
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: state.pieces[point] == PlayerId.p1
                    ? HBColors.primary
                    : HBColors.secondary,
                boxShadow: [
                  BoxShadow(
                    color:
                        (state.pieces[point] == PlayerId.p1
                                ? HBColors.primary
                                : HBColors.secondary)
                            .withValues(alpha: 0.8),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  void _onTileTap(Point point, GameState state, GameNotifier notifier) {
    if (state.phase == GamePhase.setup) {
      notifier.placeItem(
        point,
        _selectedSetupItem,
        state.currentPlayer,
        card: _selectedSetupCard,
      );
    } else if (state.phase == GamePhase.playing) {
      if (state.turnPhase == TurnPhase.move) {
        if (state.pieces[point] == state.currentPlayer) {
          notifier.selectPiece(point);
        } else if (state.selectedPiece != null) {
          notifier.moveSelectedPiece(point);
        }
      }
    }
  }

  Widget _buildSetupControls(GameState state, GameNotifier notifier) {
    final pState = state.players[state.currentPlayer]!;

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            '${state.currentPlayer == PlayerId.p1 ? "P1" : "P2"} SETUP PHASE',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _SetupButton(
                  label: 'Pieces (${pState.piecesToPlace})',
                  isSelected: _selectedSetupItem == SetupItemType.piece,
                  onTap: () => setState(() {
                    _selectedSetupItem = SetupItemType.piece;
                    _selectedSetupCard = null;
                  }),
                ),
                const SizedBox(width: 8),
                _SetupButton(
                  label: 'Flag (${pState.flagPlaced ? 0 : 1})',
                  isSelected: _selectedSetupItem == SetupItemType.flag,
                  onTap: () => setState(() {
                    _selectedSetupItem = SetupItemType.flag;
                    _selectedSetupCard = null;
                  }),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          const Text('Traps:', style: TextStyle(color: Colors.white70)),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: pState.unplacedTraps.map((card) {
                final isSelected =
                    _selectedSetupItem == SetupItemType.trap &&
                    _selectedSetupCard == card;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: InkWell(
                    onTap: () => setState(() {
                      _selectedSetupItem = SetupItemType.trap;
                      _selectedSetupCard = card;
                    }),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: isSelected
                              ? HBColors.tertiary
                              : Colors.white30,
                        ),
                        borderRadius: BorderRadius.circular(4),
                        color: isSelected
                            ? HBColors.tertiary.withValues(alpha: 0.2)
                            : Colors.transparent,
                      ),
                      child: Text(
                        '${card.value}',
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.white70,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed:
                (pState.piecesToPlace == 0 &&
                    pState.unplacedTraps.isEmpty &&
                    pState.flagPlaced)
                ? () {
                    notifier.completeSetup(state.currentPlayer);
                    setState(() {
                      _selectedSetupItem = SetupItemType.piece;
                      _selectedSetupCard = null;
                    });
                  }
                : null,
            child: const Text('COMPLETE SETUP'),
          ),
        ],
      ),
    );
  }

  Widget _buildActionControls(GameState state, GameNotifier notifier) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          if (state.turnPhase == TurnPhase.rollForMovement)
            ElevatedButton(
              onPressed: () {
                final roll = Random().nextInt(12) + 1;
                notifier.rollForMovement(roll);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: HBColors.tertiary,
              ),
              child: const Text(
                'ROLL D12 FOR MOVEMENT',
                style: TextStyle(color: Colors.white),
              ),
            ),

          if (state.turnPhase == TurnPhase.move)
            Column(
              children: [
                Text(
                  'Movement Points: ${state.movementPointsLeft}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  state.selectedPiece == null
                      ? 'Select a piece to move'
                      : 'Tap adjacent tile to move',
                  style: const TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => notifier.endTurn(),
                  child: const Text('END TURN'),
                ),
              ],
            ),

          if (state.turnPhase == TurnPhase.resolveTrap)
            Column(
              children: [
                const Text(
                  'TRAP TRIGGERED!',
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    final roll = Random().nextInt(12) + 1;
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        backgroundColor: const Color(0xFF0C0F1D),
                        title: const Text(
                          'Trap Roll',
                          style: TextStyle(color: Colors.white),
                        ),
                        content: Text(
                          'You rolled a $roll.',
                          style: const TextStyle(color: Colors.white),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              notifier.resolveTrap(roll);
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                  ),
                  child: const Text(
                    'ROLL D12 TO DISARM',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),

          if (state.turnPhase == TurnPhase.resolveCombat)
            Column(
              children: [
                const Text(
                  'COMBAT INITIATED!',
                  style: TextStyle(
                    color: Colors.orange,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (state.combatLogs.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      state.combatLogs.last,
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    final p1Roll = Random().nextInt(12) + 1;
                    final p2Roll = Random().nextInt(12) + 1;

                    final attackerRoll = state.currentPlayer == PlayerId.p1
                        ? p1Roll
                        : p2Roll;
                    final defenderRoll = state.currentPlayer == PlayerId.p1
                        ? p2Roll
                        : p1Roll;

                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        backgroundColor: const Color(0xFF0C0F1D),
                        title: const Text(
                          'Combat Roll',
                          style: TextStyle(color: Colors.white),
                        ),
                        content: Text(
                          'Attacker rolled: $attackerRoll\nDefender rolled: $defenderRoll',
                          style: const TextStyle(color: Colors.white),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              notifier.resolveCombat(
                                attackerRoll,
                                defenderRoll,
                              );
                            },
                            child: const Text('RESOLVE'),
                          ),
                        ],
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                  ),
                  child: const Text(
                    'ROLL COMBAT',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildGameOver(GameState state) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Text(
            'GAME OVER',
            style: TextStyle(
              color: HBColors.primary,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            state.winner == PlayerId.p1 ? 'PLAYER 1 WINS' : 'PLAYER 2 WINS',
            style: const TextStyle(color: Colors.white, fontSize: 18),
          ),
        ],
      ),
    );
  }
}

class _SetupButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _SetupButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? HBColors.primary : Colors.white30,
          ),
          borderRadius: BorderRadius.circular(8),
          color: isSelected
              ? HBColors.primary.withValues(alpha: 0.2)
              : Colors.transparent,
        ),
        child: Text(
          label,
          style: TextStyle(color: isSelected ? Colors.white : Colors.white70),
        ),
      ),
    );
  }
}
