import React, { useState } from 'react';
import { useApp } from '../context/AppContext';
import { Task } from '../types';
import { 
  X, 
  Camera, 
  Upload, 
  CheckCircle, 
  AlertTriangle, 
  ShieldCheck, 
  Image as ImageIcon 
} from 'lucide-react';

interface TaskVerificationModalProps {
  task: Task | null;
  isOpen: boolean;
  onClose: () => void;
  isCreatorView?: boolean;
}

export const TaskVerificationModal: React.FC<TaskVerificationModalProps> = ({
  task,
  isOpen,
  onClose,
  isCreatorView = false,
}) => {
  const { updateTask } = useApp();
  const [proofPhotos, setProofPhotos] = useState<string[]>(
    task?.proofPhotos && task.proofPhotos.length > 0
      ? task.proofPhotos
      : ['https://images.unsplash.com/photo-1590856029826-c7a73142bbf1?w=600&auto=format&fit=crop&q=80']
  );
  const [notes, setNotes] = useState(task?.verificationNotes || 'Work completed in accordance with specs. Debris cleared and site secured.');
  const [isSubmitting, setIsSubmitting] = useState(false);

  if (!isOpen || !task) return null;

  const handleAddSamplePhoto = () => {
    const samples = [
      'https://images.unsplash.com/photo-1504307651254-35680f356dfd?w=600&auto=format&fit=crop&q=80',
      'https://images.unsplash.com/photo-1581092160607-ee22621dd758?w=600&auto=format&fit=crop&q=80',
    ];
    setProofPhotos(prev => [...prev, samples[prev.length % samples.length]]);
  };

  const handleSubmitProof = () => {
    setIsSubmitting(true);
    setTimeout(() => {
      updateTask(task.id, {
        status: 'submittedForVerification',
        proofPhotos,
        verificationNotes: notes,
      });
      setIsSubmitting(false);
      onClose();
    }, 400);
  };

  const handleReviewAction = (approve: boolean) => {
    setIsSubmitting(true);
    setTimeout(() => {
      updateTask(task.id, {
        status: approve ? 'approved' : 'disputed',
      });
      setIsSubmitting(false);
      onClose();
    }, 400);
  };

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/75 backdrop-blur-md animate-fade-in">
      <div 
        className="w-full max-w-lg bg-[#16192B] border border-[#2C324A] rounded-2xl shadow-[0_0_35px_rgba(0,150,199,0.3)] overflow-hidden flex flex-col max-h-[90vh]"
        onClick={e => e.stopPropagation()}
      >
        <div className="flex items-center justify-between px-6 py-4 border-b border-[#2C324A] bg-[#0C0F1D]">
          <div>
            <h3 className="font-display font-bold text-white text-base">
              {isCreatorView ? 'Review Work Verification' : 'Submit Proof of Work'}
            </h3>
            <p className="text-xs text-white/50">Sprint 4: Cryptographic Escrow Settlement</p>
          </div>
          <button onClick={onClose} className="p-1.5 text-white/50 hover:text-white rounded-lg">
            <X className="w-5 h-5" />
          </button>
        </div>

        <div className="p-6 overflow-y-auto space-y-4 flex-1">
          {/* Task Info Pill */}
          <div className="p-3.5 rounded-xl bg-[#0C0F1D] border border-[#2C324A]">
            <div className="flex justify-between items-center text-xs">
              <span className="font-mono text-white/50">TASK ID: {task.id}</span>
              <span className="font-mono font-bold text-[#D4AF37]">${task.budgetAmount} USD</span>
            </div>
            <p className="font-semibold text-sm text-white mt-1">{task.title}</p>
            <div className="flex items-center gap-2 mt-2 text-[11px] text-[#0096C7]">
              <ShieldCheck className="w-4 h-4" />
              <span>Evidence cryptographically sealed in Fluoridian Event Envelope</span>
            </div>
          </div>

          {/* Proof Photos */}
          <div>
            <label className="text-xs font-semibold text-white/80 uppercase tracking-wider block mb-2">
              Proof-of-Work Photographic Evidence
            </label>
            <div className="grid grid-cols-2 gap-3 mb-3">
              {proofPhotos.map((photo, i) => (
                <div key={i} className="relative group rounded-xl overflow-hidden border border-[#2C324A] aspect-video bg-[#0C0F1D]">
                  <img src={photo} alt={`Proof ${i + 1}`} className="w-full h-full object-cover" />
                  <span className="absolute bottom-1 left-2 text-[10px] font-mono bg-black/70 px-1.5 py-0.5 rounded text-white">
                    CAM #{i + 1}
                  </span>
                </div>
              ))}
            </div>

            {!isCreatorView && (
              <button
                type="button"
                onClick={handleAddSamplePhoto}
                className="w-full py-2.5 rounded-xl border border-dashed border-[#0096C7]/50 hover:border-[#0096C7] text-xs font-semibold text-[#4DBBDF] flex items-center justify-center gap-2 hover:bg-[#0096C7]/5 transition"
              >
                <Camera className="w-4 h-4" />
                <span>Add Completion Photo</span>
              </button>
            )}
          </div>

          {/* Completion Notes */}
          <div>
            <label className="text-xs font-semibold text-white/80 uppercase tracking-wider block mb-1.5">
              {isCreatorView ? 'Provider Completion Notes' : 'Provider Notes & Notes to Creator'}
            </label>
            <textarea
              rows={3}
              readOnly={isCreatorView}
              value={notes}
              onChange={e => setNotes(e.target.value)}
              placeholder="Describe work performed, equipment returned, or any special observations..."
              className="w-full bg-[#0C0F1D] border border-[#2C324A] focus:border-[#0096C7] rounded-xl px-4 py-2 text-xs text-white placeholder-white/30 focus:outline-none"
            />
          </div>
        </div>

        {/* Footer Actions */}
        <div className="px-6 py-4 border-t border-[#2C324A] bg-[#0C0F1D] flex items-center justify-end gap-3">
          <button
            type="button"
            onClick={onClose}
            className="px-4 py-2 rounded-xl border border-[#2C324A] text-white/70 hover:text-white text-xs font-semibold"
          >
            Close
          </button>

          {!isCreatorView ? (
            <button
              onClick={handleSubmitProof}
              disabled={isSubmitting}
              className="flex items-center gap-1.5 px-5 py-2.5 rounded-xl bg-[#0096C7] hover:bg-[#0082ad] text-white text-xs font-bold shadow-[0_0_15px_rgba(0,150,199,0.4)] transition"
            >
              <Upload className="w-4 h-4" />
              <span>{isSubmitting ? 'Sealing Proof...' : 'Submit for Review'}</span>
            </button>
          ) : (
            <div className="flex items-center gap-2">
              <button
                onClick={() => handleReviewAction(false)}
                disabled={isSubmitting}
                className="flex items-center gap-1.5 px-4 py-2 rounded-xl bg-[#E74C3C]/20 border border-[#E74C3C] text-[#E74C3C] hover:bg-[#E74C3C]/30 text-xs font-bold transition"
              >
                <AlertTriangle className="w-4 h-4" />
                <span>Dispute</span>
              </button>
              <button
                onClick={() => handleReviewAction(true)}
                disabled={isSubmitting}
                className="flex items-center gap-1.5 px-5 py-2 rounded-xl bg-[#0096C7] hover:bg-[#0082ad] text-white text-xs font-bold shadow-[0_0_15px_rgba(0,150,199,0.4)] transition"
              >
                <CheckCircle className="w-4 h-4" />
                <span>Approve & Release Bounty</span>
              </button>
            </div>
          )}
        </div>
      </div>
    </div>
  );
};
