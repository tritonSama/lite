import React, { useState, useEffect } from 'react';
import { 
  PlayerId, 
  GamePhase, 
  TurnPhase, 
  SetupItemType, 
  Point, 
  TrapCard, 
  PlayerGameState 
} from '../types';
import { 
  Gamepad2, 
  Heart, 
  Dices, 
  Flag, 
  ShieldAlert, 
  Swords, 
  RotateCcw, 
  Check, 
  Flame, 
  Trophy 
} from 'lucide-react';

export const GamePage: React.FC = () => {
  // Game Setup & State
  const [phase, setPhase] = useState<GamePhase>('setup');
  const [turnPhase, setTurnPhase] = useState<TurnPhase>('rollForMovement');
  const [currentPlayer, setCurrentPlayer] = useState<PlayerId>('p1');
  const [winner, setWinner] = useState<PlayerId | null>(null);

  // Player States
  const [players, setPlayers] = useState<Record<PlayerId, PlayerGameState>>({
    p1: {
      id: 'p1',
      name: 'PLAYER 1 (CYAN)',
      hp: 20,
      unplacedTraps: [
        { id: 't1', value: 3 },
        { id: 't2', value: 5 },
        { id: 't3', value: 7 },
        { id: 't4', value: 8 },
        { id: 't5', value: 10 },
        { id: 't6', value: 11 },
        { id: 't7', value: 12 },
      ],
      piecesToPlace: 7,
      flagPlaced: false,
      setupComplete: false,
    },
    p2: {
      id: 'p2',
      name: 'PLAYER 2 (GOLD)',
      hp: 20,
      unplacedTraps: [
        { id: 't8', value: 4 },
        { id: 't9', value: 6 },
        { id: 't10', value: 7 },
        { id: 't11', value: 9 },
        { id: 't12', value: 10 },
        { id: 't13', value: 11 },
        { id: 't14', value: 12 },
      ],
      piecesToPlace: 7,
      flagPlaced: false,
      setupComplete: false,
    },
  });

  // Board items: Point string 'x,y' -> data
  const [pieces, setPieces] = useState<Record<string, PlayerId>>({});
  const [traps, setTraps] = useState<Record<string, { owner: PlayerId; card: TrapCard }>>({});
  const [flags, setFlags] = useState<Record<string, PlayerId>>({});

  // Turn movement state
  const [movementPointsLeft, setMovementPointsLeft] = useState<number>(0);
  const [selectedPiece, setSelectedPiece] = useState<Point | null>(null);
  const [pendingTrapLoc, setPendingTrapLoc] = useState<Point | null>(null);
  const [pendingCombatLoc, setPendingCombatLoc] = useState<Point | null>(null);
  const [combatLogs, setCombatLogs] = useState<string[]>([]);

  // Setup tools
  const [setupItemType, setSetupItemType] = useState<SetupItemType>('piece');
  const [selectedTrapCard, setSelectedTrapCard] = useState<TrapCard | null>(null);

  // Modal / Alert for Rolls
  const [activeRollModal, setActiveRollModal] = useState<{
    type: 'trap' | 'combat' | 'movement';
    title: string;
    details: string;
    onResolve: (roll1: number, roll2?: number) => void;
  } | null>(null);

  const resetGame = () => {
    setPhase('setup');
    setTurnPhase('rollForMovement');
    setCurrentPlayer('p1');
    setWinner(null);
    setPieces({});
    setTraps({});
    setFlags({});
    setMovementPointsLeft(0);
    setSelectedPiece(null);
    setPendingTrapLoc(null);
    setPendingCombatLoc(null);
    setCombatLogs([]);
    setSetupItemType('piece');
    setSelectedTrapCard(null);

    setPlayers({
      p1: {
        id: 'p1',
        name: 'PLAYER 1 (CYAN)',
        hp: 20,
        unplacedTraps: [
          { id: 't1', value: 3 },
          { id: 't2', value: 5 },
          { id: 't3', value: 7 },
          { id: 't4', value: 8 },
          { id: 't5', value: 10 },
          { id: 't6', value: 11 },
          { id: 't7', value: 12 },
        ],
        piecesToPlace: 7,
        flagPlaced: false,
        setupComplete: false,
      },
      p2: {
        id: 'p2',
        name: 'PLAYER 2 (GOLD)',
        hp: 20,
        unplacedTraps: [
          { id: 't8', value: 4 },
          { id: 't9', value: 6 },
          { id: 't10', value: 7 },
          { id: 't11', value: 9 },
          { id: 't12', value: 10 },
          { id: 't13', value: 11 },
          { id: 't14', value: 12 },
        ],
        piecesToPlace: 7,
        flagPlaced: false,
        setupComplete: false,
      },
    });
  };

  const pointKey = (p: Point) => `${p.x},${p.y}`;

  // Placing items during setup
  const handleTileClick = (point: Point) => {
    const key = pointKey(point);

    if (phase === 'setup') {
      // Boundaries: P1 gets rows 5-8. P2 gets rows 0-3.
      if (currentPlayer === 'p1' && point.y < 5) return;
      if (currentPlayer === 'p2' && point.y > 3) return;

      // Cannot place on existing item
      if (pieces[key] || traps[key] || flags[key]) return;

      const pState = players[currentPlayer];

      if (setupItemType === 'piece' && pState.piecesToPlace > 0) {
        setPieces(prev => ({ ...prev, [key]: currentPlayer }));
        setPlayers(prev => ({
          ...prev,
          [currentPlayer]: {
            ...pState,
            piecesToPlace: pState.piecesToPlace - 1,
          },
        }));
      } else if (setupItemType === 'flag' && !pState.flagPlaced) {
        setFlags(prev => ({ ...prev, [key]: currentPlayer }));
        setPlayers(prev => ({
          ...prev,
          [currentPlayer]: {
            ...pState,
            flagPlaced: true,
          },
        }));
      } else if (setupItemType === 'trap' && selectedTrapCard) {
        setTraps(prev => ({
          ...prev,
          [key]: { owner: currentPlayer, card: selectedTrapCard },
        }));
        setPlayers(prev => ({
          ...prev,
          [currentPlayer]: {
            ...pState,
            unplacedTraps: pState.unplacedTraps.filter(t => t.id !== selectedTrapCard.id),
          },
        }));
        setSelectedTrapCard(null);
      }
    } else if (phase === 'playing') {
      if (turnPhase === 'move') {
        const pieceOwner = pieces[key];
        if (pieceOwner === currentPlayer) {
          // Select this piece
          setSelectedPiece(point);
        } else if (selectedPiece && movementPointsLeft > 0) {
          // Attempt orthogonal move of distance 1
          const dx = Math.abs(selectedPiece.x - point.x);
          const dy = Math.abs(selectedPiece.y - point.y);
          if (dx + dy === 1) {
            handlePieceMove(selectedPiece, point);
          }
        }
      }
    }
  };

  const handlePieceMove = (from: Point, to: Point) => {
    const fromKey = pointKey(from);
    const toKey = pointKey(to);

    const enemyPiece = pieces[toKey];
    if (enemyPiece === currentPlayer) return; // Cannot land on own piece

    // Decrement move points
    const remainingMoves = movementPointsLeft - 1;
    setMovementPointsLeft(remainingMoves);

    // 1. Check Flag Capture
    const flagOwner = flags[toKey];
    if (flagOwner && flagOwner !== currentPlayer) {
      // Victory!
      setWinner(currentPlayer);
      setPhase('gameOver');
      setPieces(prev => {
        const next = { ...prev };
        delete next[fromKey];
        next[toKey] = currentPlayer;
        return next;
      });
      return;
    }

    // 2. Check Combat
    if (enemyPiece && enemyPiece !== currentPlayer) {
      setPendingCombatLoc(to);
      setTurnPhase('resolveCombat');
      setActiveRollModal({
        type: 'combat',
        title: 'COMBAT INITIATED!',
        details: 'Attacker and Defender both roll D12. Loser takes differential damage.',
        onResolve: (attRoll, defRoll = 1) => {
          resolveCombat(from, to, attRoll, defRoll);
        },
      });
      return;
    }

    // 3. Check Trap
    const trap = traps[toKey];
    if (trap && trap.owner !== currentPlayer) {
      setPendingTrapLoc(to);
      setTurnPhase('resolveTrap');
      // Move piece onto the trap tile
      setPieces(prev => {
        const next = { ...prev };
        delete next[fromKey];
        next[toKey] = currentPlayer;
        return next;
      });

      setActiveRollModal({
        type: 'trap',
        title: 'TRAP TRIGGERED!',
        details: `Hidden trap activated (Card Value: ${trap.card.value}). Roll D12 to disarm or minimize blast damage.`,
        onResolve: roll => {
          resolveTrap(to, trap.card.value, roll);
        },
      });
      return;
    }

    // Standard Movement
    setPieces(prev => {
      const next = { ...prev };
      delete next[fromKey];
      next[toKey] = currentPlayer;
      return next;
    });
    setSelectedPiece(to);
  };

  const resolveCombat = (from: Point, to: Point, attRoll: number, defRoll: number) => {
    const fromKey = pointKey(from);
    const toKey = pointKey(to);

    const defender = currentPlayer === 'p1' ? 'p2' : 'p1';
    const log = `Attacker rolled ${attRoll}, Defender rolled ${defRoll}.`;
    setCombatLogs(prev => [...prev, log]);

    if (attRoll === defRoll) {
      // Tie - reroll
      setCombatLogs(prev => [...prev, 'Tie! Attacking piece holds ground.']);
      setTurnPhase('move');
      setActiveRollModal(null);
      return;
    }

    const damage = Math.abs(attRoll - defRoll);

    if (attRoll > defRoll) {
      // Attacker wins! Defender piece dies, attacker takes tile
      setPieces(prev => {
        const next = { ...prev };
        delete next[fromKey];
        next[toKey] = currentPlayer;
        return next;
      });
      setSelectedPiece(to);

      applyDamage(defender, damage);
    } else {
      // Defender wins! Attacker piece dies
      setPieces(prev => {
        const next = { ...prev };
        delete next[fromKey];
        return next;
      });
      setSelectedPiece(null);

      applyDamage(currentPlayer, damage);
    }

    setTurnPhase('move');
    setPendingCombatLoc(null);
    setActiveRollModal(null);
  };

  const resolveTrap = (loc: Point, trapCardVal: number, roll: number) => {
    const toKey = pointKey(loc);

    // Trap removed
    setTraps(prev => {
      const next = { ...prev };
      delete next[toKey];
      return next;
    });

    let damage = 0;
    if (roll <= trapCardVal) {
      damage = trapCardVal - roll;
    }

    setCombatLogs(prev => [
      ...prev,
      `Trap exploded! Disarm roll ${roll} vs trap ${trapCardVal}. Blast damage: ${damage} HP.`,
    ]);

    if (damage > 0) {
      applyDamage(currentPlayer, damage);
    }

    setTurnPhase('move');
    setPendingTrapLoc(null);
    setActiveRollModal(null);
  };

  const applyDamage = (targetPlayer: PlayerId, damage: number) => {
    setPlayers(prev => {
      const p = prev[targetPlayer];
      const newHp = Math.max(0, p.hp - damage);
      if (newHp <= 0) {
        setWinner(targetPlayer === 'p1' ? 'p2' : 'p1');
        setPhase('gameOver');
      }
      return {
        ...prev,
        [targetPlayer]: {
          ...p,
          hp: newHp,
        },
      };
    });
  };

  const completeSetup = () => {
    const pState = players[currentPlayer];
    if (pState.piecesToPlace === 0 && pState.unplacedTraps.length === 0 && pState.flagPlaced) {
      setPlayers(prev => ({
        ...prev,
        [currentPlayer]: { ...pState, setupComplete: true },
      }));

      if (currentPlayer === 'p1') {
        setCurrentPlayer('p2');
        setSetupItemType('piece');
      } else {
        // Both completed
        setCurrentPlayer('p1');
        setPhase('playing');
        setTurnPhase('rollForMovement');
      }
    }
  };

  const rollMovementDice = () => {
    const roll = Math.floor(Math.random() * 12) + 1;
    setMovementPointsLeft(roll);
    setTurnPhase('move');
  };

  const endTurn = () => {
    setCurrentPlayer(prev => (prev === 'p1' ? 'p2' : 'p1'));
    setTurnPhase('rollForMovement');
    setMovementPointsLeft(0);
    setSelectedPiece(null);
  };

  return (
    <div className="pb-24 pt-2">
      <div className="max-w-2xl mx-auto px-4 space-y-4">
        {/* Game Title Bar */}
        <div className="flex items-center justify-between bg-[#16192B] border border-[#2C324A] rounded-xl px-4 py-3">
          <div className="flex items-center gap-2">
            <Gamepad2 className="w-5 h-5 text-[#0096C7]" />
            <h2 className="font-display font-bold text-white text-base tracking-wide">
              TERMINAL TACTICS // 9x9 GRID
            </h2>
          </div>
          <button
            onClick={resetGame}
            className="flex items-center gap-1.5 px-3 py-1.5 rounded-lg border border-[#2C324A] text-white/70 hover:text-white hover:bg-white/5 text-xs font-mono transition"
          >
            <RotateCcw className="w-3.5 h-3.5" />
            <span>Reset</span>
          </button>
        </div>

        {/* Player 2 Status Panel (Top / Gold) */}
        <div
          className={`p-3 rounded-xl border flex items-center justify-between transition-all ${
            currentPlayer === 'p2' && phase !== 'gameOver'
              ? 'bg-[#D4AF37]/15 border-[#D4AF37] shadow-[0_0_15px_rgba(212,175,55,0.2)]'
              : 'bg-[#16192B] border-[#2C324A]'
          }`}
        >
          <div className="flex items-center gap-2">
            <span className="w-3 h-3 rounded-full bg-[#D4AF37] shadow-[0_0_8px_#D4AF37]" />
            <span className="font-mono font-bold text-xs text-[#D4AF37]">PLAYER 2 (GOLD)</span>
            {phase === 'setup' && (
              <span className="text-[10px] font-mono text-white/50">
                {players.p2.setupComplete ? '✓ Ready' : 'Setting up...'}
              </span>
            )}
          </div>
          <div className="flex items-center gap-2">
            <Heart className="w-4 h-4 text-red-500 fill-red-500" />
            <span className="font-mono font-bold text-sm text-white">{players.p2.hp} HP</span>
          </div>
        </div>

        {/* 9x9 Game Board */}
        <div className="aspect-square w-full max-w-[500px] mx-auto bg-[#0C0F1D] border-2 border-[#0096C7]/50 rounded-xl overflow-hidden p-1 shadow-[0_0_25px_rgba(0,150,199,0.2)]">
          <div className="grid grid-cols-9 grid-rows-9 gap-1 w-full h-full">
            {Array.from({ length: 81 }).map((_, index) => {
              const x = index % 9;
              const y = Math.floor(index / 9);
              const point: Point = { x, y };
              const key = pointKey(point);

              const isP1Zone = y >= 5;
              const isP2Zone = y <= 3;
              const isSelected = selectedPiece?.x === x && selectedPiece?.y === y;
              const hasPiece = pieces[key];
              const hasFlag = flags[key];
              const trapData = traps[key];

              // Color zones
              let tileBg = 'bg-[#111424]';
              if (phase === 'setup') {
                if (currentPlayer === 'p1' && isP1Zone) tileBg = 'bg-[#0096C7]/15 hover:bg-[#0096C7]/25';
                if (currentPlayer === 'p2' && isP2Zone) tileBg = 'bg-[#D4AF37]/15 hover:bg-[#D4AF37]/25';
              } else {
                if (isSelected) tileBg = 'bg-white/30';
                else if (pendingCombatLoc?.x === x && pendingCombatLoc?.y === y) tileBg = 'bg-orange-500/50';
                else if (pendingTrapLoc?.x === x && pendingTrapLoc?.y === y) tileBg = 'bg-red-500/50';
                else if ((x + y) % 2 === 0) tileBg = 'bg-[#131728]';
              }

              // Highlight potential moves if piece is selected
              const isAdjacent =
                selectedPiece &&
                Math.abs(selectedPiece.x - x) + Math.abs(selectedPiece.y - y) === 1 &&
                pieces[key] !== currentPlayer;

              return (
                <div
                  key={index}
                  onClick={() => handleTileClick(point)}
                  className={`relative rounded flex items-center justify-center cursor-pointer transition select-none border border-[#2C324A]/40 ${tileBg} ${
                    isAdjacent ? 'ring-2 ring-[#0096C7] ring-inset animate-pulse' : ''
                  }`}
                >
                  {/* Traps (shown only to owner or on game over) */}
                  {trapData && (trapData.owner === currentPlayer || phase === 'gameOver') && (
                    <div className="absolute inset-0.5 rounded border border-red-500/80 bg-red-500/20 flex items-center justify-center">
                      <span className="text-[10px] font-mono font-bold text-red-400">
                        {trapData.card.value}
                      </span>
                    </div>
                  )}

                  {/* Flag */}
                  {hasFlag && (
                    <Flag
                      className={`w-4 h-4 ${
                        hasFlag === 'p1' ? 'text-[#0096C7]' : 'text-[#D4AF37]'
                      } drop-shadow-[0_0_6px_currentColor]`}
                    />
                  )}

                  {/* Piece */}
                  {hasPiece && (
                    <div
                      className={`w-5 h-5 rounded-full border-2 border-white/90 shadow-md ${
                        hasPiece === 'p1'
                          ? 'bg-[#0096C7] shadow-[0_0_10px_#0096C7]'
                          : 'bg-[#D4AF37] shadow-[0_0_10px_#D4AF37]'
                      }`}
                    />
                  )}
                </div>
              );
            })}
          </div>
        </div>

        {/* Player 1 Status Panel (Bottom / Cyan) */}
        <div
          className={`p-3 rounded-xl border flex items-center justify-between transition-all ${
            currentPlayer === 'p1' && phase !== 'gameOver'
              ? 'bg-[#0096C7]/15 border-[#0096C7] shadow-[0_0_15px_rgba(0,150,199,0.2)]'
              : 'bg-[#16192B] border-[#2C324A]'
          }`}
        >
          <div className="flex items-center gap-2">
            <span className="w-3 h-3 rounded-full bg-[#0096C7] shadow-[0_0_8px_#0096C7]" />
            <span className="font-mono font-bold text-xs text-[#0096C7]">PLAYER 1 (CYAN)</span>
            {phase === 'setup' && (
              <span className="text-[10px] font-mono text-white/50">
                {players.p1.setupComplete ? '✓ Ready' : 'Setting up...'}
              </span>
            )}
          </div>
          <div className="flex items-center gap-2">
            <Heart className="w-4 h-4 text-red-500 fill-red-500" />
            <span className="font-mono font-bold text-sm text-white">{players.p1.hp} HP</span>
          </div>
        </div>

        {/* Phase Control Panels */}
        {phase === 'setup' && (
          <div className="p-4 bg-[#16192B] border border-[#2C324A] rounded-xl space-y-3">
            <div className="flex items-center justify-between">
              <span className="text-xs font-mono font-bold text-white uppercase">
                {currentPlayer === 'p1' ? 'P1 CYAN SETUP' : 'P2 GOLD SETUP'}
              </span>
              <span className="text-[11px] text-white/50">
                {currentPlayer === 'p1' ? 'Tap bottom 4 rows' : 'Tap top 4 rows'}
              </span>
            </div>

            {/* Selection Buttons */}
            <div className="flex items-center gap-2">
              <button
                onClick={() => {
                  setSetupItemType('piece');
                  setSelectedTrapCard(null);
                }}
                className={`flex-1 py-2 px-3 rounded-lg text-xs font-mono border transition ${
                  setupItemType === 'piece'
                    ? 'bg-[#0096C7]/20 border-[#0096C7] text-white font-bold'
                    : 'bg-[#0C0F1D] border-[#2C324A] text-white/60'
                }`}
              >
                Pieces ({players[currentPlayer].piecesToPlace})
              </button>

              <button
                onClick={() => {
                  setSetupItemType('flag');
                  setSelectedTrapCard(null);
                }}
                className={`flex-1 py-2 px-3 rounded-lg text-xs font-mono border transition ${
                  setupItemType === 'flag'
                    ? 'bg-[#0096C7]/20 border-[#0096C7] text-white font-bold'
                    : 'bg-[#0C0F1D] border-[#2C324A] text-white/60'
                }`}
              >
                Flag ({players[currentPlayer].flagPlaced ? '0' : '1'})
              </button>
            </div>

            {/* Traps Deck */}
            <div>
              <span className="text-[11px] font-mono text-white/60 block mb-1.5">
                Trap Cards (Tap to arm):
              </span>
              <div className="flex gap-2 overflow-x-auto pb-1">
                {players[currentPlayer].unplacedTraps.map(card => {
                  const isSelected = selectedTrapCard?.id === card.id;
                  return (
                    <button
                      key={card.id}
                      onClick={() => {
                        setSetupItemType('trap');
                        setSelectedTrapCard(card);
                      }}
                      className={`px-3 py-1.5 rounded border text-xs font-mono font-bold transition ${
                        isSelected
                          ? 'bg-red-500/30 border-red-500 text-white shadow-[0_0_10px_red]'
                          : 'bg-[#0C0F1D] border-[#2C324A] text-white/70 hover:text-white'
                      }`}
                    >
                      Trap [{card.value}]
                    </button>
                  );
                })}
              </div>
            </div>

            {/* Complete Setup Action */}
            <button
              onClick={completeSetup}
              disabled={
                players[currentPlayer].piecesToPlace > 0 ||
                players[currentPlayer].unplacedTraps.length > 0 ||
                !players[currentPlayer].flagPlaced
              }
              className="w-full py-2.5 rounded-xl bg-[#0096C7] hover:bg-[#0082ad] disabled:opacity-30 disabled:cursor-not-allowed text-white text-xs font-bold font-mono transition shadow-[0_0_15px_rgba(0,150,199,0.3)]"
            >
              COMPLETE SETUP → NEXT
            </button>
          </div>
        )}

        {/* Playing Phase Controls */}
        {phase === 'playing' && (
          <div className="p-4 bg-[#16192B] border border-[#2C324A] rounded-xl space-y-3">
            {turnPhase === 'rollForMovement' ? (
              <div className="text-center py-2">
                <button
                  onClick={rollMovementDice}
                  className="px-6 py-3 rounded-xl bg-gradient-to-r from-[#5300FF] to-[#0096C7] hover:opacity-90 text-white text-xs font-bold font-mono shadow-[0_0_20px_rgba(83,0,255,0.4)] flex items-center justify-center gap-2 mx-auto transition"
                >
                  <Dices className="w-4 h-4" />
                  <span>ROLL D12 FOR MOVEMENT</span>
                </button>
              </div>
            ) : (
              <div className="space-y-3">
                <div className="flex items-center justify-between text-xs font-mono">
                  <span className="text-white">
                    Movement Points Left: <strong className="text-[#0096C7]">{movementPointsLeft}</strong>
                  </span>
                  <span className="text-white/60">
                    {selectedPiece ? 'Tap adjacent square to move' : 'Select a piece to move'}
                  </span>
                </div>

                <div className="flex justify-end">
                  <button
                    onClick={endTurn}
                    className="px-4 py-2 rounded-xl bg-[#2C324A] hover:bg-[#38405e] text-white text-xs font-mono font-semibold transition"
                  >
                    End Turn →
                  </button>
                </div>
              </div>
            )}

            {/* Combat / Trap Event Logs */}
            {combatLogs.length > 0 && (
              <div className="pt-2 border-t border-[#2C324A] text-[11px] font-mono text-white/70 space-y-1">
                {combatLogs.slice(-2).map((log, i) => (
                  <div key={i} className="text-[#D4AF37]">
                    • {log}
                  </div>
                ))}
              </div>
            )}
          </div>
        )}

        {/* Game Over Modal / Panel */}
        {phase === 'gameOver' && (
          <div className="p-6 bg-[#16192B] border border-[#0096C7] rounded-xl text-center space-y-3 shadow-[0_0_25px_rgba(0,150,199,0.3)]">
            <Trophy className="w-12 h-12 text-[#D4AF37] mx-auto animate-bounce" />
            <h3 className="font-display font-bold text-xl text-white">GAME OVER</h3>
            <p className="font-mono text-sm text-[#0096C7] font-bold">
              {winner === 'p1' ? 'PLAYER 1 (CYAN) WINS!' : 'PLAYER 2 (GOLD) WINS!'}
            </p>
            <button
              onClick={resetGame}
              className="px-6 py-2.5 rounded-xl bg-[#0096C7] hover:bg-[#0082ad] text-white text-xs font-bold font-mono transition"
            >
              Play Again
            </button>
          </div>
        )}

        {/* Roll Modal for Traps & Combat */}
        {activeRollModal && (
          <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/80 backdrop-blur-sm animate-fade-in">
            <div className="w-full max-w-sm bg-[#16192B] border border-[#2C324A] rounded-2xl p-6 text-center space-y-4 shadow-[0_0_30px_rgba(231,76,60,0.4)]">
              {activeRollModal.type === 'trap' ? (
                <ShieldAlert className="w-12 h-12 text-red-500 mx-auto animate-pulse" />
              ) : (
                <Swords className="w-12 h-12 text-orange-500 mx-auto animate-pulse" />
              )}
              <h3 className="font-display font-bold text-base text-white">{activeRollModal.title}</h3>
              <p className="text-xs text-white/70 leading-relaxed">{activeRollModal.details}</p>

              <button
                onClick={() => {
                  const r1 = Math.floor(Math.random() * 12) + 1;
                  const r2 = Math.floor(Math.random() * 12) + 1;
                  activeRollModal.onResolve(r1, r2);
                }}
                className="w-full py-3 rounded-xl bg-gradient-to-r from-red-600 to-orange-500 hover:opacity-90 text-white font-mono text-xs font-bold shadow-lg transition"
              >
                ROLL DICE TO RESOLVE
              </button>
            </div>
          </div>
        )}
      </div>
    </div>
  );
};
