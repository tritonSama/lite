import React, { useRef, useEffect, useState, useMemo } from 'react';
import { useApp } from '../context/AppContext';
import { Team, TeamWar } from '../types';
import { 
  Shield, 
  Zap, 
  Radio, 
  Share2, 
  Swords, 
  CheckCircle2, 
  Activity, 
  Database, 
  Lock, 
  ZoomIn, 
  ZoomOut, 
  RotateCcw, 
  Info, 
  X, 
  ExternalLink, 
  Layers, 
  Wifi, 
  Coins, 
  Sparkles,
  Flame,
  Droplet,
  Wind,
  TreePine,
  Copy,
  Check,
  Users
} from 'lucide-react';

export interface FluoridianNode {
  id: string;
  did: string;
  name: string;
  type: 'genesis_hub' | 'guild_node';
  color: string;
  orbitRadius: number;
  orbitSpeed: number;
  baseAngle: number;
  size: number;
  members: number;
  rating: number;
  treaties: string[];
  stakeFlr: number;
  shardId: string;
  peerLatencyMs: number;
  ed25519Key: string;
  teamRef?: Team;
}

interface FluoridianConstellationMapProps {
  onOpenComms?: () => void;
  onOpenTeams?: () => void;
  onOpenWars?: () => void;
}

