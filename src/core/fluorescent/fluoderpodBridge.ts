// Fluoderpod Bridge — Pillar 2: 3D GPU Render Pipeline
// Handles batch ingestion, camera matrices, compute culling parameters, and render stats

export interface FluoderpodStats {
  backend: 'WebGPU (wgpu)' | 'WebGL 2.0 (CanvasKit)';
  fps: number;
  drawCalls: number;
  triangles: number;
  activeClusters: number;
  cullPercentage: number;
  frameTimeMs: number;
}

export interface CameraState {
  x: number;
  y: number;
  z: number;
  pitch: number;
  yaw: number;
  zoom: number;
}

export type RenderMode = 'CYBERPUNK RADAR' | 'TACTICAL GRID' | 'SATELLITE' | 'CONSTELLATION 3D';

export class FluoderpodBridge {
  private static instance: FluoderpodBridge;
  private isInitialized: boolean = false;
  private currentMode: RenderMode = 'CYBERPUNK RADAR';
  private batchBuffer: Uint8Array = new Uint8Array(0);
  private stats: FluoderpodStats = {
    backend: typeof navigator !== 'undefined' && 'gpu' in navigator ? 'WebGPU (wgpu)' : 'WebGL 2.0 (CanvasKit)',
    fps: 60,
    drawCalls: 14,
    triangles: 18420,
    activeClusters: 128,
    cullPercentage: 42.5,
    frameTimeMs: 4.8,
  };

  private camera: CameraState = {
    x: 0,
    y: 0,
    z: 250,
    pitch: 0,
    yaw: 0,
    zoom: 1.0,
  };

  private constructor() {
    this.isInitialized = true;
  }

  public static getInstance(): FluoderpodBridge {
    if (!FluoderpodBridge.instance) {
      FluoderpodBridge.instance = new FluoderpodBridge();
    }
    return FluoderpodBridge.instance;
  }

  public init(): boolean {
    this.isInitialized = true;
    return true;
  }

  public isReady(): boolean {
    return this.isInitialized;
  }

  public getStats(): FluoderpodStats {
    return { ...this.stats };
  }

  public getCamera(): CameraState {
    return { ...this.camera };
  }

  public setMode(mode: RenderMode) {
    this.currentMode = mode;
  }

  public getMode(): RenderMode {
    return this.currentMode;
  }

  /**
   * Ingests a raw byte array buffer representing GPU entity instances
   * Corresponds to `FluoderpodBridge.ingestBatch(bytes)` in Flutter
   */
  public ingestBatch(bytes: Uint8Array) {
    this.batchBuffer = bytes;
    // Calculate simulated draw metrics based on batch size
    const count = Math.max(1, Math.floor(bytes.length / 64));
    this.stats = {
      ...this.stats,
      drawCalls: Math.min(64, 8 + Math.floor(count / 2)),
      triangles: count * 1420,
      activeClusters: count * 16,
      cullPercentage: +(35 + Math.random() * 15).toFixed(1),
      frameTimeMs: +(3.2 + Math.random() * 2.1).toFixed(2),
    };
  }

  public updateCamera(updates: Partial<CameraState>) {
    this.camera = { ...this.camera, ...updates };
  }
}
