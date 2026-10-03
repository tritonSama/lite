import React from 'react';
import { Task } from '../types';
import { 
  X, 
  MapPin, 
  Calendar, 
  Users, 
  ShieldCheck, 
  DollarSign, 
  FileText, 
  Tag, 
  Gavel, 
  CheckCircle2 
} from 'lucide-react';

interface TaskDetailModalProps {
  task: Task | null;
  isOpen: boolean;
  onClose: () => void;
  onOpenMakeOffer: (task: Task) => void;
  onOpenVerify: (task: Task) => void;
}

export const TaskDetailModal: React.FC<TaskDetailModalProps> = ({
  task,
  isOpen,
  onClose,
  onOpenMakeOffer,
  onOpenVerify,
}) => {
  if (!isOpen || !task) return null;

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/75 backdrop-blur-md animate-fade-in">
      <div 
        className="w-full max-w-xl bg-[#16192B] border border-[#2C324A] rounded-2xl shadow-[0_0_35px_rgba(0,150,199,0.3)] overflow-hidden flex flex-col max-h-[90vh]"
        onClick={e => e.stopPropagation()}
      >
        {/* Header */}
        <div className="flex items-center justify-between px-6 py-4 border-b border-[#2C324A] bg-[#0C0F1D]">
          <div className="flex items-center gap-2">
            <span className="text-xs font-mono px-2 py-0.5 rounded bg-[#0096C7]/20 text-[#0096C7] font-semibold border border-[#0096C7]/30">
              {task.category}
            </span>
            <span className="text-xs font-mono px-2 py-0.5 rounded bg-[#D4AF37]/20 text-[#D4AF37] font-semibold border border-[#D4AF37]/30">
              STATUS: {task.status.toUpperCase()}
            </span>
          </div>
          <button onClick={onClose} className="p-1.5 text-white/50 hover:text-white rounded-lg">
            <X className="w-5 h-5" />
          </button>
        </div>

        {/* Body */}
        <div className="p-6 overflow-y-auto space-y-5 flex-1">
          {/* Bounty Hero Card */}
          <div className="p-5 rounded-xl bg-gradient-to-r from-[#D4AF37]/15 via-[#16192B] to-[#0096C7]/15 border border-[#D4AF37]/40 flex items-center justify-between shadow-[0_0_20px_rgba(212,175,55,0.15)]">
            <div>
              <span className="text-xs font-mono uppercase tracking-wider text-white/60">
                Guaranteed Escrow Bounty
              </span>
              <div className="text-3xl font-mono font-bold text-[#D4AF37] mt-0.5">
                ${task.budgetAmount} <span className="text-xs font-normal text-white/60">USD</span>
              </div>
            </div>
            <div className="text-right text-xs font-mono text-white/60">
              <div>BIDS: <span className="text-white font-bold">{task.bidCount}</span></div>
              <div className="text-[#0096C7] mt-0.5">Fluoridian Escrow Active</div>
            </div>
          </div>

          {/* Title & Description */}
          <div>
            <h2 className="font-display font-bold text-xl text-white mb-2">
              {task.title}
            </h2>
            <p className="text-xs text-white/80 leading-relaxed whitespace-pre-line bg-[#0C0F1D] p-3.5 rounded-xl border border-[#2C324A]">
              {task.description}
            </p>
          </div>

          {/* Logistics Grid */}
          <div className="grid grid-cols-2 gap-3 text-xs">
            <div className="p-3 rounded-xl bg-[#0C0F1D] border border-[#2C324A] flex items-center gap-2.5">
              <MapPin className="w-4 h-4 text-[#0096C7] shrink-0" />
              <div>
                <span className="text-white/40 block text-[10px]">LOCATION</span>
                <span className="font-semibold text-white">{task.locationLabel}</span>
              </div>
            </div>

            <div className="p-3 rounded-xl bg-[#0C0F1D] border border-[#2C324A] flex items-center gap-2.5">
              <Calendar className="w-4 h-4 text-[#0096C7] shrink-0" />
              <div>
                <span className="text-white/40 block text-[10px]">DUE DATE</span>
                <span className="font-semibold text-white">{task.desiredCompletionDate}</span>
              </div>
            </div>

            <div className="p-3 rounded-xl bg-[#0C0F1D] border border-[#2C324A] flex items-center gap-2.5">
              <Users className="w-4 h-4 text-[#0096C7] shrink-0" />
              <div>
                <span className="text-white/40 block text-[10px]">WORKERS NEEDED</span>
                <span className="font-semibold text-white">{task.workerCount} Provider(s)</span>
              </div>
            </div>

            <div className="p-3 rounded-xl bg-[#0C0F1D] border border-[#2C324A] flex items-center gap-2.5">
              <ShieldCheck className="w-4 h-4 text-[#0096C7] shrink-0" />
              <div>
                <span className="text-white/40 block text-[10px]">VERIFIED ID</span>
                <span className="font-semibold text-white">{task.requireId ? 'Mandatory' : 'Optional'}</span>
              </div>
            </div>
          </div>

          {/* Required Skills */}
          {task.requiredSkills && task.requiredSkills.length > 0 && (
            <div>
              <span className="text-xs font-semibold text-white/70 uppercase tracking-wider block mb-2">
                Required Skills & Certifications
              </span>
              <div className="flex flex-wrap gap-2">
                {task.requiredSkills.map(skill => (
                  <span
                    key={skill}
                    className="px-3 py-1 rounded-lg bg-[#0C0F1D] border border-[#0096C7]/40 text-xs text-white"
                  >
                    {skill}
                  </span>
                ))}
              </div>
            </div>
          )}
        </div>

        {/* Footer Actions */}
        <div className="px-6 py-4 border-t border-[#2C324A] bg-[#0C0F1D] flex items-center justify-between">
          <button
            onClick={() => {
              onClose();
              onOpenVerify(task);
            }}
            className="flex items-center gap-1.5 px-4 py-2 rounded-xl border border-[#0096C7]/50 text-[#4DBBDF] hover:bg-[#0096C7]/10 text-xs font-semibold transition"
          >
            <CheckCircle2 className="w-4 h-4" />
            <span>Verify / Proof of Work</span>
          </button>

          <button
            onClick={() => {
              onClose();
              onOpenMakeOffer(task);
            }}
            className="flex items-center gap-1.5 px-6 py-2.5 rounded-xl bg-[#D4AF37] hover:bg-[#c29e2f] text-black text-xs font-bold shadow-[0_0_15px_rgba(212,175,55,0.4)] transition"
          >
            <Gavel className="w-4 h-4" />
            <span>Make Offer / Place Bid</span>
          </button>
        </div>
      </div>
    </div>
  );
};