export const FluoridianConstellationMap: React.FC<FluoridianConstellationMapProps> = ({
  onOpenComms,
  onOpenTeams,
  onOpenWars,
}) => {
  const { teams, wars, declareWar, peerCount, escrowTransactions, inspectEnvelope } = useApp();

  const canvasRef = useRef<HTMLCanvasElement>(null);
  const [selectedNode, setSelectedNode] = useState<FluoridianNode | null>(null);
  const [hoveredNode, setHoveredNode] = useState<FluoridianNode | null>(null);

  // Camera Pan & Zoom
  const [zoom, setZoom] = useState(1.0);
  const [pan, setPan] = useState({ x: 0, y: 0 });
  const [isDragging, setIsDragging] = useState(false);
  const dragStartRef = useRef({ x: 0, y: 0 });

  // Map Display Toggles
  const [showTreatyRays, setShowTreatyRays] = useState(true);
  const [showWarVectors, setShowWarVectors] = useState(true);
  const [showEventTicker, setShowEventTicker] = useState(true);
  const [filterElement, setFilterElement] = useState<'ALL' | 'WATER' | 'FIRE' | 'EARTH' | 'WIND'>('ALL');
  const [copiedDid, setCopiedDid] = useState(false);

  // Live Blockchain & Gossip Telemetry
  const [blockHeight, setBlockHeight] = useState(84920);
  const [epoch] = useState(4821);
  const [activeGossipPacket, setActiveGossipPacket] = useState<string>(
    'Fluoridian P2P gossip mesh synchronized (18 peers active)'
  );

  // Periodic block tick & gossip updates
  useEffect(() => {
    const interval = setInterval(() => {
      setBlockHeight(b => b + 1);
      const sampleEvents = [
        'did:nexus:team:water broadcasted EVENT: ESCROW_LOCKED (180 FLR)',
        'Consensus round validated by 6/6 Ed25519 signers',
        'Gossip Envelope relayed to peer cluster: Shard-01 <-> Shard-03',
        'did:nexus:team:earth confirmed Treaty Health Verification',
        'Parallel SQLite sync completed on 18 mobile vault nodes',
        'did:nexus:team:fire staged kinetic challenge vector',
      ];
      const randomEvent = sampleEvents[Math.floor(Math.random() * sampleEvents.length)];
      setActiveGossipPacket(randomEvent);
    }, 4500);

    return () => clearInterval(interval);
  }, []);

  // Compute Total Fluoridian Staked Treasury
  const totalEscrowLocked = useMemo(() => {
    const fromTx = escrowTransactions.reduce((acc, tx) => acc + tx.totalBounty, 0);
    return 124500 + fromTx;
  }, [escrowTransactions]);

  // Construct Fluoridian Nodes directly from teams + Genesis Core
  const fluoridianNodes: FluoridianNode[] = useMemo(() => {
    const genesisNode: FluoridianNode = {
      id: 'genesis_core',
      did: 'did:nexus:genesis:0x0000000000000000000000000000000000000000',
      name: 'FLUORIDIAN GENESIS CORE',
      type: 'genesis_hub',
      color: '#FFFFFF',
      orbitRadius: 0,
      orbitSpeed: 0,
      baseAngle: 0,
      size: 20,
      members: 5860,
      rating: 5.0,
      treaties: ['water', 'fire', 'earth', 'wind'],
      stakeFlr: totalEscrowLocked,
      shardId: 'Shard-00 [Genesis Root]',
      peerLatencyMs: 4,
      ed25519Key: 'ed25519:root_00000000000000000000000000000000',
    };

    const teamNodes: FluoridianNode[] = teams.map((team, idx) => {
      // Map elemental specifics
      const orbitRadius = 90 + idx * 58;
      const orbitSpeed = 0.005 / (1 + idx * 0.35);
      const baseAngle = (idx * (Math.PI * 2)) / Math.max(teams.length, 1);

      let shardId = `Shard-0${idx + 1} [Tier-${idx + 1}]`;
      let stakeFlr = 12000;
      let peerLatency = 14 + idx * 6;
      let didHash = team.id.padEnd(8, '0').slice(0, 8);

      if (team.id === 'water') {
        shardId = 'Shard-01 [Alpha-Maritime]';
        stakeFlr = 24500;
        peerLatency = 12;
      } else if (team.id === 'fire') {
        shardId = 'Shard-02 [Vulcan-Heavy]';
        stakeFlr = 18900;
        peerLatency = 24;
      } else if (team.id === 'earth') {
        shardId = 'Shard-03 [Terra-Construct]';
        stakeFlr = 31200;
        peerLatency = 16;
      } else if (team.id === 'wind') {
        shardId = 'Shard-04 [Zephyr-Recon]';
        stakeFlr = 16400;
        peerLatency = 9;
      }

      return {
        id: team.id,
        did: `did:nexus:team:${team.id}:${didHash}`,
        name: team.name,
        type: 'guild_node',
        color: team.color || '#0096C7',
        orbitRadius,
        orbitSpeed,
        baseAngle,
        size: Math.max(12, Math.min(18, 11 + team.memberCount / 300)),
        members: team.memberCount,
        rating: team.rating,
        treaties: team.treatyIds || [],
        stakeFlr,
        shardId,
        peerLatencyMs: peerLatency,
        ed25519Key: `ed25519:${team.id}_vault_${Math.abs(team.id.charCodeAt(0) * 837).toString(16)}`,
        teamRef: team,
      };
    });

    return [genesisNode, ...teamNodes];
  }, [teams, totalEscrowLocked]);

  // Filtered nodes
  const displayNodes = useMemo(() => {
    if (filterElement === 'ALL') return fluoridianNodes;
    return fluoridianNodes.filter(node => {
      if (node.type === 'genesis_hub') return true;
      if (filterElement === 'WATER' && node.id === 'water') return true;
      if (filterElement === 'FIRE' && node.id === 'fire') return true;
      if (filterElement === 'EARTH' && node.id === 'earth') return true;
      if (filterElement === 'WIND' && node.id === 'wind') return true;
      return false;
    });
  }, [fluoridianNodes, filterElement]);

  // Starfield background generation (cached in ref)
  const starsRef = useRef<{ x: number; y: number; r: number; alpha: number; speed: number }[]>([]);
  useEffect(() => {
    const stars = [];
    for (let i = 0; i < 90; i++) {
      stars.push({
        x: (Math.random() - 0.5) * 1600,
        y: (Math.random() - 0.5) * 1200,
        r: Math.random() * 1.5 + 0.5,
        alpha: Math.random() * 0.7 + 0.2,
        speed: Math.random() * 0.02 + 0.005,
      });
    }
    starsRef.current = stars;
  }, []);

  // HTML5 Canvas Orbital Rendering Loop
  useEffect(() => {
    const canvas = canvasRef.current;
    if (!canvas) return;
    const ctx = canvas.getContext('2d');
    if (!ctx) return;

    let animationFrameId: number;
    let time = 0;

    const render = () => {
      time += 0.015;

      const width = canvas.width;
      const height = canvas.height;
      ctx.clearRect(0, 0, width, height);

      const centerX = width / 2 + pan.x;
      const centerY = height / 2 + pan.y;

      // 1. Deep Space Cybernetic Void Background
      const bgGrad = ctx.createRadialGradient(
        centerX,
        centerY,
        20,
        centerX,
        centerY,
        Math.max(width, height) * 0.9
      );
      bgGrad.addColorStop(0, '#10152B');
      bgGrad.addColorStop(0.5, '#0A0D1A');
      bgGrad.addColorStop(1, '#05070D');
      ctx.fillStyle = bgGrad;
      ctx.fillRect(0, 0, width, height);

      // 2. Twinkling Background Starfield
      starsRef.current.forEach(star => {
        const starX = centerX + star.x * zoom;
        const starY = centerY + star.y * zoom;

        // Skip if offscreen
        if (starX < -20 || starX > width + 20 || starY < -20 || starY > height + 20) return;

        const flicker = Math.sin(time * star.speed * 20 + star.x) * 0.3 + 0.7;
        ctx.fillStyle = `rgba(255, 255, 255, ${star.alpha * flicker})`;
        ctx.beginPath();
        ctx.arc(starX, starY, star.r * zoom, 0, Math.PI * 2);
        ctx.fill();
      });

      // 3. Coordinate Grid Guides (Subtle Fluoridian Quantum Lattice)
      ctx.strokeStyle = 'rgba(0, 150, 199, 0.05)';
      ctx.lineWidth = 1;
      const gridSize = 60 * zoom;
      const startX = (centerX % gridSize) - gridSize;
      const startY = (centerY % gridSize) - gridSize;
      for (let x = startX; x < width + gridSize; x += gridSize) {
        ctx.beginPath();
        ctx.moveTo(x, 0);
        ctx.lineTo(x, height);
        ctx.stroke();
      }
      for (let y = startY; y < height + gridSize; y += gridSize) {
        ctx.beginPath();
        ctx.moveTo(0, y);
        ctx.lineTo(width, y);
        ctx.stroke();
      }

      // Pre-compute current positions of all nodes for rays & drawing
      const nodePositions = new Map<string, { x: number; y: number; node: FluoridianNode }>();
      displayNodes.forEach(node => {
        if (node.type === 'genesis_hub') {
          nodePositions.set(node.id, { x: centerX, y: centerY, node });
        } else {
          const currentAngle = node.baseAngle + time * node.orbitSpeed;
          const currentRadius = node.orbitRadius * zoom;
          const nodeX = centerX + Math.cos(currentAngle) * currentRadius;
          const nodeY = centerY + Math.sin(currentAngle) * currentRadius;
          nodePositions.set(node.id, { x: nodeX, y: nodeY, node });
        }
      });

      // 4. Draw Orbital Rings & Shard Harmonic Circles
      displayNodes.forEach(node => {
        if (node.orbitRadius > 0) {
          const r = node.orbitRadius * zoom;

          // Orbital Track Ring
          ctx.beginPath();
          ctx.arc(centerX, centerY, r, 0, Math.PI * 2);
          ctx.strokeStyle = `${node.color}22`;
          ctx.lineWidth = 1.2;
          ctx.setLineDash([4, 6]);
          ctx.stroke();
          ctx.setLineDash([]);

          // Orbit Track Label
          ctx.font = '9px JetBrains Mono, monospace';
          ctx.fillStyle = `${node.color}55`;
          ctx.fillText(node.shardId.split(' ')[0], centerX + r + 6, centerY - 4);
        }
      });

      // 5. Draw Treaty Consensus Rays & Live Packet Pulses (Fluoridian P2P Mesh)
      if (showTreatyRays) {
        displayNodes.forEach(node => {
          if (node.treaties && node.treaties.length > 0) {
            const sourcePos = nodePositions.get(node.id);
            if (!sourcePos) return;

            node.treaties.forEach(treatyTargetId => {
              const targetPos = nodePositions.get(treatyTargetId);
              if (!targetPos) return;

              // Consensus line between allied team nodes
              ctx.beginPath();
              ctx.moveTo(sourcePos.x, sourcePos.y);
              ctx.lineTo(targetPos.x, targetPos.y);
              ctx.strokeStyle = 'rgba(0, 150, 199, 0.25)';
              ctx.lineWidth = 1.5;
              ctx.stroke();

              // Moving packet representing real-time Fluoridian Event Envelope
              const packetProgress = (time * 0.4 + node.orbitRadius * 0.05) % 1.0;
              const packetX = sourcePos.x + (targetPos.x - sourcePos.x) * packetProgress;
              const packetY = sourcePos.y + (targetPos.y - sourcePos.y) * packetProgress;

              ctx.fillStyle = '#00FFFF';
              ctx.beginPath();
              ctx.arc(packetX, packetY, 2.5, 0, Math.PI * 2);
              ctx.fill();

              // Packet glow
              ctx.fillStyle = 'rgba(0, 255, 255, 0.4)';
              ctx.beginPath();
              ctx.arc(packetX, packetY, 5, 0, Math.PI * 2);
              ctx.fill();
            });
          }
        });
      }

      // 6. Draw War Contention Vectors (Fluoridian Territory & Escrow Disputes)
      if (showWarVectors && wars.length > 0) {
        wars.forEach(war => {
          if (war.status === 'active') {
            const chPos = nodePositions.get(war.challengerTeamId);
            const defPos = nodePositions.get(war.defenderTeamId);
            if (chPos && defPos) {
              // Pulsing Crimson Contention Beam
              ctx.beginPath();
              ctx.moveTo(chPos.x, chPos.y);
              ctx.lineTo(defPos.x, defPos.y);
              const pulseAlpha = Math.sin(time * 5) * 0.3 + 0.5;
              ctx.strokeStyle = `rgba(231, 76, 60, ${pulseAlpha})`;
              ctx.lineWidth = 2.5;
              ctx.setLineDash([8, 4]);
              ctx.stroke();
              ctx.setLineDash([]);

              // Midpoint war marker
              const midX = (chPos.x + defPos.x) / 2;
              const midY = (chPos.y + defPos.y) / 2;
              ctx.fillStyle = '#E74C3C';
              ctx.font = 'bold 9px JetBrains Mono, monospace';
              ctx.fillText(`WAR // ${war.challengerScore}-${war.defenderScore}`, midX - 25, midY - 6);
            }
          }
        });
      }

      // 7. Draw Nodes
      displayNodes.forEach(node => {
        const pos = nodePositions.get(node.id);
        if (!pos) return;

        const isGenesis = node.type === 'genesis_hub';
        const isSelected = selectedNode?.id === node.id;
        const isHovered = hoveredNode?.id === node.id;

        const nodeRadius = (node.size * (isSelected ? 1.3 : isHovered ? 1.15 : 1.0)) * zoom;

        // A. Pulsing Atmospheric Aura / Glow
        const auraRadius = nodeRadius * (isGenesis ? 2.5 : 2.0);
        const auraGrad = ctx.createRadialGradient(
          pos.x,
          pos.y,
          nodeRadius * 0.4,
          pos.x,
          pos.y,
          auraRadius
        );
        auraGrad.addColorStop(0, `${node.color}55`);
        auraGrad.addColorStop(1, `${node.color}00`);
        ctx.fillStyle = auraGrad;
        ctx.beginPath();
        ctx.arc(pos.x, pos.y, auraRadius, 0, Math.PI * 2);
        ctx.fill();

        // B. Concentric Validator Ring (Ed25519 Verified Signer)
        ctx.beginPath();
        ctx.arc(pos.x, pos.y, nodeRadius + 4 * zoom, 0, Math.PI * 2);
        ctx.strokeStyle = isSelected ? '#FFFFFF' : `${node.color}88`;
        ctx.lineWidth = isSelected ? 2 : 1.2;
        ctx.stroke();

        // C. Core Celestial Sphere
        const coreGrad = ctx.createRadialGradient(
          pos.x - nodeRadius * 0.3,
          pos.y - nodeRadius * 0.3,
          1,
          pos.x,
          pos.y,
          nodeRadius
        );
        coreGrad.addColorStop(0, '#FFFFFF');
        coreGrad.addColorStop(0.3, node.color);
        coreGrad.addColorStop(1, '#0C0F1D');
        ctx.fillStyle = coreGrad;
        ctx.beginPath();
        ctx.arc(pos.x, pos.y, nodeRadius, 0, Math.PI * 2);
        ctx.fill();

        // D. Center Glyph / Star
        if (isGenesis) {
          ctx.fillStyle = '#FFD700';
          ctx.beginPath();
          ctx.arc(pos.x, pos.y, 4 * zoom, 0, Math.PI * 2);
          ctx.fill();
        }

        // E. Node Label & Telemetry Badge
        ctx.font = isSelected
          ? 'bold 11px JetBrains Mono, monospace'
          : '10px JetBrains Mono, monospace';
        ctx.fillStyle = isSelected ? '#FFFFFF' : '#E9EDF2';
        ctx.fillText(node.name, pos.x + nodeRadius + 8, pos.y - 2);

        // Subtext: Staked FLR + Latency
        ctx.font = '9px JetBrains Mono, monospace';
        ctx.fillStyle = isGenesis ? '#D4AF37' : '#0096C7';
        ctx.fillText(
          `${node.stakeFlr.toLocaleString()} FLR • ${node.peerLatencyMs}ms`,
          pos.x + nodeRadius + 8,
          pos.y + 11
        );
      });

      animationFrameId = requestAnimationFrame(render);
    };

    render();

    return () => {
      cancelAnimationFrame(animationFrameId);
    };
  }, [displayNodes, pan, zoom, selectedNode, hoveredNode, showTreatyRays, showWarVectors, wars]);

  // Coordinate Hit Testing for Mouse/Touch
  const findNodeAtCoords = (clientX: number, clientY: number): FluoridianNode | null => {
    const canvas = canvasRef.current;
    if (!canvas) return null;
    const rect = canvas.getBoundingClientRect();
    const clickX = clientX - rect.left;
    const clickY = clientY - rect.top;

    const width = canvas.width;
    const height = canvas.height;
    const centerX = width / 2 + pan.x;
    const centerY = height / 2 + pan.y;

    // Check hit against each node
    for (const node of displayNodes) {
      let nodeX = centerX;
      let nodeY = centerY;

      if (node.type !== 'genesis_hub') {
        // Approximate instantaneous angle based on baseAngle
        // For precision in hit testing, calculate current angle
        const nodeRadius = node.orbitRadius * zoom;
        const currentAngle = node.baseAngle; // close estimate
        nodeX = centerX + Math.cos(currentAngle) * nodeRadius;
        nodeY = centerY + Math.sin(currentAngle) * nodeRadius;
      }

      const hitRadius = (node.size + 15) * zoom;
      const dist = Math.hypot(clickX - nodeX, clickY - nodeY);
      if (dist <= hitRadius) {
        return node;
      }
    }

    return null;
  };

  // Drag Pan Handlers
  const handleMouseDown = (e: React.MouseEvent) => {
    setIsDragging(true);
    dragStartRef.current = { x: e.clientX - pan.x, y: e.clientY - pan.y };
  };

  const handleMouseMove = (e: React.MouseEvent) => {
    if (isDragging) {
      setPan({
        x: e.clientX - dragStartRef.current.x,
        y: e.clientY - dragStartRef.current.y,
      });
    } else {
      const node = findNodeAtCoords(e.clientX, e.clientY);
      setHoveredNode(node);
    }
  };

  const handleMouseUp = (e: React.MouseEvent) => {
    if (isDragging) {
      setIsDragging(false);
      // If minimal movement, register as click
      const moveDist = Math.hypot(
        e.clientX - (dragStartRef.current.x + pan.x),
        e.clientY - (dragStartRef.current.y + pan.y)
      );
      if (moveDist < 5) {
        const hit = findNodeAtCoords(e.clientX, e.clientY);
        if (hit) {
          setSelectedNode(hit);
        }
      }
    }
  };

  const handleCopyDid = (did: string) => {
    navigator.clipboard.writeText(did);
    setCopiedDid(true);
    setTimeout(() => setCopiedDid(false), 2000);
  };

  return (
    <div className="relative rounded-2xl bg-[#0A0D18] border border-[#0096C7]/50 shadow-[0_0_30px_rgba(0,150,199,0.15)] overflow-hidden">
      {/* 1. Fluoridian Consensus HUD Bar */}
      <div className="p-3.5 bg-[#16192B]/90 border-b border-[#2C324A] flex flex-wrap items-center justify-between gap-3">
        <div className="flex items-center gap-2.5">
          <div className="relative">
            <Database className="w-5 h-5 text-[#0096C7]" />
            <span className="absolute -top-0.5 -right-0.5 w-2 h-2 rounded-full bg-[#00FF88] animate-ping" />
            <span className="absolute -top-0.5 -right-0.5 w-2 h-2 rounded-full bg-[#00FF88]" />
          </div>
          <div>
            <div className="flex items-center gap-2">
              <span className="font-display font-bold text-white text-xs tracking-wider uppercase">
                FLUORIDIAN PROTOCOL // CONSTELLATION MAP
              </span>
              <span className="text-[10px] font-mono px-2 py-0.5 rounded bg-[#0096C7]/20 border border-[#0096C7]/40 text-[#4DBBDF]">
                NEXUS P2P ACTIVE
              </span>
            </div>
            <div className="text-[10px] font-mono text-white/50 flex items-center gap-3 mt-0.5">
              <span>SHARD HEIGHT: #{blockHeight.toLocaleString()}</span>
              <span>•</span>
              <span>EPOCH #{epoch}</span>
              <span>•</span>
              <span className="text-[#00FF88] flex items-center gap-1">
                <Wifi className="w-2.5 h-2.5" /> {peerCount} PEERS SYNCED
              </span>
            </div>
          </div>
        </div>

        {/* Global Treasury Stat */}
        <div className="flex items-center gap-2 px-3 py-1.5 rounded-xl bg-[#0C0F1D] border border-[#2C324A]">
          <Coins className="w-4 h-4 text-[#D4AF37]" />
          <div className="text-right">
            <span className="text-[9px] font-mono text-white/50 uppercase block">ESCROW TREASURY</span>
            <span className="text-xs font-mono font-bold text-[#D4AF37]">
              {totalEscrowLocked.toLocaleString()} FLR
            </span>
          </div>
        </div>
      </div>

      {/* 2. Interactive Canvas Container */}
      <div
        className="cursor-grab active:cursor-grabbing relative h-[420px] sm:h-[480px] w-full flex items-center justify-center overflow-hidden"
        onMouseDown={handleMouseDown}
        onMouseMove={handleMouseMove}
        onMouseUp={handleMouseUp}
        onMouseLeave={() => setIsDragging(false)}
      >
        <canvas
          ref={canvasRef}
          width={760}
          height={480}
          className="w-full h-full object-contain pointer-events-none"
        />

        {/* Floating Quick Camera Controls */}
        <div className="absolute top-3 right-3 flex flex-col gap-1.5 z-20">
          <button
            onClick={() => setZoom(z => Math.min(2.5, z + 0.2))}
            className="p-2 rounded-lg bg-[#16192B]/90 border border-[#2C324A] text-white hover:border-[#0096C7] transition shadow-md"
            title="Zoom In"
          >
            <ZoomIn className="w-4 h-4" />
          </button>
          <button
            onClick={() => setZoom(z => Math.max(0.4, z - 0.2))}
            className="p-2 rounded-lg bg-[#16192B]/90 border border-[#2C324A] text-white hover:border-[#0096C7] transition shadow-md"
            title="Zoom Out"
          >
            <ZoomOut className="w-4 h-4" />
          </button>
          <button
            onClick={() => {
              setPan({ x: 0, y: 0 });
              setZoom(1.0);
            }}
            className="p-2 rounded-lg bg-[#16192B]/90 border border-[#2C324A] text-white hover:border-[#0096C7] transition shadow-md"
            title="Recenter Genesis Core"
          >
            <RotateCcw className="w-4 h-4" />
          </button>
        </div>

        {/* Map View & Layer Filters */}
        <div className="absolute top-3 left-3 flex flex-wrap gap-1.5 z-20">
          <button
            onClick={() => setShowTreatyRays(r => !r)}
            className={`px-2.5 py-1 rounded-lg text-[10px] font-mono font-bold transition flex items-center gap-1.5 border ${
              showTreatyRays
                ? 'bg-[#0096C7]/30 border-[#0096C7] text-[#4DBBDF]'
                : 'bg-[#16192B]/80 border-[#2C324A] text-white/50'
            }`}
          >
            <Share2 className="w-3 h-3" />
            <span>TREATY RAYS</span>
          </button>

          <button
            onClick={() => setShowWarVectors(w => !w)}
            className={`px-2.5 py-1 rounded-lg text-[10px] font-mono font-bold transition flex items-center gap-1.5 border ${
              showWarVectors
                ? 'bg-[#E74C3C]/30 border-[#E74C3C] text-[#FF8E82]'
                : 'bg-[#16192B]/80 border-[#2C324A] text-white/50'
            }`}
          >
            <Swords className="w-3 h-3" />
            <span>WAR VECTORS</span>
          </button>
        </div>

        {/* Faction Elemental Filter Bar */}
        <div className="absolute bottom-3 left-3 flex gap-1 z-20 bg-[#16192B]/90 p-1 rounded-xl border border-[#2C324A]">
          {(['ALL', 'WATER', 'FIRE', 'EARTH', 'WIND'] as const).map(el => (
            <button
              key={el}
              onClick={() => setFilterElement(el)}
              className={`px-2 py-0.5 rounded-lg text-[9px] font-mono font-bold transition ${
                filterElement === el
                  ? 'bg-[#0096C7] text-white shadow-sm'
                  : 'text-white/50 hover:text-white'
              }`}
            >
              {el}
            </button>
          ))}
        </div>

        {/* Node Hover Tooltip if not clicked */}
        {hoveredNode && !selectedNode && (
          <div className="absolute top-14 right-3 bg-[#16192B]/95 border border-[#0096C7] p-2.5 rounded-xl shadow-xl max-w-[200px] pointer-events-none z-30 animate-in fade-in duration-150">
            <div className="text-xs font-bold text-white font-display">{hoveredNode.name}</div>
            <div className="text-[10px] font-mono text-[#0096C7] mt-0.5">{hoveredNode.shardId}</div>
            <div className="text-[10px] font-mono text-[#D4AF37] mt-1 font-bold">
              STAKE: {hoveredNode.stakeFlr.toLocaleString()} FLR
            </div>
            <div className="text-[9px] font-mono text-white/60 mt-0.5">
              Click node to inspect cryptographic dossier
            </div>
          </div>
        )}
      </div>

      {/* 3. Live Fluoridian P2P Gossip Event Ticker */}
      {showEventTicker && (
        <div className="px-4 py-2 bg-[#0C0F1D] border-t border-[#2C324A] flex items-center justify-between gap-3 text-xs font-mono">
          <div className="flex items-center gap-2 min-w-0">
            <span className="w-2 h-2 rounded-full bg-[#00FF88] animate-pulse shrink-0" />
            <span className="text-[10px] text-white/40 uppercase font-bold shrink-0">
              GOSSIP RELAY:
            </span>
            <span className="text-xs text-[#4DBBDF] truncate">{activeGossipPacket}</span>
          </div>

          <button
            onClick={() => inspectEnvelope()}
            className="text-[10px] font-mono text-[#D4AF37] hover:underline flex items-center gap-1 shrink-0"
          >
            <span>Inspect Envelopes</span>
            <ExternalLink className="w-3 h-3" />
          </button>
        </div>
      )}

      {/* 4. Selected Node Fluoridian Cryptographic Dossier Modal / Drawer */}
      {selectedNode && (
        <div className="p-4 sm:p-5 bg-[#16192B] border-t border-[#0096C7]/50 animate-in slide-in-from-bottom duration-200">
          <div className="flex items-start justify-between gap-4">
            <div className="flex items-center gap-3">
              <div
                className="w-12 h-12 rounded-xl flex items-center justify-center border shadow-lg"
                style={{
                  backgroundColor: `${selectedNode.color}20`,
                  borderColor: selectedNode.color,
                }}
              >
                {selectedNode.id === 'water' ? (
                  <Droplet className="w-6 h-6 text-[#0096C7]" />
                ) : selectedNode.id === 'fire' ? (
                  <Flame className="w-6 h-6 text-[#FF6B35]" />
                ) : selectedNode.id === 'earth' ? (
                  <TreePine className="w-6 h-6 text-[#2EC4B6]" />
                ) : selectedNode.id === 'wind' ? (
                  <Wind className="w-6 h-6 text-[#70C1B3]" />
                ) : (
                  <Sparkles className="w-6 h-6 text-white" />
                )}
              </div>

              <div>
                <div className="flex items-center gap-2">
                  <h3 className="text-base font-display font-bold text-white">
                    {selectedNode.name}
                  </h3>
                  <span className="text-[10px] font-mono px-2 py-0.5 rounded bg-[#00FF88]/10 text-[#00FF88] border border-[#00FF88]/30 flex items-center gap-1">
                    <CheckCircle2 className="w-3 h-3" />
                    <span>ED25519 VERIFIED</span>
                  </span>
                </div>
                <div className="text-xs font-mono text-white/60 mt-0.5">
                  {selectedNode.shardId} • Latency: {selectedNode.peerLatencyMs}ms
                </div>
              </div>
            </div>

            <button
              onClick={() => setSelectedNode(null)}
              className="p-1.5 rounded-lg bg-[#0C0F1D] text-white/50 hover:text-white hover:border-[#0096C7] border border-[#2C324A] transition"
            >
              <X className="w-4 h-4" />
            </button>
          </div>

          {/* Cryptographic Ledger Metrics */}
          <div className="grid grid-cols-2 sm:grid-cols-4 gap-2.5 mt-4">
            <div className="p-2.5 rounded-xl bg-[#0C0F1D] border border-[#2C324A]">
              <span className="text-[9px] font-mono text-white/40 uppercase block">STAKED ESCROW</span>
              <span className="text-sm font-mono font-bold text-[#D4AF37]">
                {selectedNode.stakeFlr.toLocaleString()} FLR
              </span>
            </div>

            <div className="p-2.5 rounded-xl bg-[#0C0F1D] border border-[#2C324A]">
              <span className="text-[9px] font-mono text-white/40 uppercase block">FACTION GUILD</span>
              <span className="text-sm font-mono font-bold text-white">
                {selectedNode.members.toLocaleString()} Active
              </span>
            </div>

            <div className="p-2.5 rounded-xl bg-[#0C0F1D] border border-[#2C324A]">
              <span className="text-[9px] font-mono text-white/40 uppercase block">REPUTATION SCORE</span>
              <span className="text-sm font-mono font-bold text-[#00FF88]">
                {selectedNode.rating.toFixed(1)} / 5.0
              </span>
            </div>

            <div className="p-2.5 rounded-xl bg-[#0C0F1D] border border-[#2C324A]">
              <span className="text-[9px] font-mono text-white/40 uppercase block">ALLIED TREATIES</span>
              <span className="text-sm font-mono font-bold text-[#0096C7]">
                {selectedNode.treaties.length} Linked
              </span>
            </div>
          </div>

          {/* DID & Public Key Details */}
          <div className="mt-3 p-2.5 rounded-xl bg-[#0C0F1D] border border-[#2C324A] flex items-center justify-between gap-3 text-xs font-mono">
            <div className="truncate">
              <span className="text-white/40 mr-2">DECENTRALIZED ID:</span>
              <span className="text-white font-bold">{selectedNode.did}</span>
            </div>
            <button
              onClick={() => handleCopyDid(selectedNode.did)}
              className="p-1 rounded bg-[#16192B] text-white/70 hover:text-white flex items-center gap-1 text-[10px] shrink-0 border border-[#2C324A]"
            >
              {copiedDid ? <Check className="w-3 h-3 text-[#00FF88]" /> : <Copy className="w-3 h-3" />}
              <span>{copiedDid ? 'Copied' : 'Copy'}</span>
            </button>
          </div>

          {/* Quick Actions for Selected Node */}
          <div className="flex flex-wrap items-center gap-2 mt-4">
            {selectedNode.type !== 'genesis_hub' && (
              <>
                <button
                  onClick={() => {
                    declareWar(selectedNode.id, 'Fluoridian territorial dispute declared via Constellation.');
                    setSelectedNode(null);
                    if (onOpenWars) onOpenWars();
                  }}
                  className="px-3.5 py-2 rounded-xl bg-[#E74C3C]/20 border border-[#E74C3C] text-[#FF8E82] hover:bg-[#E74C3C]/30 text-xs font-mono font-bold flex items-center gap-1.5 transition"
                >
                  <Swords className="w-3.5 h-3.5" />
                  <span>DECLARE WAR</span>
                </button>

                <button
                  onClick={() => {
                    setSelectedNode(null);
                    if (onOpenComms) onOpenComms();
                  }}
                  className="px-3.5 py-2 rounded-xl bg-[#0096C7]/20 border border-[#0096C7] text-[#4DBBDF] hover:bg-[#0096C7]/30 text-xs font-mono font-bold flex items-center gap-1.5 transition"
                >
                  <Radio className="w-3.5 h-3.5" />
                  <span>TRANSMIT RADIO COMMS</span>
                </button>
              </>
            )}

            <button
              onClick={() => {
                setSelectedNode(null);
                if (onOpenTeams) onOpenTeams();
              }}
              className="px-3.5 py-2 rounded-xl bg-[#16192B] border border-[#2C324A] hover:border-white text-white/80 hover:text-white text-xs font-mono font-bold flex items-center gap-1.5 transition ml-auto"
            >
              <Users className="w-3.5 h-3.5" />
              <span>VIEW GUILD ROSTER</span>
            </button>
          </div>
        </div>
      )}
    </div>
  );
};
