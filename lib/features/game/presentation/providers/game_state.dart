import 'package:freezed_annotation/freezed_annotation.dart';

part 'game_state.freezed.dart';

enum PlayerId { p1, p2 }

enum GamePhase { setup, playing, gameOver }

enum TurnPhase { rollForMovement, move, resolveTrap, resolveCombat }

enum SetupItemType { piece, trap, flag }

@freezed
abstract class Point with _$Point {
  const factory Point(int x, int y) = _Point;
}

@freezed
abstract class Card with _$Card {
  const factory Card(int value) = _Card;
}

@freezed
abstract class PlayerState with _$PlayerState {
  const factory PlayerState({
    required PlayerId id,
    @Default(20) int hp,
    required List<Card> unplacedTraps,
    @Default(7) int piecesToPlace,
    @Default(false) bool flagPlaced,
    @Default(false) bool setupComplete,
  }) = _PlayerState;
}

@freezed
abstract class GameState with _$GameState {
  const factory GameState({
    @Default(GamePhase.setup) GamePhase phase,
    @Default(TurnPhase.rollForMovement) TurnPhase turnPhase,
    @Default(PlayerId.p1) PlayerId currentPlayer,

    // Board state
    @Default({}) Map<Point, PlayerId> pieces,
    @Default({}) Map<Point, MapEntry<PlayerId, Card>> traps,
    @Default({}) Map<Point, PlayerId> flags,

    required Map<PlayerId, PlayerState> players,

    // Turn specific state
    @Default(0) int movementPointsLeft,
    Point? selectedPiece,
    Point? pendingTrapLocation, // where the trap is triggered
    Point? pendingCombatLocation, // where combat is happening
    @Default([]) List<String> combatLogs,
    PlayerId? winner,
  }) = _GameState;
}
