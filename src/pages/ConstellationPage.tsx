import React from 'react';
import { ArrowLeft } from 'lucide-react';
import { FluoridianConstellationMap } from '../components/FluoridianConstellationMap';

interface ConstellationPageProps {
  onBack: () => void;
}

export const ConstellationPage: React.FC<ConstellationPageProps> = ({ onBack }) => {
  return (
    <div className="pb-24 pt-4 max-w-4xl mx-auto px-4 space-y-4">
      <div className="flex items-center gap-3">
        <button
          onClick={onBack}
          className="p-2 rounded-xl bg-[#16192B] border border-[#2C324A] text-white/70 hover:text-white hover:border-[#0096C7] transition"
        >
          <ArrowLeft className="w-5 h-5" />
        </button>
        <div>
          <h2 className="font-display font-bold text-white text-base tracking-wide">
            FLUORIDIAN CONSTELLATION MAP
          </h2>
          <p className="text-xs font-mono text-[#0096C7]">
            Decentralized Faction Topology & Consensus Orbital Relay
          </p>
        </div>
      </div>

      <FluoridianConstellationMap />
    </div>
  );
};
