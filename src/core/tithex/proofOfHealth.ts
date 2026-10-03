// Proof of Health (PoH) Telemetry Daemon
import { ProofOfHealthTelemetry, NetworkEvent } from './networkEvent';
import { MobileVaultSdk } from './vaultSdk';

export type PoHListener = (telemetry: ProofOfHealthTelemetry) => void;

export class ProofOfHealthDaemon {
  private static instance: ProofOfHealthDaemon;
  private isRunning: boolean = false;
  private intervalId: number | null = null;
  private listeners: PoHListener[] = [];
  private currentTelemetry: ProofOfHealthTelemetry;

  private constructor() {
    const vault = MobileVaultSdk.getInstance();
    this.currentTelemetry = {
      nodeId: `node-${vault.getPublicKey().slice(0, 8)}`,
      did: vault.getDid(),
      uptimeSeconds: 14820,
      cpuLoadPercent: 24,
      gpuLoadPercent: 38,
      memoryUsedMb: 4120,
      memoryTotalMb: 16384,
      thermalTempC: 46.2,
      clusterHashRate: 48.5,
      healthScore: 98,
      timestamp: new Date().toISOString(),
    };
  }

  public static getInstance(): ProofOfHealthDaemon {
    if (!ProofOfHealthDaemon.instance) {
      ProofOfHealthDaemon.instance = new ProofOfHealthDaemon();
    }
    return ProofOfHealthDaemon.instance;
  }

  public getTelemetry(): ProofOfHealthTelemetry {
    return { ...this.currentTelemetry };
  }

  public isDaemonActive(): boolean {
    return this.isRunning;
  }

  public startDaemon() {
    if (this.isRunning) return;
    this.isRunning = true;

    this.intervalId = window.setInterval(() => {
      // Simulate real-time hardware fluctuations
      const cpuDelta = (Math.random() - 0.5) * 8;
      const gpuDelta = (Math.random() - 0.5) * 12;
      const tempDelta = (Math.random() - 0.5) * 1.5;

      const cpu = Math.max(10, Math.min(95, Math.round(this.currentTelemetry.cpuLoadPercent + cpuDelta)));
      const gpu = Math.max(15, Math.min(98, Math.round(this.currentTelemetry.gpuLoadPercent + gpuDelta)));
      const temp = +(Math.max(38, Math.min(82, this.currentTelemetry.thermalTempC + tempDelta)).toFixed(1));
      const hashRate = +(45 + (gpu / 100) * 20).toFixed(1);
      const healthScore = Math.max(85, Math.min(100, Math.round(100 - (temp > 70 ? (temp - 70) * 1.5 : 0))));

      this.currentTelemetry = {
        ...this.currentTelemetry,
        uptimeSeconds: this.currentTelemetry.uptimeSeconds + 3,
        cpuLoadPercent: cpu,
        gpuLoadPercent: gpu,
        thermalTempC: temp,
        clusterHashRate: hashRate,
        healthScore,
        timestamp: new Date().toISOString(),
      };

      this.notifyListeners();
    }, 3000);
  }

  public stopDaemon() {
    if (!this.isRunning) return;
    this.isRunning = false;
    if (this.intervalId !== null) {
      clearInterval(this.intervalId);
      this.intervalId = null;
    }
  }

  public subscribe(listener: PoHListener): () => void {
    this.listeners.push(listener);
    listener(this.currentTelemetry);
    return () => {
      this.listeners = this.listeners.filter(l => l !== listener);
    };
  }

  private notifyListeners() {
    this.listeners.forEach(l => l(this.currentTelemetry));
  }
}
