import React from 'react';
import { NetworkEvent, EscrowTransaction } from '../core/tithex/networkEvent';
import { 
  X, 
  ShieldCheck, 
  Hash, 
  Coins, 
  Layers, 
  Clock, 
  CheckCircle, 
  Key 
} from 'lucide-react';

interface NetworkEventModalProps {
  isOpen: boolean;
  onClose: () => void;
  event?: NetworkEvent | null;
  escrowTx?: EscrowTransaction | null;
}

export const NetworkEventModal: React.FC<NetworkEventModalProps> = ({
  isOpen,
  onClose,
  event,
  escrowTx,
}) => {
  if (!isOpen) return null;

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/80 backdrop-blur-md animate-fade-in">
      <div 
        className="w-full max-w-lg bg-[#16192B] border border-[#0096C7] rounded-2xl p-6 space-y-4 shadow-[0_0_35px_rgba(0,150,199,0.3)] max-h-[85vh] overflow-y-auto"
        onClick={e => e.stopPropagation()}
      >
        <div className="flex items-center justify-between border-b border-[#2C324A] pb-3">
          <div className="flex items-center gap-2">
            <ShieldCheck className="w-5 h-5 text-[#0096C7]" />
            <div>
              <h3 className="font-display font-bold text-white text-base">
                TitheX Event Envelope Inspector
              </h3>
              <p className="text-[10px] font-mono text-[#D4AF37]">
                PILLAR 3: DECENTRALIZED PROTOCOL RAILS
              </p>
            </div>
          </div>
          <button onClick={onClose} className="p-1.5 text-white/50 hover:text-white rounded-lg">
            <X className="w-5 h-5" />
          </button>
        </div>

        {/* Escrow Details if present */}
        {escrowTx && (
          <div className="p-4 rounded-xl bg-[#0C0F1D] border border-[#D4AF37]/50 space-y-2">
            <div className="flex items-center justify-between">
              <span className="text-xs font-mono font-bold text-[#D4AF37] flex items-center gap-1.5">
                <Coins className="w-4 h-4" />
                DOUBLE-ENTRY ESCROW LEDGER
              </span>
              <span className="text-[10px] font-mono px-2 py-0.5 rounded bg-green-500/20 text-green-400 border border-green-500/30">
                {escrowTx.status}
              </span>
            </div>

            <div className="text-xs space-y-1 font-mono">
              <div className="flex justify-between text-white/70">
                <span>Total Escrow:</span>
                <strong className="text-white">${escrowTx.totalBounty} USD</strong>
              </div>
              <div className="flex justify-between text-white/70">
                <span>90% Worker Bounty:</span>
                <strong className="text-[#0096C7]">${escrowTx.workerAllocation} USD</strong>
              </div>
              <div className="flex justify-between text-white/70">
                <span>10% Community Tithe:</span>
                <strong className="text-[#D4AF37]">${escrowTx.titheTreasuryAllocation} USD</strong>
              </div>
              <div className="pt-2 text-[10px] text-white/40 break-all">
                TX HASH: {escrowTx.txHash}
              </div>
            </div>
          </div>
        )}

        {/* NetworkEvent Details */}
        {event ? (
          <div className="space-y-3 font-mono text-xs">
            <div className="p-3 rounded-xl bg-[#0C0F1D] border border-[#2C324A] space-y-1">
              <div className="text-[10px] text-white/50">EVENT ENVELOPE ID</div>
              <div className="text-[#0096C7] font-bold break-all">{event.id}</div>
            </div>

            <div className="p-3 rounded-xl bg-[#0C0F1D] border border-[#2C324A] space-y-1">
              <div className="text-[10px] text-white/50">SOVEREIGN DID (CREATOR)</div>
              <div className="text-white font-bold break-all">{event.did}</div>
            </div>

            <div className="grid grid-cols-2 gap-2">
              <div className="p-3 rounded-xl bg-[#0C0F1D] border border-[#2C324A]">
                <div className="text-[10px] text-white/50">EVENT TYPE</div>
                <div className="text-[#D4AF37] font-bold">{event.eventType}</div>
              </div>
              <div className="p-3 rounded-xl bg-[#0C0F1D] border border-[#2C324A]">
                <div className="text-[10px] text-white/50">CONFIRMATION BLOCK</div>
                <div className="text-white font-bold">#{event.blockHeight || 84920}</div>
              </div>
            </div>

            <div className="p-3 rounded-xl bg-[#0C0F1D] border border-[#2C324A] space-y-1">
              <div className="text-[10px] text-white/50 flex items-center gap-1">
                <Key className="w-3 h-3 text-green-400" />
                <span>ED25519 SIGNATURE</span>
              </div>
              <div className="text-white/60 text-[10px] break-all">{event.signature}</div>
            </div>

            <div className="p-3 rounded-xl bg-[#0C0F1D] border border-[#2C324A] space-y-1">
              <div className="text-[10px] text-white/50">RAW JSON PAYLOAD</div>
              <pre className="text-[10px] text-white/70 overflow-x-auto max-h-36">
                {JSON.stringify(event.payload, null, 2)}
              </pre>
            </div>
          </div>
        ) : (
          <div className="text-center py-6 text-xs text-white/50 font-mono">
            No raw event envelope loaded.
          </div>
        )}

        <div className="pt-2 flex justify-end">
          <button
            onClick={onClose}
            className="px-5 py-2 rounded-xl bg-[#0096C7] hover:bg-[#0082ad] text-white text-xs font-mono font-bold transition shadow-sm"
          >
            Close Inspector
          </button>
        </div>
      </div>
    </div>
  );
};
