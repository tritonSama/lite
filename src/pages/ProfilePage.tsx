import React, { useState } from 'react';
import { useApp } from '../context/AppContext';
import { Credential, CredentialType, CredentialStatus } from '../types';
import { 
  User, 
  ShieldCheck, 
  Star, 
  Briefcase, 
  DollarSign, 
  Moon, 
  Sun, 
  CheckCircle, 
  Clock, 
  Plus, 
  Upload, 
  ChevronRight, 
  FileText 
} from 'lucide-react';

export const ProfilePage: React.FC = () => {
  const { currentUser, isDarkMode, toggleTheme, updateUserProfile } = useApp();
  const [showCredentialsModal, setShowCredentialsModal] = useState(false);
  const [showAddCredModal, setShowAddCredModal] = useState(false);
  const [selectedCredType, setSelectedCredType] = useState<CredentialType>('driversLicense');
  const [credIssuer, setCredIssuer] = useState('');

  const getStatusBadge = (status: CredentialStatus) => {
    switch (status) {
      case 'verified':
        return (
          <span className="text-[10px] font-mono px-2 py-0.5 rounded bg-green-500/20 text-green-400 border border-green-500/30 flex items-center gap-1 font-semibold">
            <CheckCircle className="w-3 h-3" /> VERIFIED
          </span>
        );
      case 'underReview':
        return (
          <span className="text-[10px] font-mono px-2 py-0.5 rounded bg-amber-500/20 text-amber-500 border border-amber-500/30 flex items-center gap-1 font-semibold">
            <Clock className="w-3 h-3" /> UNDER REVIEW
          </span>
        );
      default:
        return (
          <span className="text-[10px] font-mono px-2 py-0.5 rounded bg-blue-500/20 text-blue-500 border border-blue-500/30 font-semibold">
            UPLOADED
          </span>
        );
    }
  };

  const formatCredName = (type: CredentialType) => {
    switch (type) {
      case 'driversLicense':
        return "Driver's License (Class C)";
      case 'cdl':
        return 'Commercial Driver License (CDL)';
      case 'electricalLicense':
        return 'Journeyman / Master Electrical License';
      case 'contractorLicense':
        return 'General Contractor License';
      case 'insurance':
        return 'Commercial Liability Insurance';
      case 'foodHandler':
        return 'Food Safety / Handler Certificate';
      case 'backgroundCheck':
        return 'Verified Criminal Background Check';
      default:
        return 'Credential Document';
    }
  };

  const handleAddCredential = (e: React.FormEvent) => {
    e.preventDefault();
    const newCred: Credential = {
      id: 'cred-' + Date.now(),
      userId: currentUser.id,
      type: selectedCredType,
      status: 'underReview',
      issuer: credIssuer.trim() || 'State Licensing Board',
      expirationDate: '2028-12-31',
    };
    updateUserProfile({
      credentials: [...currentUser.credentials, newCred],
    });
    setShowAddCredModal(false);
    setCredIssuer('');
  };

  return (
    <div className="pb-24 pt-2">
      <div className="max-w-2xl mx-auto px-4 space-y-5">
        {/* Profile Hero Card */}
        <div className={`p-6 rounded-2xl border text-center space-y-3 transition-colors ${
          isDarkMode
            ? 'bg-[#16192B] border-[#2C324A] text-white shadow-[0_0_25px_rgba(0,150,199,0.15)]'
            : 'bg-white border-slate-200 text-slate-900 shadow-sm'
        }`}>
          <div className="relative w-24 h-24 mx-auto">
            <img
              src={currentUser.photoURL || 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200&auto=format&fit=crop&q=80'}
              alt={currentUser.displayName}
              className={`w-full h-full rounded-full object-cover border-2 border-[#0096C7] p-1 shadow-[0_0_15px_rgba(0,150,199,0.4)] ${
                isDarkMode ? 'bg-[#0C0F1D]' : 'bg-slate-100'
              }`}
            />
            <span className="absolute bottom-0 right-1 w-5 h-5 rounded-full bg-green-500 border-2 border-[#16192B]" />
          </div>

          <div>
            <h2 className={`font-display font-bold text-xl ${isDarkMode ? 'text-white' : 'text-slate-900'}`}>
              {currentUser.displayName}
            </h2>
            <p className="text-xs font-mono text-[#0096C7] font-semibold">{currentUser.email}</p>
          </div>

          <p className={`text-xs max-w-md mx-auto leading-relaxed ${isDarkMode ? 'text-white/70' : 'text-slate-600'}`}>
            {currentUser.bio}
          </p>

          {/* Key Metrics Grid */}
          <div className={`grid grid-cols-3 gap-2 pt-3 border-t text-center ${
            isDarkMode ? 'border-[#2C324A]' : 'border-slate-200'
          }`}>
            <div className={`p-2.5 rounded-xl border ${
              isDarkMode ? 'bg-[#0C0F1D] border-[#2C324A]' : 'bg-slate-50 border-slate-200'
            }`}>
              <div className="text-lg font-mono font-bold text-[#D4AF37] flex items-center justify-center gap-1">
                <Star className="w-4 h-4 fill-[#D4AF37]" />
                <span>{currentUser.rating}</span>
              </div>
              <span className={`text-[10px] font-mono ${isDarkMode ? 'text-white/50' : 'text-slate-500'}`}>REPUTATION</span>
            </div>

            <div className={`p-2.5 rounded-xl border ${
              isDarkMode ? 'bg-[#0C0F1D] border-[#2C324A]' : 'bg-slate-50 border-slate-200'
            }`}>
              <div className={`text-lg font-mono font-bold flex items-center justify-center gap-1 ${
                isDarkMode ? 'text-white' : 'text-slate-900'
              }`}>
                <Briefcase className="w-4 h-4 text-[#0096C7]" />
                <span>{currentUser.completedJobsCount}</span>
              </div>
              <span className={`text-[10px] font-mono ${isDarkMode ? 'text-white/50' : 'text-slate-500'}`}>COMPLETED</span>
            </div>

            <div className={`p-2.5 rounded-xl border ${
              isDarkMode ? 'bg-[#0C0F1D] border-[#2C324A]' : 'bg-slate-50 border-slate-200'
            }`}>
              <div className="text-lg font-mono font-bold text-[#4DBBDF] flex items-center justify-center gap-1">
                <DollarSign className="w-4 h-4" />
                <span>{currentUser.totalEarnings}</span>
              </div>
              <span className={`text-[10px] font-mono ${isDarkMode ? 'text-white/50' : 'text-slate-500'}`}>EARNINGS</span>
            </div>
          </div>
        </div>

        {/* Action Menu List */}
        <div className={`rounded-2xl border divide-y overflow-hidden transition-colors ${
          isDarkMode 
            ? 'bg-[#16192B] border-[#2C324A] divide-[#2C324A]' 
            : 'bg-white border-slate-200 divide-slate-200 shadow-sm'
        }`}>
          {/* Credentials */}
          <div
            onClick={() => setShowCredentialsModal(true)}
            className={`p-4 flex items-center justify-between cursor-pointer transition ${
              isDarkMode ? 'hover:bg-white/5' : 'hover:bg-slate-50'
            }`}
          >
            <div className="flex items-center gap-3">
              <div className="w-9 h-9 rounded-xl bg-[#0096C7]/15 border border-[#0096C7]/40 flex items-center justify-center text-[#0096C7]">
                <ShieldCheck className="w-5 h-5" />
              </div>
              <div>
                <h4 className={`text-xs font-bold ${isDarkMode ? 'text-white' : 'text-slate-900'}`}>Credentials & Licenses</h4>
                <p className={`text-[11px] ${isDarkMode ? 'text-white/50' : 'text-slate-500'}`}>
                  {currentUser.credentials.filter(c => c.status === 'verified').length} verified licenses on file
                </p>
              </div>
            </div>
            <ChevronRight className={`w-4 h-4 ${isDarkMode ? 'text-white/40' : 'text-slate-400'}`} />
          </div>

          {/* Skills */}
          <div className="p-4 space-y-2">
            <span className={`text-xs font-mono block uppercase ${isDarkMode ? 'text-white/60' : 'text-slate-500'}`}>Operator Skills</span>
            <div className="flex flex-wrap gap-1.5">
              {currentUser.skills.map(s => (
                <span
                  key={s}
                  className={`px-2.5 py-1 rounded-lg border text-xs ${
                    isDarkMode 
                      ? 'bg-[#0C0F1D] border-[#0096C7]/30 text-white' 
                      : 'bg-slate-100 border-slate-300 text-slate-800'
                  }`}
                >
                  {s}
                </span>
              ))}
            </div>
          </div>

          {/* Fluorite Dark / Light Mode Toggle */}
          <div className="p-4 flex items-center justify-between">
            <div className="flex items-center gap-3">
              <div className={`w-9 h-9 rounded-xl border flex items-center justify-center transition shadow-sm ${
                isDarkMode 
                  ? 'bg-[#0096C7]/15 border-[#0096C7]/40 text-[#0096C7]' 
                  : 'bg-amber-100 border-amber-300 text-amber-600'
              }`}>
                {isDarkMode ? <Moon className="w-5 h-5" /> : <Sun className="w-5 h-5" />}
              </div>
              <div>
                <div className="flex items-center gap-2">
                  <h4 className={`text-xs font-bold ${isDarkMode ? 'text-white' : 'text-slate-900'}`}>
                    {isDarkMode ? 'Fluorite Dark Mode' : 'Fluorite Light Mode'}
                  </h4>
                  <span className={`text-[9px] font-mono px-1.5 py-0.5 rounded border ${
                    isDarkMode 
                      ? 'bg-[#0096C7]/10 border-[#0096C7]/30 text-[#0096C7]' 
                      : 'bg-amber-100 border-amber-300 text-amber-700'
                  }`}>
                    {isDarkMode ? 'CYBER OBSIDIAN' : 'DAYLIGHT TACTICAL'}
                  </span>
                </div>
                <p className={`text-[11px] ${isDarkMode ? 'text-white/50' : 'text-slate-500'}`}>
                  {isDarkMode ? 'Deep obsidian void with cybernetic neon highlights' : 'Clean high-readability daylight workspace'}
                </p>
              </div>
            </div>

            <button
              onClick={toggleTheme}
              aria-label="Toggle theme"
              className={`w-12 h-6 rounded-full transition-colors relative p-1 cursor-pointer ${
                isDarkMode ? 'bg-[#0096C7]' : 'bg-amber-500'
              }`}
            >
              <div
                className={`w-4 h-4 rounded-full bg-white transition-transform ${
                  isDarkMode ? 'translate-x-6' : 'translate-x-0'
                }`}
              />
            </button>
          </div>
        </div>

        {/* Credentials Modal */}
        {showCredentialsModal && (
          <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/80 backdrop-blur-md animate-fade-in">
            <div className={`w-full max-w-md border rounded-2xl p-6 space-y-4 shadow-[0_0_35px_rgba(0,150,199,0.3)] ${
              isDarkMode ? 'bg-[#16192B] border-[#2C324A]' : 'bg-white border-slate-200'
            }`}>
              <div className="flex items-center justify-between">
                <div className="flex items-center gap-2">
                  <ShieldCheck className="w-5 h-5 text-[#0096C7]" />
                  <h3 className={`font-display font-bold text-base ${isDarkMode ? 'text-white' : 'text-slate-900'}`}>
                    Verified Credentials
                  </h3>
                </div>
                <button
                  onClick={() => setShowCredentialsModal(false)}
                  className={`${isDarkMode ? 'text-white/50 hover:text-white' : 'text-slate-400 hover:text-slate-700'}`}
                >
                  ✕
                </button>
              </div>

              <div className="space-y-3 max-h-[50vh] overflow-y-auto">
                {currentUser.credentials.map(c => (
                  <div
                    key={c.id}
                    className={`p-3 rounded-xl border space-y-1.5 ${
                      isDarkMode ? 'bg-[#0C0F1D] border-[#2C324A]' : 'bg-slate-50 border-slate-200'
                    }`}
                  >
                    <div className="flex items-center justify-between">
                      <h4 className={`text-xs font-bold ${isDarkMode ? 'text-white' : 'text-slate-900'}`}>{formatCredName(c.type)}</h4>
                      {getStatusBadge(c.status)}
                    </div>
                    <div className={`flex justify-between text-[10px] font-mono ${isDarkMode ? 'text-white/50' : 'text-slate-500'}`}>
                      <span>ISSUER: {c.issuer}</span>
                      <span>EXP: {c.expirationDate}</span>
                    </div>
                  </div>
                ))}
              </div>

              <button
                onClick={() => {
                  setShowCredentialsModal(false);
                  setShowAddCredModal(true);
                }}
                className="w-full py-2.5 bg-[#0096C7] hover:bg-[#0082ad] text-white rounded-xl text-xs font-bold flex items-center justify-center gap-2 shadow-[0_0_15px_rgba(0,150,199,0.3)] transition"
              >
                <Plus className="w-4 h-4" /> Upload New Credential
              </button>
            </div>
          </div>
        )}

        {/* Add Credential Modal */}
        {showAddCredModal && (
          <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/80 backdrop-blur-md animate-fade-in">
            <div className={`w-full max-w-md border rounded-2xl p-6 space-y-4 shadow-[0_0_35px_rgba(0,150,199,0.3)] ${
              isDarkMode ? 'bg-[#16192B] border-[#2C324A]' : 'bg-white border-slate-200'
            }`}>
              <div className="flex items-center justify-between">
                <div className="flex items-center gap-2">
                  <Upload className="w-5 h-5 text-[#0096C7]" />
                  <h3 className={`font-display font-bold text-base ${isDarkMode ? 'text-white' : 'text-slate-900'}`}>
                    Upload Credential
                  </h3>
                </div>
                <button
                  onClick={() => setShowAddCredModal(false)}
                  className={`${isDarkMode ? 'text-white/50 hover:text-white' : 'text-slate-400 hover:text-slate-700'}`}
                >
                  ✕
                </button>
              </div>

              <form onSubmit={handleAddCredential} className="space-y-4">
                <div>
                  <label className={`block text-xs font-semibold mb-1 ${isDarkMode ? 'text-white/80' : 'text-slate-700'}`}>
                    License / Credential Type
                  </label>
                  <select
                    value={selectedCredType}
                    onChange={e => setSelectedCredType(e.target.value as CredentialType)}
                    className={`w-full px-3 py-2 rounded-xl text-xs focus:outline-none border ${
                      isDarkMode 
                        ? 'bg-[#0C0F1D] border-[#2C324A] text-white focus:border-[#0096C7]' 
                        : 'bg-slate-50 border-slate-300 text-slate-900 focus:border-[#0096C7]'
                    }`}
                  >
                    <option value="driversLicense">Driver's License (Class C)</option>
                    <option value="cdl">Commercial Driver License (CDL)</option>
                    <option value="electricalLicense">Journeyman / Master Electrical License</option>
                    <option value="contractorLicense">General Contractor License</option>
                    <option value="insurance">Commercial Liability Insurance</option>
                    <option value="foodHandler">Food Safety / Handler Certificate</option>
                    <option value="backgroundCheck">Verified Criminal Background Check</option>
                  </select>
                </div>

                <div>
                  <label className={`block text-xs font-semibold mb-1 ${isDarkMode ? 'text-white/80' : 'text-slate-700'}`}>
                    Issuing Authority or State Board
                  </label>
                  <input
                    type="text"
                    required
                    placeholder="e.g. Texas Department of Licensing and Regulation"
                    value={credIssuer}
                    onChange={e => setCredIssuer(e.target.value)}
                    className={`w-full px-3 py-2 rounded-xl text-xs focus:outline-none border ${
                      isDarkMode 
                        ? 'bg-[#0C0F1D] border-[#2C324A] text-white focus:border-[#0096C7]' 
                        : 'bg-slate-50 border-slate-300 text-slate-900 focus:border-[#0096C7]'
                    }`}
                  />
                </div>

                <div className={`p-4 border-2 border-dashed rounded-xl text-center space-y-2 ${
                  isDarkMode ? 'border-[#2C324A] bg-[#0C0F1D]/50' : 'border-slate-300 bg-slate-50'
                }`}>
                  <FileText className="w-8 h-8 text-[#0096C7] mx-auto opacity-70" />
                  <p className={`text-xs ${isDarkMode ? 'text-white/70' : 'text-slate-600'}`}>
                    Tap to capture photo of document or PDF
                  </p>
                  <span className={`text-[10px] font-mono block ${isDarkMode ? 'text-white/40' : 'text-slate-400'}`}>
                    Encrypted via Ed25519 Mobile Vault
                  </span>
                </div>

                <div className="flex gap-2 pt-2">
                  <button
                    type="button"
                    onClick={() => setShowAddCredModal(false)}
                    className={`flex-1 py-2 rounded-xl text-xs transition ${
                      isDarkMode ? 'bg-[#0C0F1D] text-white/60 hover:text-white' : 'bg-slate-100 text-slate-700 hover:bg-slate-200'
                    }`}
                  >
                    Cancel
                  </button>
                  <button
                    type="submit"
                    className="flex-1 py-2 bg-[#0096C7] hover:bg-[#0082ad] text-white rounded-xl text-xs font-bold shadow-[0_0_15px_rgba(0,150,199,0.3)] transition"
                  >
                    Submit for Review
                  </button>
                </div>
              </form>
            </div>
          </div>
        )}
      </div>
    </div>
  );
};
