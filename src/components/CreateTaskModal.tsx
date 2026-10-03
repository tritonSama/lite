import React, { useState } from 'react';
import { useApp } from '../context/AppContext';
import { TaskCategory } from '../types';
import { 
  X, 
  ArrowRight, 
  ArrowLeft, 
  CheckCircle, 
  MapPin, 
  Calendar, 
  Users, 
  Plus, 
  Trash2, 
  ShieldCheck, 
  DollarSign, 
  Coins 
} from 'lucide-react';

interface CreateTaskModalProps {
  isOpen: boolean;
  onClose: () => void;
}

export const CreateTaskModal: React.FC<CreateTaskModalProps> = ({ isOpen, onClose }) => {
  const { createTask, selectedTeamId, teams, currentUser } = useApp();
  const [currentStep, setCurrentStep] = useState(0);

  // Step 1: Basic Info
  const [title, setTitle] = useState('');
  const [category, setCategory] = useState<TaskCategory>('Home Improvement');
  const [description, setDescription] = useState('');

  // Step 2: Logistics
  const [locationLabel, setLocationLabel] = useState('Austin, TX (Local Area)');
  const [desiredDate, setDesiredDate] = useState(
    new Date(Date.now() + 86400000 * 3).toISOString().split('T')[0]
  );
  const [workerCount, setWorkerCount] = useState(1);

  // Step 3: Requirements
  const [skills, setSkills] = useState<string[]>(['General Labor']);
  const [skillInput, setSkillInput] = useState('');
  const [requireId, setRequireId] = useState(true);
  const [requireInsurance, setRequireInsurance] = useState(false);

  // Step 4: Funding & Tithe
  const [bounty, setBounty] = useState('150.00');

  const categories: TaskCategory[] = [
    'Home Improvement',
    'Logistics & Delivery',
    'Automotive & OBD',
    'Event Support',
    'Field Cleanup',
    'Tech & Hardware',
    'Service',
    'Other',
  ];

  if (!isOpen) return null;

  const handleAddSkill = () => {
    if (skillInput.trim() && !skills.includes(skillInput.trim())) {
      setSkills(prev => [...prev, skillInput.trim()]);
      setSkillInput('');
    }
  };

  const handleRemoveSkill = (skillToRemove: string) => {
    setSkills(prev => prev.filter(s => s !== skillToRemove));
  };

  const parsedBounty = parseFloat(bounty) || 100;
  const workerAllocation = (parsedBounty * 0.9).toFixed(2);
  const titheAllocation = (parsedBounty * 0.1).toFixed(2);

  const handlePublish = () => {
    const activeTeam = teams.find(t => t.id === selectedTeamId);
    createTask({
      creatorId: selectedTeamId || currentUser.id,
      creatorName: activeTeam?.name || currentUser.displayName,
      creatorTeamId: selectedTeamId || undefined,
      title: title.trim() || 'Community Task',
      description: description.trim() || 'No description provided.',
      category,
      locationLabel: locationLabel.trim() || 'Local Area',
      lat: 30.2672,
      lng: -97.7431,
      desiredCompletionDate: desiredDate,
      workerCount,
      requiredSkills: skills,
      requireId,
      requireInsurance,
      budgetAmount: parsedBounty,
      currencyCode: 'USD',
      status: 'published',
      photoUrls: ['https://images.unsplash.com/photo-1581578731548-c64695cc6952?w=600&auto=format&fit=crop&q=80'],
      listingType: 'forSale',
    });

    onClose();
  };

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/75 backdrop-blur-md animate-fade-in">
      <div 
        className="w-full max-w-xl bg-[#16192B] border border-[#2C324A] rounded-2xl shadow-[0_0_35px_rgba(0,150,199,0.25)] overflow-hidden flex flex-col max-h-[90vh]"
        onClick={e => e.stopPropagation()}
      >
        {/* Wizard Header */}
        <div className="flex items-center justify-between px-6 py-4 border-b border-[#2C324A] bg-[#0C0F1D]">
          <div>
            <h2 className="font-display font-bold text-lg text-white">Create Task Wizard</h2>
            <p className="text-xs text-white/50">Sprint 2: Multi-step task publishing & TitheX Escrow</p>
          </div>
          <button
            onClick={onClose}
            className="p-1.5 text-white/50 hover:text-white rounded-lg hover:bg-white/5 transition"
          >
            <X className="w-5 h-5" />
          </button>
        </div>

        {/* Step Indicator */}
        <div className="px-6 py-3 bg-[#111424] border-b border-[#2C324A] flex items-center justify-between">
          {[
            { label: 'Basic Info', num: 0 },
            { label: 'Logistics', num: 1 },
            { label: 'Requirements', num: 2 },
            { label: 'Escrow & Tithe', num: 3 },
            { label: 'Publish', num: 4 },
          ].map(s => {
            const isActive = currentStep === s.num;
            const isCompleted = currentStep > s.num;
            return (
              <div key={s.num} className="flex items-center gap-1.5">
                <span
                  className={`w-6 h-6 rounded-full flex items-center justify-center text-xs font-mono font-bold transition ${
                    isCompleted
                      ? 'bg-[#0096C7] text-white'
                      : isActive
                      ? 'bg-[#0096C7]/20 border border-[#0096C7] text-[#0096C7]'
                      : 'bg-white/5 text-white/40 border border-[#2C324A]'
                  }`}
                >
                  {isCompleted ? '✓' : s.num + 1}
                </span>
                <span
                  className={`text-xs hidden md:inline font-medium ${
                    isActive ? 'text-white' : 'text-white/40'
                  }`}
                >
                  {s.label}
                </span>
              </div>
            );
          })}
        </div>

        {/* Wizard Content Body */}
        <div className="p-6 overflow-y-auto flex-1 space-y-4">
          {/* STEP 0: Basic Info */}
          {currentStep === 0 && (
            <div className="space-y-4">
              <div>
                <label className="text-xs font-semibold text-white/80 uppercase tracking-wider block mb-1.5">
                  Task Title *
                </label>
                <input
                  type="text"
                  placeholder="e.g., Clear brush from vacant lot"
                  value={title}
                  onChange={e => setTitle(e.target.value)}
                  className="w-full bg-[#0C0F1D] border border-[#2C324A] focus:border-[#0096C7] rounded-xl px-4 py-2.5 text-sm text-white placeholder-white/30 focus:outline-none"
                />
              </div>

              <div>
                <label className="text-xs font-semibold text-white/80 uppercase tracking-wider block mb-1.5">
                  Category *
                </label>
                <select
                  value={category}
                  onChange={e => setCategory(e.target.value as TaskCategory)}
                  className="w-full bg-[#0C0F1D] border border-[#2C324A] focus:border-[#0096C7] rounded-xl px-4 py-2.5 text-sm text-white focus:outline-none"
                >
                  {categories.map(c => (
                    <option key={c} value={c}>
                      {c}
                    </option>
                  ))}
                </select>
              </div>

              <div>
                <label className="text-xs font-semibold text-white/80 uppercase tracking-wider block mb-1.5">
                  Detailed Description *
                </label>
                <textarea
                  rows={4}
                  placeholder="Provide comprehensive details about the work required, tools available, access instructions..."
                  value={description}
                  onChange={e => setDescription(e.target.value)}
                  className="w-full bg-[#0C0F1D] border border-[#2C324A] focus:border-[#0096C7] rounded-xl px-4 py-2.5 text-sm text-white placeholder-white/30 focus:outline-none"
                />
              </div>
            </div>
          )}

          {/* STEP 1: Logistics */}
          {currentStep === 1 && (
            <div className="space-y-4">
              <div>
                <label className="text-xs font-semibold text-white/80 uppercase tracking-wider block mb-1.5 flex items-center gap-1.5">
                  <MapPin className="w-3.5 h-3.5 text-[#0096C7]" />
                  Location / Area *
                </label>
                <input
                  type="text"
                  placeholder="City, neighborhood or address"
                  value={locationLabel}
                  onChange={e => setLocationLabel(e.target.value)}
                  className="w-full bg-[#0C0F1D] border border-[#2C324A] focus:border-[#0096C7] rounded-xl px-4 py-2.5 text-sm text-white focus:outline-none"
                />
              </div>

              <div>
                <label className="text-xs font-semibold text-white/80 uppercase tracking-wider block mb-1.5 flex items-center gap-1.5">
                  <Calendar className="w-3.5 h-3.5 text-[#0096C7]" />
                  Desired Completion Date *
                </label>
                <input
                  type="date"
                  value={desiredDate}
                  onChange={e => setDesiredDate(e.target.value)}
                  className="w-full bg-[#0C0F1D] border border-[#2C324A] focus:border-[#0096C7] rounded-xl px-4 py-2.5 text-sm text-white focus:outline-none"
                />
              </div>

              <div>
                <label className="text-xs font-semibold text-white/80 uppercase tracking-wider block mb-1.5 flex items-center gap-1.5">
                  <Users className="w-3.5 h-3.5 text-[#0096C7]" />
                  Workers Needed
                </label>
                <div className="flex items-center gap-3">
                  <button
                    type="button"
                    onClick={() => setWorkerCount(prev => Math.max(1, prev - 1))}
                    className="w-10 h-10 rounded-xl bg-[#0C0F1D] border border-[#2C324A] text-white hover:border-[#0096C7] flex items-center justify-center font-bold text-lg"
                  >
                    -
                  </button>
                  <span className="font-mono font-bold text-lg text-white w-8 text-center">
                    {workerCount}
                  </span>
                  <button
                    type="button"
                    onClick={() => setWorkerCount(prev => prev + 1)}
                    className="w-10 h-10 rounded-xl bg-[#0C0F1D] border border-[#2C324A] text-white hover:border-[#0096C7] flex items-center justify-center font-bold text-lg"
                  >
                    +
                  </button>
                </div>
              </div>
            </div>
          )}

          {/* STEP 2: Requirements */}
          {currentStep === 2 && (
            <div className="space-y-4">
              <div>
                <label className="text-xs font-semibold text-white/80 uppercase tracking-wider block mb-1.5">
                  Required Skills
                </label>
                <div className="flex gap-2 mb-3">
                  <input
                    type="text"
                    placeholder="e.g., Heavy Lifting, Welding, CAN Bus"
                    value={skillInput}
                    onChange={e => setSkillInput(e.target.value)}
                    onKeyDown={e => e.key === 'Enter' && (e.preventDefault(), handleAddSkill())}
                    className="flex-1 bg-[#0C0F1D] border border-[#2C324A] focus:border-[#0096C7] rounded-xl px-4 py-2 text-sm text-white focus:outline-none"
                  />
                  <button
                    type="button"
                    onClick={handleAddSkill}
                    className="px-4 py-2 bg-[#0096C7] hover:bg-[#0082ad] text-white text-xs font-semibold rounded-xl transition"
                  >
                    Add
                  </button>
                </div>
                <div className="flex flex-wrap gap-2">
                  {skills.map(s => (
                    <span
                      key={s}
                      className="inline-flex items-center gap-1.5 px-3 py-1 rounded-lg bg-[#0C0F1D] border border-[#0096C7]/50 text-xs text-white"
                    >
                      {s}
                      <button
                        type="button"
                        onClick={() => handleRemoveSkill(s)}
                        className="text-white/50 hover:text-white"
                      >
                        ×
                      </button>
                    </span>
                  ))}
                </div>
              </div>

              <div className="pt-2 border-t border-[#2C324A] space-y-3">
                <label className="flex items-center gap-3 p-3 rounded-xl bg-[#0C0F1D] border border-[#2C324A] cursor-pointer hover:border-[#0096C7]/40 transition">
                  <input
                    type="checkbox"
                    checked={requireId}
                    onChange={e => setRequireId(e.target.checked)}
                    className="w-4 h-4 rounded text-[#0096C7] focus:ring-0 focus:ring-offset-0 bg-[#16192B] border-[#2C324A]"
                  />
                  <div>
                    <span className="text-xs font-semibold text-white block">
                      Require Verified Photo ID / Driver's License
                    </span>
                    <span className="text-[11px] text-white/50 block">
                      Providers must hold state-verified identity credential
                    </span>
                  </div>
                </label>

                <label className="flex items-center gap-3 p-3 rounded-xl bg-[#0C0F1D] border border-[#2C324A] cursor-pointer hover:border-[#0096C7]/40 transition">
                  <input
                    type="checkbox"
                    checked={requireInsurance}
                    onChange={e => setRequireInsurance(e.target.checked)}
                    className="w-4 h-4 rounded text-[#0096C7] focus:ring-0 focus:ring-offset-0 bg-[#16192B] border-[#2C324A]"
                  />
                  <div>
                    <span className="text-xs font-semibold text-white block">
                      Require General Liability Insurance
                    </span>
                    <span className="text-[11px] text-white/50 block">
                      Guarantees protection for heavy machinery & physical tasks
                    </span>
                  </div>
                </label>
              </div>
            </div>
          )}

          {/* STEP 3: Funding & Tithe */}
          {currentStep === 3 && (
            <div className="space-y-4">
              <div>
                <label className="text-xs font-semibold text-white/80 uppercase tracking-wider block mb-1.5 flex items-center gap-1.5">
                  <DollarSign className="w-3.5 h-3.5 text-[#D4AF37]" />
                  Total Bounty Amount (USD) *
                </label>
                <div className="relative">
                  <span className="absolute left-4 top-1/2 -translate-y-1/2 text-white/50 font-bold">$</span>
                  <input
                    type="number"
                    step="5"
                    value={bounty}
                    onChange={e => setBounty(e.target.value)}
                    className="w-full bg-[#0C0F1D] border border-[#2C324A] focus:border-[#D4AF37] rounded-xl pl-8 pr-4 py-3 text-lg font-mono font-bold text-white focus:outline-none"
                  />
                </div>
              </div>

              {/* TitheX Escrow Breakdown Card */}
              <div className="p-4 rounded-xl bg-[#D4AF37]/10 border border-[#D4AF37]/30 space-y-2">
                <div className="flex items-center gap-2 text-xs font-bold text-[#D4AF37]">
                  <Coins className="w-4 h-4" />
                  <span>TitheX Protocol Escrow Allocation</span>
                </div>
                <div className="space-y-1.5 text-xs">
                  <div className="flex justify-between items-center text-white/90">
                    <span>• 90% Worker Bounty (Released upon verification):</span>
                    <span className="font-mono font-bold text-[#4DBBDF]">${workerAllocation}</span>
                  </div>
                  <div className="flex justify-between items-center text-white/90">
                    <span>• 10% Community Tithe (Yield staking treasury):</span>
                    <span className="font-mono font-bold text-[#D4AF37]">${titheAllocation}</span>
                  </div>
                </div>
                <p className="text-[11px] text-white/50 pt-2 border-t border-[#D4AF37]/20">
                  Funds are secured in Fluoridian smart escrow contract and only released after proof of work verification.
                </p>
              </div>
            </div>
          )}

          {/* STEP 4: Review & Publish */}
          {currentStep === 4 && (
            <div className="space-y-4">
              <div className="p-4 rounded-xl bg-[#0C0F1D] border border-[#2C324A] space-y-3">
                <div className="flex items-start justify-between">
                  <div>
                    <span className="text-[10px] font-mono px-2 py-0.5 rounded bg-[#0096C7]/20 text-[#0096C7] font-semibold">
                      {category}
                    </span>
                    <h3 className="font-display font-bold text-base text-white mt-1">
                      {title || 'Community Task'}
                    </h3>
                  </div>
                  <span className="text-xl font-mono font-bold text-[#D4AF37]">${parsedBounty}</span>
                </div>

                <p className="text-xs text-white/70 leading-relaxed">
                  {description || 'No description provided.'}
                </p>

                <div className="grid grid-cols-2 gap-2 text-xs pt-3 border-t border-[#2C324A] text-white/80">
                  <div>📍 {locationLabel}</div>
                  <div>📅 Due: {desiredDate}</div>
                  <div>👥 Workers: {workerCount}</div>
                  <div>🛡️ Verified ID: {requireId ? 'Required' : 'Optional'}</div>
                </div>
              </div>

              <div className="p-3 rounded-lg bg-[#0096C7]/10 border border-[#0096C7]/30 text-xs text-white/80 flex items-start gap-2.5">
                <ShieldCheck className="w-5 h-5 text-[#0096C7] shrink-0 mt-0.5" />
                <p className="text-[11px] leading-relaxed">
                  Publishing will broadcast an Ed25519-signed Event Envelope to the Fluoridian P2P relay and initialize smart contract escrow.
                </p>
              </div>
            </div>
          )}
        </div>

        {/* Wizard Controls Footer */}
        <div className="px-6 py-4 border-t border-[#2C324A] bg-[#0C0F1D] flex items-center justify-between">
          {currentStep > 0 ? (
            <button
              onClick={() => setCurrentStep(prev => prev - 1)}
              className="flex items-center gap-1.5 px-4 py-2 rounded-xl border border-[#2C324A] text-white/80 hover:text-white hover:bg-white/5 text-xs font-semibold transition"
            >
              <ArrowLeft className="w-4 h-4" />
              <span>Back</span>
            </button>
          ) : (
            <div />
          )}

          {currentStep < 4 ? (
            <button
              onClick={() => setCurrentStep(prev => prev + 1)}
              className="flex items-center gap-1.5 px-5 py-2.5 rounded-xl bg-[#0096C7] hover:bg-[#0082ad] text-white text-xs font-semibold shadow-[0_0_15px_rgba(0,150,199,0.3)] transition"
            >
              <span>Next</span>
              <ArrowRight className="w-4 h-4" />
            </button>
          ) : (
            <button
              onClick={handlePublish}
              className="flex items-center gap-1.5 px-6 py-2.5 rounded-xl bg-gradient-to-r from-[#0096C7] to-[#5300FF] hover:opacity-90 text-white text-xs font-bold shadow-[0_0_20px_rgba(0,150,199,0.5)] transition"
            >
              <CheckCircle className="w-4 h-4" />
              <span>Publish to Network</span>
            </button>
          )}
        </div>
      </div>
    </div>
  );
};
