// TitheX Double-Entry Escrow Ledger & Staking Treasury Engine
import { EscrowTransaction } from './networkEvent';
import { MobileVaultSdk } from './vaultSdk';

export class TitheXEscrowLedger {
  private static instance: TitheXEscrowLedger;
  private transactions: EscrowTransaction[] = [];
  private totalTreasuryTithe: number = 425.0; // Seeded initial community staking pool
  private currentBlockHeight: number = 84920;

  private constructor() {
    this.loadLedger();
  }

  public static getInstance(): TitheXEscrowLedger {
    if (!TitheXEscrowLedger.instance) {
      TitheXEscrowLedger.instance = new TitheXEscrowLedger();
    }
    return TitheXEscrowLedger.instance;
  }

  private loadLedger() {
    const saved = localStorage.getItem('hb_tithex_ledger');
    if (saved) {
      try {
        this.transactions = JSON.parse(saved);
      } catch (e) {
        // initialize defaults
      }
    } else {
      // Seed historical escrow records
      this.transactions = [
        {
          txHash: '0x8f2a4c9d1e3b5a7f9c8d2e1b4a6c8e0f2a4c6e8d1b3a5c7e9f0a2c4e6b8d0a2c',
          taskId: 'task-lot-cleanup',
          totalBounty: 180.0,
          workerAllocation: 162.0, // 90%
          titheTreasuryAllocation: 18.0, // 10%
          status: 'LOCKED',
          creatorDid: 'did:nexus:ed25519:7a4c9d1e3b5a7f9c',
          timestamp: '2026-10-01T08:30:00Z',
          signature: 'ed25519:3b5a7f9c8d2e1b4a6c8e0f2a4c6e8d1b3a5c7e9f0a2c4e6b8d0a2c1e3b5a7f9c',
        },
        {
          txHash: '0x3c7e9f0a2c4e6b8d0a2c1e3b5a7f9c8d2e1b4a6c8e0f2a4c6e8d1b3a5c7e9f0a',
          taskId: 'task-obd-fleet',
          totalBounty: 240.0,
          workerAllocation: 216.0,
          titheTreasuryAllocation: 24.0,
          status: 'LOCKED',
          creatorDid: 'did:nexus:ed25519:8d2e1b4a6c8e0f2a',
          timestamp: '2026-10-01T10:15:00Z',
          signature: 'ed25519:6e8d1b3a5c7e9f0a2c4e6b8d0a2c1e3b5a7f9c8d2e1b4a6c8e0f2a4c6e8d1b3a',
        },
      ];
      this.saveLedger();
    }
  }

  private saveLedger() {
    localStorage.setItem('hb_tithex_ledger', JSON.stringify(this.transactions));
  }

  public getTransactions(): EscrowTransaction[] {
    return [...this.transactions];
  }

  public getBlockHeight(): number {
    return this.currentBlockHeight;
  }

  public getTotalTreasuryTithe(): number {
    return this.totalTreasuryTithe;
  }

  /**
   * Initializes smart contract escrow for a newly posted task
   */
  public async lockEscrow(
    taskId: string,
    totalBounty: number,
    creatorDid: string
  ): Promise<EscrowTransaction> {
    const workerAllocation = +(totalBounty * 0.9).toFixed(2);
    const titheTreasuryAllocation = +(totalBounty * 0.1).toFixed(2);

    const vault = MobileVaultSdk.getInstance();
    const payload = {
      taskId,
      totalBounty,
      workerAllocation,
      titheTreasuryAllocation,
      action: 'LOCK_ESCROW',
      block: ++this.currentBlockHeight,
    };

    const { signature, payloadHash } = await vault.signPayload(payload);
    const txHash = `0x${payloadHash}`;

    const tx: EscrowTransaction = {
      txHash,
      taskId,
      totalBounty,
      workerAllocation,
      titheTreasuryAllocation,
      status: 'LOCKED',
      creatorDid,
      timestamp: new Date().toISOString(),
      signature,
    };

    this.transactions.unshift(tx);
    this.totalTreasuryTithe += titheTreasuryAllocation;
    this.saveLedger();

    return tx;
  }

  /**
   * Releases escrow to worker upon creator verification approval
   */
  public async releaseEscrow(
    taskId: string,
    providerDid: string
  ): Promise<EscrowTransaction | null> {
    const tx = this.transactions.find(t => t.taskId === taskId);
    if (!tx) return null;

    tx.status = 'RELEASED';
    tx.providerDid = providerDid;
    this.currentBlockHeight += 1;
    this.saveLedger();

    return tx;
  }

  /**
   * Marks escrow as disputed
   */
  public async disputeEscrow(taskId: string): Promise<EscrowTransaction | null> {
    const tx = this.transactions.find(t => t.taskId === taskId);
    if (!tx) return null;

    tx.status = 'DISPUTED';
    this.saveLedger();

    return tx;
  }
}
