// Fluoridian Service — P2P Gossip Relay, WebSocket Sync, and Event Envelope Pipeline
import { NetworkEvent, NetworkEventType } from './networkEvent';
import { MobileVaultSdk } from './vaultSdk';
import { TitheXEscrowLedger } from './escrowLedger';

export type EventEnvelopeListener = (event: NetworkEvent) => void;

export class FluoridianService {
  private static instance: FluoridianService;
  private vault = MobileVaultSdk.getInstance();
  private escrowLedger = TitheXEscrowLedger.getInstance();
  private listeners: Map<string, EventEnvelopeListener[]> = new Map();
  private broadcastChannel: BroadcastChannel | null = null;
  private peerCount: number = 18; // Simulated active peer cluster
  private eventHistory: NetworkEvent[] = [];

  private constructor() {
    this.initBroadcastChannel();
    this.loadHistoricalEvents();
  }

  public static getInstance(): FluoridianService {
    if (!FluoridianService.instance) {
      FluoridianService.instance = new FluoridianService();
    }
    return FluoridianService.instance;
  }

  private initBroadcastChannel() {
    if (typeof window !== 'undefined' && 'BroadcastChannel' in window) {
      try {
        this.broadcastChannel = new BroadcastChannel('fluoridian_p2p_gossip');
        this.broadcastChannel.onmessage = (event) => {
          if (event.data && event.data.id) {
            this.handleIncomingEnvelope(event.data);
          }
        };
      } catch (e) {
        // BroadcastChannel unavailable
      }
    }
  }

  private loadHistoricalEvents() {
    const saved = localStorage.getItem('hb_fluoridian_events');
    if (saved) {
      try {
        this.eventHistory = JSON.parse(saved);
      } catch (e) {
        this.eventHistory = [];
      }
    }
  }

  private saveEvents() {
    localStorage.setItem(
      'hb_fluoridian_events',
      JSON.stringify(this.eventHistory.slice(0, 50))
    );
  }

  public getEventHistory(): NetworkEvent[] {
    return [...this.eventHistory];
  }

  public getPeerCount(): number {
    return this.peerCount;
  }

  /**
   * Signs a payload using MobileVaultSdk and broadcasts an Event Envelope
   */
  public async signAndBroadcast<T = any>(
    eventType: NetworkEventType,
    payload: T,
    topic: string = 'topic:global'
  ): Promise<NetworkEvent<T>> {
    const { signature, payloadHash } = await this.vault.signPayload(payload);
    const did = this.vault.getDid();
    const blockHeight = this.escrowLedger.getBlockHeight();

    const envelope: NetworkEvent<T> = {
      id: `ev-${payloadHash.slice(0, 16)}`,
      did,
      eventType,
      payload,
      signature,
      createdAt: new Date().toISOString(),
      blockHeight,
      relayedBy: 'peer-p2p-relay.nexus.internal:4001',
    };

    // Store in parallel local history
    this.eventHistory.unshift(envelope);
    this.saveEvents();

    // Broadcast across browser tabs / mock WebSocket rail
    if (this.broadcastChannel) {
      this.broadcastChannel.postMessage(envelope);
    }

    // Trigger local listeners
    this.dispatchToListeners(topic, envelope);
    this.dispatchToListeners('topic:all', envelope);

    // If task or escrow related, execute on-chain ledger logic
    if (eventType === 'TASK_CREATED') {
      const p: any = payload;
      if (p.id && p.budgetAmount) {
        await this.escrowLedger.lockEscrow(p.id, p.budgetAmount, did);
      }
    } else if (eventType === 'TASK_VERIFIED') {
      const p: any = payload;
      if (p.taskId && p.action === 'APPROVED') {
        await this.escrowLedger.releaseEscrow(p.taskId, did);
      } else if (p.taskId && p.action === 'DISPUTED') {
        await this.escrowLedger.disputeEscrow(p.taskId);
      }
    }

    return envelope;
  }

  /**
   * Subscribes to gossip topic
   */
  public subscribe(topic: string, listener: EventEnvelopeListener): () => void {
    if (!this.listeners.has(topic)) {
      this.listeners.set(topic, []);
    }
    this.listeners.get(topic)!.push(listener);

    return () => {
      const arr = this.listeners.get(topic);
      if (arr) {
        this.listeners.set(
          topic,
          arr.filter(l => l !== listener)
        );
      }
    };
  }

  private handleIncomingEnvelope(envelope: NetworkEvent) {
    if (this.eventHistory.some(e => e.id === envelope.id)) return;
    this.eventHistory.unshift(envelope);
    this.saveEvents();
    this.dispatchToListeners('topic:all', envelope);
  }

  private dispatchToListeners(topic: string, envelope: NetworkEvent) {
    const arr = this.listeners.get(topic);
    if (arr) {
      arr.forEach(fn => fn(envelope));
    }
  }
}
