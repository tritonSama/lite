import React, { useState } from 'react';
import { useApp } from '../context/AppContext';
import { Offer } from '../types';
import { 
  Gavel, 
  Inbox, 
  Send, 
  Clock, 
  CheckCircle, 
  XCircle, 
  DollarSign, 
  ArrowLeft 
} from 'lucide-react';

interface BidsPageProps {
  onBack: () => void;
}

export const BidsPage: React.FC<BidsPageProps> = ({ onBack }) => {
  const { offers, updateOfferStatus, currentUser, tasks } = useApp();
  const [activeTab, setActiveTab] = useState<'myOffers' | 'received'>('myOffers');

  // In production, myOffers are where providerId == current user
  const myOffers = offers.filter(o => o.providerId === currentUser.id);
  // Offers received on user's tasks
  const myTaskIds = tasks.filter(t => t.creatorId === currentUser.id).map(t => t.id);
  const receivedOffers = offers.filter(o => myTaskIds.includes(o.taskId));

  const getStatusBadge = (status: Offer['status']) => {
    switch (status) {
      case 'accepted':
        return (
          <span className="text-[10px] font-mono px-2 py-0.5 rounded bg-green-500/20 text-green-400 border border-green-500/30 flex items-center gap-1">
            <CheckCircle className="w-3 h-3" /> ACCEPTED
          </span>
        );
      case 'rejected':
        return (
          <span className="text-[10px] font-mono px-2 py-0.5 rounded bg-red-500/20 text-red-400 border border-red-500/30 flex items-center gap-1">
            <XCircle className="w-3 h-3" /> REJECTED
          </span>
        );
      default:
        return (
          <span className="text-[10px] font-mono px-2 py-0.5 rounded bg-amber-500/20 text-amber-400 border border-amber-500/30 flex items-center gap-1">
            <Clock className="w-3 h-3" /> PENDING
          </span>
        );
    }
  };

  return (
    <div className="pb-24 pt-2">
      <div className="max-w-2xl mx-auto px-4 space-y-4">
        {/* Header Bar */}
        <div className="flex items-center justify-between">
          <button
            onClick={onBack}
            className="flex items-center gap-1.5 px-3 py-1.5 rounded-xl border border-[#2C324A] text-white/70 hover:text-white hover:bg-white/5 text-xs font-mono transition"
          >
            <ArrowLeft className="w-4 h-4" />
            <span>Back</span>
          </button>
          <div className="text-right">
            <h2 className="font-display font-bold text-white text-base">
              BIDS & OFFERS ESCROW
            </h2>
            <p className="text-[10px] font-mono text-[#D4AF37]">
              SPRINT 3: PROPOSALS & CONTRACTS
            </p>
          </div>
        </div>

        {/* Tab Switcher */}
        <div className="flex border-b border-[#2C324A] bg-[#16192B] rounded-xl p-1">
          <button
            onClick={() => setActiveTab('myOffers')}
            className={`flex-1 py-2 rounded-lg text-xs font-mono font-bold flex items-center justify-center gap-2 transition ${
              activeTab === 'myOffers'
                ? 'bg-[#0096C7] text-white'
                : 'text-white/60 hover:text-white'
            }`}
          >
            <Send className="w-3.5 h-3.5" />
            <span>MY OFFERS ({myOffers.length})</span>
          </button>
          <button
            onClick={() => setActiveTab('received')}
            className={`flex-1 py-2 rounded-lg text-xs font-mono font-bold flex items-center justify-center gap-2 transition ${
              activeTab === 'received'
                ? 'bg-[#0096C7] text-white'
                : 'text-white/60 hover:text-white'
            }`}
          >
            <Inbox className="w-3.5 h-3.5" />
            <span>RECEIVED ({receivedOffers.length})</span>
          </button>
        </div>

        {/* Content List */}
        <div className="space-y-3">
          {activeTab === 'myOffers' ? (
            myOffers.length === 0 ? (
              <div className="text-center py-16 bg-[#16192B] border border-[#2C324A] rounded-2xl p-6">
                <Gavel className="w-12 h-12 text-white/20 mx-auto mb-2" />
                <h3 className="font-display font-semibold text-white">No Bids Placed Yet</h3>
                <p className="text-xs text-white/50 mt-1">
                  Explore open tasks on the Board and place competitive bids to win bounties!
                </p>
              </div>
            ) : (
              myOffers.map(offer => (
                <div
                  key={offer.id}
                  className="p-4 rounded-xl bg-[#16192B] border border-[#2C324A] space-y-2.5"
                >
                  <div className="flex items-start justify-between">
                    <div>
                      <span className="text-[10px] font-mono text-white/40 block">
                        TASK ID: {offer.taskId}
                      </span>
                      <h4 className="font-semibold text-sm text-white mt-0.5">
                        {offer.taskTitle || 'Community Task'}
                      </h4>
                    </div>
                    <div className="text-right">
                      <div className="text-base font-mono font-bold text-[#D4AF37]">
                        ${offer.amount.toFixed(2)}
                      </div>
                      {getStatusBadge(offer.status)}
                    </div>
                  </div>

                  {offer.message && (
                    <p className="text-xs text-white/70 italic bg-[#0C0F1D] p-2.5 rounded-lg border border-[#2C324A]">
                      "{offer.message}"
                    </p>
                  )}

                  <div className="flex items-center justify-between text-[11px] font-mono text-white/40 pt-1">
                    <span>Proposed Date: {offer.proposedDate || 'Flexible'}</span>
                    <span>Submitted: {new Date(offer.createdAt).toLocaleDateString()}</span>
                  </div>
                </div>
              ))
            )
          ) : (
            /* Received Offers */
            receivedOffers.length === 0 ? (
              <div className="text-center py-16 bg-[#16192B] border border-[#2C324A] rounded-2xl p-6">
                <Inbox className="w-12 h-12 text-white/20 mx-auto mb-2" />
                <h3 className="font-display font-semibold text-white">No Incoming Bids</h3>
                <p className="text-xs text-white/50 mt-1">
                  When you publish tasks, provider bids and counteroffers will appear here for evaluation.
                </p>
              </div>
            ) : (
              receivedOffers.map(offer => (
                <div
                  key={offer.id}
                  className="p-4 rounded-xl bg-[#16192B] border border-[#2C324A] space-y-2.5"
                >
                  <div className="flex items-start justify-between">
                    <div>
                      <h4 className="font-semibold text-sm text-white">
                        {offer.taskTitle || 'Community Task'}
                      </h4>
                      <p className="text-xs text-[#0096C7] font-mono">
                        From: {offer.providerName} (★ {offer.providerRating})
                      </p>
                    </div>
                    <div className="text-right">
                      <div className="text-base font-mono font-bold text-[#D4AF37]">
                        ${offer.amount.toFixed(2)}
                      </div>
                      {getStatusBadge(offer.status)}
                    </div>
                  </div>

                  {offer.message && (
                    <p className="text-xs text-white/70 italic bg-[#0C0F1D] p-2.5 rounded-lg border border-[#2C324A]">
                      "{offer.message}"
                    </p>
                  )}

                  {offer.status === 'pending' && (
                    <div className="flex justify-end gap-2 pt-2 border-t border-[#2C324A]">
                      <button
                        onClick={() => updateOfferStatus(offer.id, 'rejected')}
                        className="px-3 py-1.5 rounded-lg border border-red-500/50 text-red-400 text-xs font-semibold hover:bg-red-500/10 transition"
                      >
                        Decline
                      </button>
                      <button
                        onClick={() => updateOfferStatus(offer.id, 'accepted')}
                        className="px-4 py-1.5 rounded-lg bg-[#0096C7] hover:bg-[#0082ad] text-white text-xs font-bold transition shadow-sm"
                      >
                        Accept & Lock Escrow
                      </button>
                    </div>
                  )}
                </div>
              ))
            )
          )}
        </div>
      </div>
    </div>
  );
};
