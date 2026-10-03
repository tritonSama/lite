import React, { useRef, useEffect, useState } from 'react';
import { FluoderpodBridge, RenderMode, FluoderpodStats } from './fluoderpodBridge';
import { 
  Cpu, 
  Layers, 
  ZoomIn, 
  ZoomOut, 
  RotateCw, 
  Activity, 
  ChevronDown, 
  ChevronUp, 
  Eye 
} from 'lucide-react';

interface FluoderpodViewProps {
  mode?: RenderMode;
  onInitialized?: () => void;
  className?: string;
  overlay?: React.ReactNode;
  showHud?: boolean;
}

export const FluoderpodView: React.FC<FluoderpodViewProps> = ({
  mode = 'CYBERPUNK RADAR',
  onInitialized,
  className = '',
  overlay,
  showHud = true,
}) => {
  const canvasRef = useRef<HTMLCanvasElement>(null);
  const bridge = FluoderpodBridge.getInstance();

  const [stats, setStats] = useState<FluoderpodStats>(bridge.getStats());
  const [hudExpanded, setHudExpanded] = useState(false);
  const [zoom, setZoom] = useState(1.0);
  const [rotationX, setRotationX] = useState(0.25);
  const [rotationY, setRotationY] = useState(0);
  const isDraggingRef = useRef(false);
  const lastMousePosRef = useRef({ x: 0, y: 0 });

  useEffect(() => {
    bridge.setMode(mode);
    onInitialized?.();
  }, [mode, onInitialized]);

  useEffect(() => {
    const canvas = canvasRef.current;
    if (!canvas) return;
    const ctx = canvas.getContext('2d');
    if (!ctx) return;

    let animId: number;
    let tick = 0;
    let frameCount = 0;
    let lastFpsTime = performance.now();

    // Generate static stars for 3D background
    const stars = Array.from({ length: 120 }, () => ({
      x: (Math.random() - 0.5) * 800,
      y: (Math.random() - 0.5) * 600,
      z: Math.random() * 400 + 50,
      size: Math.random() * 1.8 + 0.5,
      alpha: Math.random() * 0.7 + 0.3,
    }));

    const render = () => {
      tick += 0.015;
      frameCount++;

      const now = performance.now();
      if (now - lastFpsTime >= 1000) {
        setStats(prev => ({
          ...prev,
          fps: Math.round((frameCount * 1000) / (now - lastFpsTime)),
        }));
        frameCount = 0;
        lastFpsTime = now;
      }

      const width = canvas.width;
      const height = canvas.height;
      ctx.clearRect(0, 0, width, height);

      const centerX = width / 2;
      const centerY = height / 2;

      // Draw Starfield with depth projection
      stars.forEach(star => {
        const pz = star.z * zoom;
        const px = centerX + (star.x * zoom * 150) / pz;
        const py = centerY + (star.y * zoom * 150) / pz;
        if (px >= 0 && px <= width && py >= 0 && py <= height) {
          ctx.fillStyle = `rgba(255, 255, 255, ${star.alpha * 0.7})`;
          ctx.beginPath();
          ctx.arc(px, py, star.size, 0, Math.PI * 2);
          ctx.fill();
        }
      });

      if (mode === 'CONSTELLATION 3D') {
        renderConstellation3D(ctx, centerX, centerY, tick, zoom, rotationX, rotationY);
      } else {
        renderRadarHologram(ctx, centerX, centerY, tick, zoom, mode);
      }

      animId = requestAnimationFrame(render);
    };

    render();

    return () => cancelAnimationFrame(animId);
  }, [mode, zoom, rotationX, rotationY]);

  const renderConstellation3D = (
    ctx: CanvasRenderingContext2D,
    cx: number,
    cy: number,
    tick: number,
    zoomScale: number,
    rotX: number,
    rotY: number
  ) => {
    // 3D Orbital Planets (Genesis Core + 4 Guilds)
    const planets = [
      { name: 'GENESIS CORE', r: 0, color: '#FFFFFF', size: 16, angle: 0 },
      { name: 'WATER CLAN', r: 90, color: '#0096C7', size: 12, angle: tick * 0.8 },
      { name: 'FIRE TRIBE', r: 150, color: '#FF6B35', size: 11, angle: tick * 0.5 + 2 },
      { name: 'EARTH GUILD', r: 210, color: '#2EC4B6', size: 13, angle: tick * 0.35 + 4 },
      { name: 'WIND ORDER', r: 270, color: '#70C1B3', size: 10, angle: tick * 0.25 + 5 },
    ];

    // Draw Orbit Rings with 3D tilt
    [90, 150, 210, 270].forEach(r => {
      ctx.strokeStyle = 'rgba(0, 150, 199, 0.2)';
      ctx.lineWidth = 1;
      ctx.beginPath();
      ctx.ellipse(cx, cy, r * zoomScale, r * 0.45 * zoomScale, rotX, 0, Math.PI * 2);
      ctx.stroke();
    });

    // Calculate projected 3D positions
    const projected = planets.map(p => {
      const angle = p.angle;
      const x3d = Math.cos(angle) * p.r * zoomScale;
      const z3d = Math.sin(angle) * p.r * zoomScale;
      const y3d = 0;

      // Rotate around X and Y
      const xProj = cx + x3d;
      const yProj = cy + z3d * 0.45 + (x3d * rotY * 0.1);

      return { ...p, px: xProj, py: yProj, z: z3d };
    });

    // Draw Treaty Tethers
    ctx.lineWidth = 1.5;
    ctx.strokeStyle = 'rgba(212, 175, 55, 0.4)';
    ctx.setLineDash([4, 4]);
    for (let i = 1; i < projected.length; i++) {
      const p1 = projected[i];
      const p2 = projected[i === projected.length - 1 ? 1 : i + 1];
      ctx.beginPath();
      ctx.moveTo(p1.px, p1.py);
      ctx.lineTo(p2.px, p2.py);
      ctx.stroke();
    }
    ctx.setLineDash([]);

    // Draw Planets sorted by depth
    projected.sort((a, b) => a.z - b.z);

    projected.forEach(p => {
      // Glow
      const glow = ctx.createRadialGradient(p.px, p.py, 2, p.px, p.py, p.size * 2.2);
      glow.addColorStop(0, `${p.color}aa`);
      glow.addColorStop(1, 'rgba(0,0,0,0)');
      ctx.fillStyle = glow;
      ctx.beginPath();
      ctx.arc(p.px, p.py, p.size * 2.2, 0, Math.PI * 2);
      ctx.fill();

      // Sphere
      ctx.fillStyle = p.color;
      ctx.beginPath();
      ctx.arc(p.px, p.py, p.size, 0, Math.PI * 2);
      ctx.fill();

      // Outline
      ctx.strokeStyle = '#FFFFFF';
      ctx.lineWidth = 1.5;
      ctx.stroke();

      // Name Label
      ctx.font = '10px Space Grotesk, sans-serif';
      ctx.fillStyle = '#E9EDF2';
      ctx.textAlign = 'center';
      ctx.fillText(p.name, p.px, p.py + p.size + 14);
    });
  };

  const renderRadarHologram = (
    ctx: CanvasRenderingContext2D,
    cx: number,
    cy: number,
    tick: number,
    zoomScale: number,
    renderMode: RenderMode
  ) => {
    const radius = 160 * zoomScale;
    const color = renderMode === 'TACTICAL GRID' ? '#D4AF37' : renderMode === 'SATELLITE' ? '#2EC4B6' : '#0096C7';

    // Base Sphere
    ctx.strokeStyle = color;
    ctx.lineWidth = 1.5;
    ctx.beginPath();
    ctx.arc(cx, cy, radius, 0, Math.PI * 2);
    ctx.stroke();

    ctx.beginPath();
    ctx.arc(cx, cy, radius * 0.66, 0, Math.PI * 2);
    ctx.stroke();

    ctx.beginPath();
    ctx.arc(cx, cy, radius * 0.33, 0, Math.PI * 2);
    ctx.stroke();

    // Crosshairs
    ctx.beginPath();
    ctx.moveTo(cx - radius - 15, cy);
    ctx.lineTo(cx + radius + 15, cy);
    ctx.moveTo(cx, cy - radius - 15);
    ctx.lineTo(cx, cy + radius + 15);
    ctx.stroke();

    // Rotating Sweep
    ctx.save();
    ctx.translate(cx, cy);
    ctx.rotate(tick * 1.5);
    const sweepGrad = ctx.createLinearGradient(0, 0, radius, radius);
    sweepGrad.addColorStop(0, `${color}66`);
    sweepGrad.addColorStop(1, 'rgba(0,0,0,0)');
    ctx.fillStyle = sweepGrad;
    ctx.beginPath();
    ctx.moveTo(0, 0);
    ctx.arc(0, 0, radius, 0, Math.PI * 0.5);
    ctx.closePath();
    ctx.fill();
    ctx.restore();

    // Center user point
    ctx.fillStyle = '#00FFFF';
    ctx.beginPath();
    ctx.arc(cx, cy, 6, 0, Math.PI * 2);
    ctx.fill();
  };

  const handleMouseDown = (e: React.MouseEvent) => {
    isDraggingRef.current = true;
    lastMousePosRef.current = { x: e.clientX, y: e.clientY };
  };

  const handleMouseMove = (e: React.MouseEvent) => {
    if (!isDraggingRef.current) return;
    const dx = e.clientX - lastMousePosRef.current.x;
    const dy = e.clientY - lastMousePosRef.current.y;
    lastMousePosRef.current = { x: e.clientX, y: e.clientY };

    setRotationY(prev => prev + dx * 0.008);
    setRotationX(prev => Math.max(-0.8, Math.min(0.8, prev + dy * 0.005)));
  };

  const handleMouseUp = () => {
    isDraggingRef.current = false;
  };

  return (
    <div className={`relative overflow-hidden rounded-2xl bg-[#070913] border border-[#2C324A] ${className}`}>
      {/* 3D GPU Canvas */}
      <div
        className="w-full h-full cursor-grab active:cursor-grabbing flex items-center justify-center select-none"
        onMouseDown={handleMouseDown}
        onMouseMove={handleMouseMove}
        onMouseUp={handleMouseUp}
        onMouseLeave={handleMouseUp}
      >
        <canvas
          ref={canvasRef}
          width={700}
          height={460}
          className="w-full h-full object-contain pointer-events-none"
        />
      </div>

      {/* Overlay Children */}
      {overlay && <div className="absolute inset-0 pointer-events-none">{overlay}</div>}

      {/* Fluoderpod GPU Telemetry HUD */}
      {showHud && (
        <div className="absolute top-3 left-3 z-30 font-mono text-[10px] bg-[#0C0F1D]/85 backdrop-blur-md border border-[#0096C7]/50 rounded-xl p-2.5 shadow-[0_0_15px_rgba(0,150,199,0.2)] text-white">
          <div
            onClick={() => setHudExpanded(!hudExpanded)}
            className="flex items-center justify-between gap-3 cursor-pointer select-none"
          >
            <div className="flex items-center gap-1.5 text-[#0096C7] font-bold">
              <Activity className="w-3.5 h-3.5 animate-pulse" />
              <span>FLUODERPOD GPU PIPELINE</span>
            </div>
            {hudExpanded ? <ChevronUp className="w-3.5 h-3.5" /> : <ChevronDown className="w-3.5 h-3.5" />}
          </div>

          <div className="flex items-center gap-3 mt-1.5 text-white/70">
            <span>BACKEND: <strong className="text-white">{stats.backend}</strong></span>
            <span>FPS: <strong className="text-[#00FF66]">{stats.fps}</strong></span>
          </div>

          {hudExpanded && (
            <div className="mt-2 pt-2 border-t border-[#2C324A] space-y-1 text-white/60">
              <div>DRAW CALLS: <span className="text-white">{stats.drawCalls}</span></div>
              <div>GEOMETRY: <span className="text-white">{(stats.triangles).toLocaleString()} tris</span></div>
              <div>COMPUTE CLUSTERS: <span className="text-white">{stats.activeClusters} active</span></div>
              <div>OCCLUSION CULLING: <span className="text-[#D4AF37]">{stats.cullPercentage}%</span></div>
              <div>FRAME TIME: <span className="text-white">{stats.frameTimeMs} ms</span></div>
            </div>
          )}
        </div>
      )}

      {/* Zoom / Reset Controls */}
      <div className="absolute bottom-3 right-3 flex items-center gap-1.5 z-30">
        <button
          onClick={() => setZoom(z => Math.min(2.5, z + 0.2))}
          className="p-1.5 rounded-lg bg-[#16192B]/80 border border-[#2C324A] text-white hover:border-[#0096C7]"
          title="Zoom In"
        >
          <ZoomIn className="w-3.5 h-3.5" />
        </button>
        <button
          onClick={() => setZoom(z => Math.max(0.4, z - 0.2))}
          className="p-1.5 rounded-lg bg-[#16192B]/80 border border-[#2C324A] text-white hover:border-[#0096C7]"
          title="Zoom Out"
        >
          <ZoomOut className="w-3.5 h-3.5" />
        </button>
        <button
          onClick={() => {
            setZoom(1.0);
            setRotationX(0.25);
            setRotationY(0);
          }}
          className="p-1.5 rounded-lg bg-[#16192B]/80 border border-[#2C324A] text-white hover:border-[#0096C7]"
          title="Reset Camera"
        >
          <RotateCw className="w-3.5 h-3.5" />
        </button>
      </div>
    </div>
  );
};
