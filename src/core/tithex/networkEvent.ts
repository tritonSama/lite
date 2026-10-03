// TitheX / Fluoridian Core Event Envelope Schema (Pillar 3)
// Corresponds to docs/ENGINE_ARCHITECTURE.md and third_party/tithX

export type NetworkEventType =
  | 'TASK_CREATED'
  | 'MARKETPLACE_BID'
  | 'TASK_VERIFIED'
  | 'TASK_DISPUTED'
  | 'ESCROW_LOCKED'
  | 'ESCROW_RELEASED'
  | 'WAR_DECLARED'
  | 'WAR_VICTORY'
  | 'PROOF_OF_HEALTH'
  | 'CREDENTIAL_ATTESTED'
  | 'GUILD_MEMBERSHIP';

export interface NetworkEvent<T = any> {
  id: string; // SHA-256 Hash of the payload + timestamp
  did: string; // Decentralized ID of the creator (e.g. did:nexus:ed25519:...)
  eventType: NetworkEventType;
  payload: T; // Strongly-typed JSON payload
  signature: string; // Cryptographic signature from MobileVaultSdk
  createdAt: string; // ISO-8601 UTC timestamp
  blockHeight?: number; // On-chain settlement confirmation block
  relayedBy?: string; // P2P gossip peer address
}

export interface EscrowTransaction {
  txHash: string;
  taskId: string;
  totalBounty: number;
  workerAllocation: number; // 90%
  titheTreasuryAllocation: number; // 10%
  status: 'PENDING' | 'LOCKED' | 'RELEASED' | 'DISPUTED';
  creatorDid: string;
  providerDid?: string;
  timestamp: string;
  signature: string;
}

export interface ProofOfHealthTelemetry {
  nodeId: string;
  did: string;
  uptimeSeconds: number;
  cpuLoadPercent: number;
  gpuLoadPercent: number;
  memoryUsedMb: number;
  memoryTotalMb: number;
  thermalTempC: number;
  clusterHashRate: number; // MH/s
  healthScore: number; // 0 - 100
  timestamp: string;
}
