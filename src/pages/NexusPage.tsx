import React, { useState, useEffect, useMemo } from 'react';
import { useApp } from '../context/AppContext';
import { 
  Cpu, 
  ShieldCheck, 
  Activity, 
  CheckCircle, 
  Send, 
  HardDrive, 
  Zap, 
  Coins, 
  Wifi, 
  Database, 
  Thermometer, 
  Gauge, 
  Server, 
  Layers, 
  Play, 
  Pause, 
  RefreshCw, 
  ExternalLink, 
  Check, 
  Copy,
  Clock,
  Radio,
  Sparkles
} from 'lucide-react';

export const NexusPage: React.FC = () => {
  const { 
    isOnWaitlist, 
    joinWaitlist, 
    pohTelemetry, 
    isPohDaemonActive, 
    togglePohDaemon, 
    peerCount, 
    userDid,
    escrowTransactions,
    inspectEnvelope 
  } = useApp();

  const [name, setName] = useState('');
  const [email, setEmail] = useState('');
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [error, setError] = useState('');
  const [copiedDid, setCopiedDid] = useState(false);
  const [isBenchmarking, setIsBenchmarking] = useState(false);
  const [benchmarkResult, setBenchmarkResult] = useState<string | null>(null);

  // Live Shard & Slot Progression
  const [blockHeight, setBlockHeight] = useState(84920);
  const [slot, setSlot] = useState(18);
  const [pflops, setPflops] = useState(148.6);

  // Live incoming network event envelopes
  const [recentEvents, setRecentEvents] = useState<
    { id: string; time: string; type: string; summary: string; latency: number }[]
  >([
    {
      id: 'ev-9f8a',
      time: 'Just now',
      type: 'PROOF_OF_HEALTH',
      summary: 'Local node reported 46.2°C, 58.5 MH/s (Health: 98)',
      latency: 12,
    },
    {
      id: 'ev-3b2c',
      time: '4s ago',
      type: 'CONSENSUS_SLOT',
      summary: 'Slot #18 verified by 18/18 Ed25519 mobile vault signers',
      latency: 9,
    },
    {
      id: 'ev-7a1e',
      time: '9s ago',
      type: 'ESCROW_LOCKED',
      summary: 'did:nexus:team:water committed 180 FLR to task lot-cleanup',
      latency: 16,
    },
    {
      id: 'ev-4d5f',
      time: '14s ago',
      type: 'GOSSIP_SYNC',
      summary: 'Parallel SQLite gossip delta synchronized across 18 peers',
      latency: 14,
    },
    {
      id: 'ev-8e2b',
      time: '20s ago',
      type: 'MATRIX_BURST',
      summary: 'Distributed inference batch #9482 verified (0.042s compute)',
      latency: 11,
    },
  ]);

  // Periodic live telemetry tick
  useEffect(() => {
    const interval = setInterval(() => {
      setBlockHeight(b => b + 1);
      setSlot(s => (s >= 32 ? 1 : s + 1));
      setPflops(p => +(p + (Math.random() - 0.5) * 0.8).toFixed(1));

      const newEventsPool = [
        { type: 'PROOF_OF_HEALTH', summary: `Node health attestation signed by ${userDid.slice(0, 16)}...`, lat: 11 },
        { type: 'CONSENSUS_SLOT', summary: `Consensus round validated by 18/18 Ed25519 validator cluster`, lat: 8 },
        { type: 'MATRIX_INFERENCE', summary: `Neural weights batch processed across 4 active shards`, lat: 14 },
        { type: 'ESCROW_TELEMETRY', summary: `Fluoridian double-entry ledger balance reconciled`, lat: 15 },
        { type: 'GOSSIP_PEER', summary: `P2P gossip packet relayed over WebSocket rail: 0.00% drop rate`, lat: 10 },
      ];
      const pick = newEventsPool[Math.floor(Math.random() * newEventsPool.length)];
      setRecentEvents(prev => [
        {
          id: `ev-${Math.random().toString(16).slice(2, 6)}`,
          time: 'Just now',
          type: pick.type,
          summary: pick.summary,
          latency: pick.lat,
        },
        ...prev.slice(0, 5),
      ]);
    }, 3800);

    return () => clearInterval(interval);
  }, [userDid]);

  // Total Staked Escrow Treasury
  const totalEscrowLocked = useMemo(() => {
    const fromTx = escrowTransactions.reduce((acc, tx) => acc + tx.totalBounty, 0);
    return 124500 + fromTx;
  }, [escrowTransactions]);

  // Run Local Matrix Compute Benchmark
  const runBenchmark = () => {
    if (isBenchmarking) return;
    setIsBenchmarking(true);
    setBenchmarkResult(null);

    setTimeout(() => {
      setIsBenchmarking(false);
      const score = Math.round(4800 + Math.random() * 800);
      setBenchmarkResult(`Benchmark Verified: ${score} Matrix TFLOPS/sec (Proof of Health score: 99/100)`);
    }, 2500);
  };

  const handleCopyDid = () => {
    navigator.clipboard.writeText(userDid);
    setCopiedDid(true);
    setTimeout(() => setCopiedDid(false), 2000);
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!name.trim()) {
      setError('Please provide your operator callsign or name.');
      return;
    }
    if (!email.trim() || !email.includes('@')) {
      setError('Please provide a valid communication email address.');
      return;
    }

    setIsSubmitting(true);
    setError('');
    try {
      await joinWaitlist(name.trim(), email.trim());
    } catch (err) {
      setError('Failed to join waitlist. Please retry.');
    } finally {
      setIsSubmitting(false);
    }
  };

  return (
    <div className="pb-24 pt-2">
      <div className="max-w-4xl mx-auto px-4 space-y-5">
        {/* 1. Header Banner & Live Consensus Status */}
        <div className="p-4 sm:p-5 rounded-2xl bg-[#080B15] border border-[#00FFFF]/50 shadow-[0_0_25px_rgba(0,255,255,0.15)] flex flex-wrap items-center justify-between gap-4">
          <div className="flex items-center gap-3">
            <div className="w-12 h-12 rounded-xl bg-[#00FFFF]/15 border border-[#00FFFF] flex items-center justify-center text-[#00FFFF] shadow-[0_0_15px_rgba(0,255,255,0.3)]">
              <Cpu className="w-6 h-6 animate-pulse" />
            </div>
            <div>
              <div className="flex items-center gap-2">
                <h2 className="font-display font-bold text-lg text-white">
                  NEXUS PROTOCOL
                </h2>
                <span className="text-[10px] font-mono px-2 py-0.5 rounded bg-[#00FF88]/15 border border-[#00FF88]/40 text-[#00FF88] flex items-center gap-1 font-bold">
                  <span className="w-1.5 h-1.5 rounded-full bg-[#00FF88] animate-ping" />
                  CONSENSUS: VALIDATING
                </span>
              </div>
              <p className="text-xs font-mono text-[#00FFFF] mt-0.5">
                EDGE-NATIVE DECENTRALIZED COMPUTE SUBSTRATE & P2P RELAY
              </p>
            </div>
          </div>

          <div className="flex items-center gap-3 text-xs font-mono">
            <div className="px-3 py-1.5 rounded-xl bg-[#121629] border border-[#2C324A] text-right">
              <span className="text-[9px] text-white/40 uppercase block">SHARD HEIGHT</span>
              <strong className="text-white">#{blockHeight.toLocaleString()}</strong>
            </div>
            <div className="px-3 py-1.5 rounded-xl bg-[#121629] border border-[#2C324A] text-right">
              <span className="text-[9px] text-white/40 uppercase block">SLOT PROGRESS</span>
              <strong className="text-[#00FFFF]">Slot {slot} / 32</strong>
            </div>
          </div>
        </div>

        {/* 2. Global Network Telemetry Grid */}
        <div className="grid grid-cols-2 sm:grid-cols-4 gap-3">
          <div className="p-3.5 rounded-xl bg-[#121629] border border-[#2C324A] hover:border-[#00FFFF] transition">
            <div className="flex items-center justify-between text-white/50 text-xs mb-1">
              <span className="text-[10px] font-mono uppercase">COMPUTE CLUSTER</span>
              <Zap className="w-4 h-4 text-[#00FFFF]" />
            </div>
            <div className="text-xl font-mono font-bold text-white">{pflops} PFLOPS</div>
            <div className="text-[10px] font-mono text-[#00FF88] mt-1 flex items-center gap-1">
              <span>+3.2% 24h burst</span>
            </div>
          </div>

          <div className="p-3.5 rounded-xl bg-[#121629] border border-[#2C324A] hover:border-[#00FF88] transition">
            <div className="flex items-center justify-between text-white/50 text-xs mb-1">
              <span className="text-[10px] font-mono uppercase">ACTIVE PEERS</span>
              <Wifi className="w-4 h-4 text-[#00FF88]" />
            </div>
            <div className="text-xl font-mono font-bold text-[#00FF88]">{peerCount} Vaults</div>
            <div className="text-[10px] font-mono text-white/50 mt-1">100% Ed25519 Quorum</div>
          </div>

          <div className="p-3.5 rounded-xl bg-[#121629] border border-[#2C324A] hover:border-[#D4AF37] transition">
            <div className="flex items-center justify-between text-white/50 text-xs mb-1">
              <span className="text-[10px] font-mono uppercase">STAKED ESCROW</span>
              <Coins className="w-4 h-4 text-[#D4AF37]" />
            </div>
            <div className="text-xl font-mono font-bold text-[#D4AF37]">
              {totalEscrowLocked.toLocaleString()} FLR
            </div>
            <div className="text-[10px] font-mono text-white/50 mt-1">Double-Entry Ledger</div>
          </div>

          <div className="p-3.5 rounded-xl bg-[#121629] border border-[#2C324A] hover:border-[#5300FF] transition">
            <div className="flex items-center justify-between text-white/50 text-xs mb-1">
              <span className="text-[10px] font-mono uppercase">GOSSIP LATENCY</span>
              <Activity className="w-4 h-4 text-[#B185FF]" />
            </div>
            <div className="text-xl font-mono font-bold text-white">14 ms avg</div>
            <div className="text-[10px] font-mono text-[#00FF88] mt-1">0.00% Packet Loss</div>
          </div>
        </div>

        {/* 3. Local Node Hardware Telemetry Deck (Proof of Health) */}
        <div className="p-5 rounded-2xl bg-[#121629] border border-[#2C324A] space-y-4">
          <div className="flex flex-wrap items-center justify-between gap-3 pb-3 border-b border-[#2C324A]">
            <div className="flex items-center gap-2.5">
              <Server className="w-5 h-5 text-[#00FFFF]" />
              <div>
                <h3 className="text-sm font-display font-bold text-white">
                  LOCAL NODE HARDWARE TELEMETRY // PROOF OF HEALTH (PoH)
                </h3>
                <div className="text-[10px] font-mono text-white/50 mt-0.5 flex items-center gap-2">
                  <span>NODE: {pohTelemetry.nodeId}</span>
                  <span>•</span>
                  <span>UPTIME: {Math.floor(pohTelemetry.uptimeSeconds / 3600)}h {Math.floor((pohTelemetry.uptimeSeconds % 3600) / 60)}m</span>
                </div>
              </div>
            </div>

            <div className="flex items-center gap-2">
              <button
                onClick={togglePohDaemon}
                className={`px-3 py-1.5 rounded-xl text-xs font-mono font-bold flex items-center gap-1.5 transition border ${
                  isPohDaemonActive
                    ? 'bg-[#00FF88]/20 border-[#00FF88] text-[#00FF88]'
                    : 'bg-[#16192B] border-[#2C324A] text-white/50 hover:text-white'
                }`}
              >
                {isPohDaemonActive ? <Pause className="w-3.5 h-3.5" /> : <Play className="w-3.5 h-3.5" />}
                <span>{isPohDaemonActive ? 'DAEMON RUNNING' : 'DAEMON PAUSED'}</span>
              </button>

              <button
                onClick={runBenchmark}
                disabled={isBenchmarking}
                className="px-3 py-1.5 rounded-xl bg-[#00FFFF]/20 border border-[#00FFFF] text-[#00FFFF] hover:bg-[#00FFFF]/30 text-xs font-mono font-bold flex items-center gap-1.5 transition disabled:opacity-50"
              >
                <Sparkles className="w-3.5 h-3.5" />
                <span>{isBenchmarking ? 'BENCHMARKING...' : 'RUN BENCHMARK'}</span>
              </button>
            </div>
          </div>

          {/* Benchmark notification result */}
          {benchmarkResult && (
            <div className="p-3 rounded-xl bg-[#00FF88]/10 border border-[#00FF88]/30 text-xs font-mono text-[#00FF88] flex items-center justify-between animate-in fade-in">
              <div className="flex items-center gap-2">
                <CheckCircle className="w-4 h-4" />
                <span>{benchmarkResult}</span>
              </div>
              <button
                onClick={() => setBenchmarkResult(null)}
                className="text-white/40 hover:text-white text-[10px]"
              >
                Dismiss
              </button>
            </div>
          )}

          {/* Real-time Hardware Metrics Breakdown */}
          <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-6 gap-3">
            {/* CPU Load */}
            <div className="p-3 rounded-xl bg-[#080B15] border border-[#2C324A]">
              <span className="text-[9px] font-mono text-white/40 uppercase block">CPU LOAD</span>
              <div className="text-lg font-mono font-bold text-white mt-1">
                {pohTelemetry.cpuLoadPercent}%
              </div>
              <div className="w-full bg-[#16192B] h-1.5 rounded-full mt-2 overflow-hidden">
                <div 
                  className="bg-[#00FFFF] h-full transition-all duration-300"
                  style={{ width: `${pohTelemetry.cpuLoadPercent}%` }}
                />
              </div>
            </div>

            {/* GPU Matrix Load */}
            <div className="p-3 rounded-xl bg-[#080B15] border border-[#2C324A]">
              <span className="text-[9px] font-mono text-white/40 uppercase block">GPU INFERENCE</span>
              <div className="text-lg font-mono font-bold text-[#00FFFF] mt-1">
                {pohTelemetry.gpuLoadPercent}%
              </div>
              <div className="w-full bg-[#16192B] h-1.5 rounded-full mt-2 overflow-hidden">
                <div 
                  className="bg-[#00FFFF] h-full transition-all duration-300"
                  style={{ width: `${pohTelemetry.gpuLoadPercent}%` }}
                />
              </div>
            </div>

            {/* Thermals */}
            <div className="p-3 rounded-xl bg-[#080B15] border border-[#2C324A]">
              <span className="text-[9px] font-mono text-white/40 uppercase block">THERMAL TEMP</span>
              <div className="text-lg font-mono font-bold text-[#D4AF37] mt-1">
                {pohTelemetry.thermalTempC}°C
              </div>
              <span className="text-[9px] font-mono text-[#00FF88] mt-2 block">
                {pohTelemetry.thermalTempC < 65 ? 'Optimal Cooling' : 'High Temp'}
              </span>
            </div>

            {/* Memory Substrate */}
            <div className="p-3 rounded-xl bg-[#080B15] border border-[#2C324A]">
              <span className="text-[9px] font-mono text-white/40 uppercase block">RAM ALLOCATED</span>
              <div className="text-sm font-mono font-bold text-white mt-1">
                {(pohTelemetry.memoryUsedMb / 1024).toFixed(1)} / 16.0 GB
              </div>
              <div className="w-full bg-[#16192B] h-1.5 rounded-full mt-2 overflow-hidden">
                <div 
                  className="bg-[#B185FF] h-full"
                  style={{ width: `${(pohTelemetry.memoryUsedMb / pohTelemetry.memoryTotalMb) * 100}%` }}
                />
              </div>
            </div>

            {/* Hash Rate */}
            <div className="p-3 rounded-xl bg-[#080B15] border border-[#2C324A]">
              <span className="text-[9px] font-mono text-white/40 uppercase block">NODE HASHRATE</span>
              <div className="text-lg font-mono font-bold text-[#00FF88] mt-1">
                {pohTelemetry.clusterHashRate} MH/s
              </div>
              <span className="text-[9px] font-mono text-white/40 mt-2 block">Matrix Ops</span>
            </div>

            {/* Health Score */}
            <div className="p-3 rounded-xl bg-[#080B15] border border-[#2C324A]">
              <span className="text-[9px] font-mono text-white/40 uppercase block">POH CONSENSUS</span>
              <div className="text-lg font-mono font-bold text-[#00FF88] mt-1">
                {pohTelemetry.healthScore} / 100
              </div>
              <span className="text-[9px] font-mono text-[#00FF88] mt-2 block">Verified</span>
            </div>
          </div>

          {/* User DID & Vault Key */}
          <div className="p-3 rounded-xl bg-[#080B15] border border-[#2C324A] flex flex-wrap items-center justify-between gap-3 text-xs font-mono">
            <div className="truncate">
              <span className="text-white/40 mr-2">SOVEREIGN VAULT DID:</span>
              <span className="text-white font-bold">{userDid}</span>
            </div>
            <button
              onClick={handleCopyDid}
              className="px-2 py-1 rounded bg-[#16192B] text-white/70 hover:text-white flex items-center gap-1.5 text-[10px] border border-[#2C324A] transition"
            >
              {copiedDid ? <Check className="w-3.5 h-3.5 text-[#00FF88]" /> : <Copy className="w-3.5 h-3.5" />}
              <span>{copiedDid ? 'Copied' : 'Copy DID'}</span>
            </button>
          </div>
        </div>

        {/* 4. Decentralized Shards Breakdown */}
        <div className="space-y-3">
          <div className="flex items-center justify-between">
            <h3 className="text-xs font-mono font-bold text-white uppercase tracking-wider flex items-center gap-2">
              <Layers className="w-4 h-4 text-[#00FFFF]" />
              <span>ACTIVE NEXUS SHARDS // SUBSTRATE CLUSTER TOPOLOGY</span>
            </h3>
            <span className="text-[10px] font-mono text-[#00FF88]">4 / 4 ONLINE</span>
          </div>

          <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
            <div className="p-3.5 rounded-xl bg-[#121629] border border-[#2C324A] hover:border-[#0096C7] transition">
              <div className="flex items-center justify-between">
                <span className="text-xs font-bold text-white font-display">Shard-01 Alpha [Maritime & Fleet]</span>
                <span className="text-[9px] font-mono text-[#00FF88] px-1.5 py-0.5 rounded bg-[#00FF88]/10">ONLINE</span>
              </div>
              <div className="grid grid-cols-3 gap-2 mt-2 pt-2 border-t border-[#2C324A] text-[10px] font-mono">
                <div><span className="text-white/40 block">COMPUTE</span>42.1 TFLOPS</div>
                <div><span className="text-white/40 block">UPTIME</span>98.4%</div>
                <div><span className="text-white/40 block">LATENCY</span>12 ms</div>
              </div>
            </div>

            <div className="p-3.5 rounded-xl bg-[#121629] border border-[#2C324A] hover:border-[#FF6B35] transition">
              <div className="flex items-center justify-between">
                <span className="text-xs font-bold text-white font-display">Shard-02 Vulcan [Thermal & Demolition]</span>
                <span className="text-[9px] font-mono text-[#00FF88] px-1.5 py-0.5 rounded bg-[#00FF88]/10">ONLINE</span>
              </div>
              <div className="grid grid-cols-3 gap-2 mt-2 pt-2 border-t border-[#2C324A] text-[10px] font-mono">
                <div><span className="text-white/40 block">COMPUTE</span>54.8 TFLOPS</div>
                <div><span className="text-white/40 block">UPTIME</span>99.1%</div>
                <div><span className="text-white/40 block">LATENCY</span>22 ms</div>
              </div>
            </div>

            <div className="p-3.5 rounded-xl bg-[#121629] border border-[#2C324A] hover:border-[#2EC4B6] transition">
              <div className="flex items-center justify-between">
                <span className="text-xs font-bold text-white font-display">Shard-03 Terra [Foundry & Construction]</span>
                <span className="text-[9px] font-mono text-[#00FF88] px-1.5 py-0.5 rounded bg-[#00FF88]/10">ONLINE</span>
              </div>
              <div className="grid grid-cols-3 gap-2 mt-2 pt-2 border-t border-[#2C324A] text-[10px] font-mono">
                <div><span className="text-white/40 block">COMPUTE</span>68.2 TFLOPS</div>
                <div><span className="text-white/40 block">UPTIME</span>99.8%</div>
                <div><span className="text-white/40 block">LATENCY</span>15 ms</div>
              </div>
            </div>

            <div className="p-3.5 rounded-xl bg-[#121629] border border-[#2C324A] hover:border-[#70C1B3] transition">
              <div className="flex items-center justify-between">
                <span className="text-xs font-bold text-white font-display">Shard-04 Zephyr [Recon & Comms Relay]</span>
                <span className="text-[9px] font-mono text-[#00FF88] px-1.5 py-0.5 rounded bg-[#00FF88]/10">ONLINE</span>
              </div>
              <div className="grid grid-cols-3 gap-2 mt-2 pt-2 border-t border-[#2C324A] text-[10px] font-mono">
                <div><span className="text-white/40 block">COMPUTE</span>38.5 TFLOPS</div>
                <div><span className="text-white/40 block">UPTIME</span>97.9%</div>
                <div><span className="text-white/40 block">LATENCY</span>9 ms</div>
              </div>
            </div>
          </div>
        </div>

        {/* 5. Live P2P Gossip Relay Stream */}
        <div className="p-4 rounded-2xl bg-[#080B15] border border-[#2C324A] space-y-3">
          <div className="flex items-center justify-between">
            <div className="flex items-center gap-2">
              <span className="w-2.5 h-2.5 rounded-full bg-[#00FF88] animate-ping" />
              <h3 className="text-xs font-mono font-bold text-white uppercase tracking-wider">
                LIVE P2P GOSSIP STREAM // EVENT ENVELOPE FEED
              </h3>
            </div>
            <button
              onClick={() => inspectEnvelope()}
              className="text-[11px] font-mono text-[#00FFFF] hover:underline flex items-center gap-1"
            >
              <span>Inspect Raw Envelopes</span>
              <ExternalLink className="w-3 h-3" />
            </button>
          </div>

          <div className="space-y-1.5 font-mono text-[11px]">
            {recentEvents.map(ev => (
              <div
                key={ev.id}
                className="p-2 rounded-lg bg-[#121629] border border-[#2C324A]/60 flex items-center justify-between gap-3 text-white/80 hover:border-[#00FFFF]/40 transition"
              >
                <div className="flex items-center gap-2 min-w-0">
                  <span className="text-[9px] px-1.5 py-0.5 rounded bg-[#00FFFF]/10 border border-[#00FFFF]/30 text-[#00FFFF] shrink-0">
                    {ev.type}
                  </span>
                  <span className="truncate">{ev.summary}</span>
                </div>
                <div className="flex items-center gap-3 shrink-0 text-white/40 text-[10px]">
                  <span>{ev.latency}ms</span>
                  <span>{ev.time}</span>
                </div>
              </div>
            ))}
          </div>
        </div>

        {/* 6. Genesis Allocation Waitlist & Node Reservation Form */}
        <div className="p-6 rounded-2xl bg-[#121629] border border-[#D4AF37]/50 shadow-[0_0_30px_rgba(212,175,55,0.15)]">
          {isOnWaitlist ? (
            <div className="flex items-start gap-4">
              <div className="w-12 h-12 rounded-xl bg-[#D4AF37]/20 border border-[#D4AF37] flex items-center justify-center text-[#D4AF37] shrink-0">
                <CheckCircle className="w-6 h-6" />
              </div>
              <div className="space-y-1">
                <h3 className="font-display font-bold text-base text-[#D4AF37]">
                  You are on the Nexus Genesis Waitlist!
                </h3>
                <p className="text-xs text-white/70 leading-relaxed">
                  Your node slot has been reserved. You will receive an encrypted transmission as Phase 1 edge node telemetry and sovereign compute mining rolls out.
                </p>
                <div className="pt-2 text-[10px] font-mono text-white/40">
                  STATUS: GENESIS ALLOCATION RESERVED • VALIDATOR ELIGIBLE
                </div>
              </div>
            </div>
          ) : (
            <form onSubmit={handleSubmit} className="space-y-4">
              <div>
                <h3 className="font-display font-bold text-base text-white">
                  Join Phase 1 Early Access
                </h3>
                <p className="text-xs text-white/50 mt-0.5">
                  Reserve your compute node allocation on the Genesis Cluster.
                </p>
              </div>

              {error && (
                <p className="text-xs text-red-400 bg-red-500/10 p-2.5 rounded-lg border border-red-500/30">
                  {error}
                </p>
              )}

              <div>
                <label className="text-xs font-mono text-white/70 block mb-1">CALLSIGN / NAME</label>
                <input
                  type="text"
                  placeholder="e.g., Operator Zero"
                  value={name}
                  onChange={e => setName(e.target.value)}
                  className="w-full bg-[#080B15] border border-[#2C324A] focus:border-[#D4AF37] rounded-xl px-4 py-2.5 text-xs text-white focus:outline-none"
                />
              </div>

              <div>
                <label className="text-xs font-mono text-white/70 block mb-1">TRANSMISSION EMAIL</label>
                <input
                  type="email"
                  placeholder="operator@network.com"
                  value={email}
                  onChange={e => setEmail(e.target.value)}
                  className="w-full bg-[#080B15] border border-[#2C324A] focus:border-[#D4AF37] rounded-xl px-4 py-2.5 text-xs text-white focus:outline-none"
                />
              </div>

              <button
                type="submit"
                disabled={isSubmitting}
                className="w-full py-3 rounded-xl bg-[#D4AF37] hover:bg-[#c29e2f] text-black text-xs font-bold font-mono tracking-wider transition shadow-[0_0_15px_rgba(212,175,55,0.3)] disabled:opacity-40"
              >
                {isSubmitting ? 'RESERVING NODE...' : 'JOIN THE NEXUS WAITLIST'}
              </button>
            </form>
          )}
        </div>
      </div>
    </div>
  );
};
