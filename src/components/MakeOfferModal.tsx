import React, { useState } from 'react';
import { useApp } from '../context/AppContext';
import { Task } from '../types';
import { X, DollarSign, Send, ShieldAlert } from 'lucide-react';

interface MakeOfferModalProps {
  task: Task | null;
  isOpen: boolean;
  onClose: () => void;
}

export const MakeOfferModal: React.FC<MakeOfferModalProps> = ({ task, isOpen, onClose }) => {
  const { createOffer } = useApp();
  const [bidAmount, setBidAmount] = useState(task ? task.budgetAmount.toString() : '100');
  const [message, setMessage] = useState('');

  if (!isOpen || !task) return null;

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    const amount = parseFloat(bidAmount) || task.budgetAmount;
    createOffer(task.id, amount, message.trim());
    onClose();
  };

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/75 backdrop-blur-md animate-fade-in">
      <div 
        className="w-full max-w-md bg-[#16192B] border border-[#2C324A] rounded-2xl shadow-[0_0_30px_rgba(212,175,55,0.2)] overflow-hidden"
        onClick={e => e.stopPropagation()}
      >
        <div className="flex items-center justify-between px-6 py-4 border-b border-[#2C324A] bg-[#0C0F1D]">
          <div>
            <h3 className="font-display font-bold text-white text-base">Make Offer / Submit Bid</h3>
            <p className="text-xs text-white/50 truncate max-w-[280px]">{task.title}</p>
          </div>
          <button onClick={onClose} className="p-1.5 text-white/50 hover:text-white rounded-lg">
            <X className="w-5 h-5" />
          </button>
        </div>

        <form onSubmit={handleSubmit} className="p-6 space-y-4">
          <div>
            <div className="flex justify-between items-center mb-1.5">
              <label className="text-xs font-semibold text-white/80 uppercase tracking-wider">
                Proposed Bounty (USD)
              </label>
              <span className="text-xs text-white/40">Task Bounty: ${task.budgetAmount}</span>
            </div>
            <div className="relative">
              <span className="absolute left-3.5 top-1/2 -translate-y-1/2 text-white/50 font-bold">$</span>
              <input
                type="number"
                step="5"
                value={bidAmount}
                onChange={e => setBidAmount(e.target.value)}
                className="w-full bg-[#0C0F1D] border border-[#2C324A] focus:border-[#D4AF37] rounded-xl pl-8 pr-4 py-2.5 text-base font-mono font-bold text-white focus:outline-none"
                required
              />
            </div>
          </div>

          <div>
            <label className="text-xs font-semibold text-white/80 uppercase tracking-wider block mb-1.5">
              Proposal / Qualifications Note
            </label>
            <textarea
              rows={3}
              value={message}
              onChange={e => setMessage(e.target.value)}
              placeholder="Detail your equipment, crew availability, and experience relevant to this task..."
              className="w-full bg-[#0C0F1D] border border-[#2C324A] focus:border-[#D4AF37] rounded-xl px-4 py-2.5 text-xs text-white placeholder-white/30 focus:outline-none"
            />
          </div>

          <div className="p-3 rounded-lg bg-[#D4AF37]/10 border border-[#D4AF37]/20 flex items-start gap-2 text-xs text-white/70">
            <ShieldAlert className="w-4 h-4 text-[#D4AF37] shrink-0 mt-0.5" />
            <p className="text-[11px] leading-relaxed">
              Task creators evaluate proposals on Price + Credential Verification + Experience (not lowest price alone).
            </p>
          </div>

          <div className="flex justify-end gap-2 pt-2">
            <button
              type="button"
              onClick={onClose}
              className="px-4 py-2 rounded-xl border border-[#2C324A] text-white/70 hover:text-white text-xs font-semibold"
            >
              Cancel
            </button>
            <button
              type="submit"
              className="flex items-center gap-1.5 px-5 py-2 rounded-xl bg-[#D4AF37] hover:bg-[#c29e2f] text-black text-xs font-bold shadow-[0_0_15px_rgba(212,175,55,0.4)] transition"
            >
              <Send className="w-4 h-4" />
              <span>Submit Offer</span>
            </button>
          </div>
        </form>
      </div>
    </div>
  );
};
