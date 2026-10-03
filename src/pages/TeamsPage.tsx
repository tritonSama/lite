import React, { useState } from 'react';
import { useApp } from '../context/AppContext';
import { TeamWar, ListingType, RentalDuration, SquadFriend } from '../types';
import { 
  Users, 
  Shield, 
  Swords, 
  ShoppingBag, 
  Plus, 
  CheckCircle, 
  Globe, 
  Sparkles, 
  X, 
  Share2, 
  Flame, 
  Droplet, 
  Wind, 
  TreePine,
  MessageSquare,
  Radio,
  User,
  Activity,
  Battery,
  MapPin,
  Clock,
  ArrowRight
} from 'lucide-react';

interface TeamsPageProps {
  onOpenConstellation: () => void;
}

export const TeamsPage: React.FC<TeamsPageProps> = ({ onOpenConstellation }) => {
  const { 
    teams, 
    friends, 
    selectedTeamId, 
    selectTeam, 
    wars, 
    declareWar, 
    tasks, 
    createTask, 
    openComms, 
    isDarkMode 
  } = useApp();
  const [activeTab, setActiveTab] = useState<'teams' | 'friends' | 'marketplace' | 'wars'>('teams');
  const [listingFilter, setListingFilter] = useState<'all' | 'forSale' | 'wantedToBuy' | 'forRent'>('all');

  // Declare War Dialog State
  const [warEnemy, setWarEnemy] = useState<{ id: string; name: string } | null>(null);
  const [warMessage, setWarMessage] = useState('Contesting resource and territory rights.');

  // Create Listing Modal State
  const [showCreateModal, setShowCreateModal] = useState(false);
  const [listingTitle, setListingTitle] = useState('');
  const [listingDesc, setListingDesc] = useState('');
  const [listingCategory, setListingCategory] = useState<'Service' | 'Event' | 'Equipment' | 'Vehicle'>('Equipment');
  const [listingType, setListingType] = useState<ListingType>('forSale');
  const [rentalDuration, setRentalDuration] = useState<RentalDuration>('daily');
  const [listingBounty, setListingBounty] = useState('100');

  const getTeamIcon = (id: string) => {
    switch (id) {
      case 'water':
        return <Droplet className="w-5 h-5 text-[#0096C7]" />;
      case 'fire':
        return <Flame className="w-5 h-5 text-[#FF6B35]" />;
      case 'earth':
        return <TreePine className="w-5 h-5 text-[#2EC4B6]" />;
      case 'wind':
        return <Wind className="w-5 h-5 text-[#70C1B3]" />;
      default:
        return <Users className="w-5 h-5 text-white" />;
    }
  };

  const getTeamName = (id: string) => {
    return teams.find(t => t.id === id)?.name || 'Unknown Guild';
  };

  const handleDeclareWarSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    if (!warEnemy) return;
    declareWar(warEnemy.id, warMessage.trim());
    setWarEnemy(null);
    setActiveTab('wars');
  };

  const handleCreateListing = (e: React.FormEvent) => {
    e.preventDefault();
    if (!listingTitle.trim()) return;

    createTask({
      creatorId: selectedTeamId || 'water',
      creatorName: getTeamName(selectedTeamId || 'water'),
      creatorTeamId: selectedTeamId || 'water',
      title: listingTitle.trim(),
      description: listingDesc.trim() || 'No description provided.',
      category: 'Home Improvement',
      locationLabel: 'Austin Hub Depot',
      lat: 30.2672,
      lng: -97.7431,
      desiredCompletionDate: new Date(Date.now() + 86400000 * 7).toISOString().split('T')[0],
      workerCount: 1,
      requiredSkills: [listingCategory],
      budgetAmount: parseFloat(listingBounty) || 100,
      currencyCode: 'USD',
      status: 'published',
      listingType,
      rentalDuration: listingType === 'forRent' ? rentalDuration : undefined,
      photoUrls: ['https://images.unsplash.com/photo-1581092160607-ee22621dd758?w=600&auto=format&fit=crop&q=80'],
    });

    setShowCreateModal(false);
    setListingTitle('');
    setListingDesc('');
    setActiveTab('marketplace');
  };

  // Filtered Marketplace tasks
  const marketplaceTasks = tasks.filter(t => {
    if (listingFilter === 'all') return true;
    return (t.listingType || 'forSale') === listingFilter;
  });

  return (
    <div className={`pb-24 pt-2 transition-colors ${isDarkMode ? 'text-white' : 'text-slate-900'}`}>
      <div className="max-w-4xl mx-auto px-4 space-y-4">
        {/* Title Bar & Constellation Link */}
        <div className="flex items-center justify-between">
          <div className="flex items-center gap-2">
            <Users className="w-5 h-5 text-[#0096C7]" />
            <h2 className="font-display font-bold text-base tracking-wide">
              GUILDS & SQUAD THEATER
            </h2>
          </div>
          <button
            onClick={onOpenConstellation}
            className={`flex items-center gap-1.5 px-3 py-1.5 rounded-xl border text-xs font-mono font-bold transition shadow-sm ${
              isDarkMode
                ? 'bg-gradient-to-r from-[#5300FF]/30 to-[#0096C7]/30 border-[#0096C7] text-[#4DBBDF] hover:bg-[#0096C7]/20 shadow-[0_0_15px_rgba(0,150,199,0.3)]'
                : 'bg-blue-50 border-blue-300 text-blue-700 hover:bg-blue-100'
            }`}
          >
            <Share2 className="w-3.5 h-3.5" />
            <span>Fluorite Globe Map</span>
          </button>
        </div>

        {/* Tab Switcher */}
        <div className={`flex items-center border rounded-xl p-1 transition-colors ${
          isDarkMode ? 'border-[#2C324A] bg-[#16192B]' : 'border-slate-200 bg-slate-100'
        }`}>
          <button
            onClick={() => setActiveTab('teams')}
            className={`flex-1 py-2 rounded-lg text-xs font-mono font-bold transition ${
              activeTab === 'teams'
                ? 'bg-[#0096C7] text-white shadow-sm'
                : isDarkMode ? 'text-white/60 hover:text-white' : 'text-slate-600 hover:text-slate-900'
            }`}
          >
            MY GUILDS ({teams.length})
          </button>
          <button
            onClick={() => setActiveTab('friends')}
            className={`flex-1 py-2 rounded-lg text-xs font-mono font-bold flex items-center justify-center gap-1.5 transition ${
              activeTab === 'friends'
                ? 'bg-[#00FF88] text-[#080B15] shadow-sm'
                : isDarkMode ? 'text-white/60 hover:text-white' : 'text-slate-600 hover:text-slate-900'
            }`}
          >
            <User className="w-3.5 h-3.5" />
            <span>FRIENDS ({friends.length})</span>
          </button>
          <button
            onClick={() => setActiveTab('marketplace')}
            className={`flex-1 py-2 rounded-lg text-xs font-mono font-bold transition ${
              activeTab === 'marketplace'
                ? 'bg-[#0096C7] text-white shadow-sm'
                : isDarkMode ? 'text-white/60 hover:text-white' : 'text-slate-600 hover:text-slate-900'
            }`}
          >
            MARKETPLACE
          </button>
          <button
            onClick={() => setActiveTab('wars')}
            className={`flex-1 py-2 rounded-lg text-xs font-mono font-bold flex items-center justify-center gap-1.5 transition ${
              activeTab === 'wars'
                ? 'bg-[#E74C3C] text-white shadow-[0_0_12px_rgba(231,76,60,0.4)]'
                : isDarkMode ? 'text-white/60 hover:text-white' : 'text-slate-600 hover:text-slate-900'
            }`}
          >
            <Swords className="w-3.5 h-3.5" />
            <span>WARS ({wars.length})</span>
          </button>
        </div>

        {/* TAB 1: MY TEAMS */}
        {activeTab === 'teams' && (
          <div className="space-y-3">
            <div className={`p-3 rounded-xl border flex items-center justify-between text-xs ${
              isDarkMode ? 'bg-[#121629] border-[#2C324A] text-white/70' : 'bg-white border-slate-200 text-slate-600'
            }`}>
              <div className="flex items-center gap-2">
                <MessageSquare className="w-4 h-4 text-[#0096C7]" />
                <span>Tip: Click on any guild or the <strong>Chat</strong> button to open its live squad radio channel!</span>
              </div>
            </div>

            {teams.map(team => {
              const isSelected = team.id === selectedTeamId;
              const isEnemy = selectedTeamId !== null && team.id !== selectedTeamId;

              return (
                <div
                  key={team.id}
                  className={`p-4 sm:p-5 rounded-xl border transition-all ${
                    isSelected
                      ? isDarkMode
                        ? 'bg-[#0096C7]/15 border-[#0096C7] shadow-[0_0_20px_rgba(0,150,199,0.25)]'
                        : 'bg-blue-50/80 border-[#0096C7] shadow-md'
                      : isDarkMode
                      ? 'bg-[#16192B] border-[#2C324A] hover:border-[#0096C7]/60'
                      : 'bg-white border-slate-200 hover:border-[#0096C7] shadow-sm'
                  }`}
                >
                  <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
                    <div 
                      className="flex items-start gap-3.5 cursor-pointer flex-1"
                      onClick={() => openComms('team', { id: team.id, name: team.name, type: 'team', color: team.color })}
                    >
                      <div
                        className="w-12 h-12 rounded-xl flex items-center justify-center border shrink-0"
                        style={{
                          backgroundColor: `${team.color}20`,
                          borderColor: team.color,
                        }}
                      >
                        {getTeamIcon(team.id)}
                      </div>
                      <div>
                        <div className="flex items-center gap-2">
                          <h3 className={`font-display font-bold text-base ${isDarkMode ? 'text-white' : 'text-slate-900'}`}>
                            {team.name}
                          </h3>
                          {isSelected && (
                            <span className="text-[10px] font-mono font-bold px-2 py-0.5 rounded bg-green-500/20 text-green-500 border border-green-500/30 flex items-center gap-1">
                              <CheckCircle className="w-3 h-3" />
                              ACTIVE GUILD
                            </span>
                          )}
                        </div>
                        <p className={`text-xs line-clamp-1 mt-0.5 ${isDarkMode ? 'text-white/60' : 'text-slate-600'}`}>
                          {team.description}
                        </p>
                        <div className={`flex flex-wrap items-center gap-3 mt-1.5 text-[11px] font-mono ${
                          isDarkMode ? 'text-white/50' : 'text-slate-500'
                        }`}>
                          <span className="text-green-500 font-semibold flex items-center gap-1">
                            <span className="w-2 h-2 rounded-full bg-green-500 animate-pulse" />
                            {team.membersOnline} online
                          </span>
                          <span>•</span>
                          <span>{team.completedJobCount} completed contracts</span>
                          <span>•</span>
                          <span className="text-[#D4AF37] font-semibold">★ {team.rating}</span>
                        </div>
                      </div>
                    </div>

                    {/* Actions: Direct Chat, Join, Declare War */}
                    <div className="flex items-center gap-2 shrink-0">
                      {/* Direct Guild Chat Button */}
                      <button
                        onClick={() => openComms('team', { id: team.id, name: team.name, type: 'team', color: team.color })}
                        className={`flex items-center gap-1.5 px-3 py-2 rounded-xl border text-xs font-mono font-bold transition shadow-sm ${
                          isDarkMode
                            ? 'bg-[#0096C7]/20 border-[#0096C7] text-[#4DBBDF] hover:bg-[#0096C7]/30'
                            : 'bg-blue-100/70 border-blue-400 text-blue-700 hover:bg-blue-200'
                        }`}
                        title={`Open Guild Chat with ${team.name}`}
                      >
                        <MessageSquare className="w-4 h-4 text-[#0096C7]" />
                        <span>Guild Chat</span>
                      </button>

                      {isEnemy && (
                        <button
                          onClick={() => setWarEnemy({ id: team.id, name: team.name })}
                          className={`p-2 rounded-xl border transition ${
                            isDarkMode
                              ? 'bg-[#E74C3C]/10 border-[#E74C3C]/50 text-[#E74C3C] hover:bg-[#E74C3C]/20'
                              : 'bg-red-50 border-red-300 text-red-600 hover:bg-red-100'
                          }`}
                          title={`Declare War on ${team.name}`}
                        >
                          <Swords className="w-4 h-4" />
                        </button>
                      )}

                      {!isSelected ? (
                        <button
                          onClick={() => selectTeam(team.id)}
                          className="px-3.5 py-2 rounded-xl bg-[#0096C7] hover:bg-[#0082ad] text-white text-xs font-bold font-mono transition shadow-sm"
                        >
                          Join Guild
                        </button>
                      ) : (
                        <button
                          disabled
                          className="px-3 py-2 rounded-xl bg-green-500/20 text-green-500 border border-green-500/40 text-xs font-mono font-bold"
                        >
                          Active
                        </button>
                      )}
                    </div>
                  </div>
                </div>
              );
            })}
          </div>
        )}

        {/* TAB 2: FRIENDS & SQUAD UNITS */}
        {activeTab === 'friends' && (
          <div className="space-y-3">
            <div className={`p-3 rounded-xl border flex items-center justify-between text-xs ${
              isDarkMode ? 'bg-[#121629] border-[#2C324A] text-white/70' : 'bg-white border-slate-200 text-slate-600'
            }`}>
              <div className="flex items-center gap-2">
                <Radio className="w-4 h-4 text-[#00FF88]" />
                <span>Squad transceivers online. Click on any friend to open encrypted direct chat!</span>
              </div>
              <span className="text-[10px] font-mono text-[#00FF88] font-bold">5 OPERATORS ACTIVE</span>
            </div>

            <div className="grid grid-cols-1 md:grid-cols-2 gap-3">
              {friends.map(friend => {
                return (
                  <div
                    key={friend.id}
                    onClick={() => openComms('direct', { id: friend.id, name: friend.callsign || friend.name, type: 'friend', color: friend.color })}
                    className={`p-4 rounded-xl border transition-all cursor-pointer group ${
                      isDarkMode
                        ? 'bg-[#16192B] border-[#2C324A] hover:border-[#00FF88] hover:shadow-[0_0_15px_rgba(0,255,136,0.2)]'
                        : 'bg-white border-slate-200 hover:border-[#00FF88] hover:shadow-md'
                    }`}
                  >
                    <div className="flex items-start justify-between gap-3">
                      <div className="flex items-center gap-3">
                        <div
                          className="w-11 h-11 rounded-xl flex items-center justify-center font-bold text-xs border relative"
                          style={{
                            backgroundColor: `${friend.color}25`,
                            borderColor: friend.color,
                            color: friend.color,
                          }}
                        >
                          <User className="w-5 h-5" />
                          <span className="absolute -bottom-1 -right-1 w-3 h-3 rounded-full bg-green-500 border-2 border-[#16192B]" />
                        </div>
                        <div>
                          <div className="flex items-center gap-2">
                            <h4 className={`font-display font-bold text-sm ${isDarkMode ? 'text-white' : 'text-slate-900'} group-hover:text-[#00FF88] transition`}>
                              {friend.callsign}
                            </h4>
                            <span className="text-[10px] font-mono uppercase px-1.5 py-0.2 rounded bg-[#00FF88]/20 text-[#00FF88] border border-[#00FF88]/40 font-semibold">
                              {friend.status}
                            </span>
                          </div>
                          <p className={`text-xs line-clamp-1 ${isDarkMode ? 'text-white/60' : 'text-slate-500'}`}>
                            {friend.role || friend.name}
                          </p>
                        </div>
                      </div>

                      {/* Chat Trigger Button */}
                      <button
                        onClick={(e) => {
                          e.stopPropagation();
                          openComms('direct', { id: friend.id, name: friend.callsign || friend.name, type: 'friend', color: friend.color });
                        }}
                        className="px-3 py-1.5 rounded-lg bg-[#00FF88]/20 border border-[#00FF88] text-[#00FF88] hover:bg-[#00FF88]/30 text-xs font-mono font-bold flex items-center gap-1 transition shadow-sm shrink-0"
                      >
                        <MessageSquare className="w-3.5 h-3.5" />
                        <span>Chat</span>
                      </button>
                    </div>

                    <div className={`mt-3 pt-2.5 border-t grid grid-cols-2 gap-2 text-[11px] font-mono ${
                      isDarkMode ? 'border-[#2C324A] text-white/60' : 'border-slate-100 text-slate-500'
                    }`}>
                      <div className="flex items-center gap-1.5 truncate">
                        <MapPin className="w-3.5 h-3.5 text-[#0096C7] shrink-0" />
                        <span className="truncate">{friend.street}</span>
                      </div>
                      <div className="flex items-center gap-1.5">
                        <Radio className="w-3.5 h-3.5 text-[#D4AF37] shrink-0" />
                        <span>Freq: <strong className={isDarkMode ? 'text-white' : 'text-slate-800'}>{friend.freq}</strong></span>
                      </div>
                    </div>

                    <div className="mt-2 flex items-center justify-between text-[10px] font-mono pt-1">
                      <span className="text-[#0096C7] font-semibold">Guild: {friend.assignedTeamName}</span>
                      <span className="text-green-500 font-semibold flex items-center gap-1">
                        <Battery className="w-3 h-3" /> {friend.battery}%
                      </span>
                    </div>
                  </div>
                );
              })}
            </div>
          </div>
        )}

        {/* TAB 3: MARKETPLACE */}
        {activeTab === 'marketplace' && (
          <div className="space-y-4">
            {/* Filter Chips & Create Button */}
            <div className="flex items-center justify-between gap-2">
              <div className="flex items-center gap-1.5 overflow-x-auto no-scrollbar">
                {[
                  { id: 'all', label: 'All' },
                  { id: 'forSale', label: '💰 For Sale' },
                  { id: 'wantedToBuy', label: '🛒 Wanted' },
                  { id: 'forRent', label: '🔑 For Rent' },
                ].map(filter => (
                  <button
                    key={filter.id}
                    onClick={() => setListingFilter(filter.id as any)}
                    className={`px-3 py-1.5 rounded-lg text-xs font-mono font-semibold transition ${
                      listingFilter === filter.id
                        ? 'bg-[#0096C7] text-white'
                        : isDarkMode
                        ? 'bg-[#16192B] border border-[#2C324A] text-white/60 hover:text-white'
                        : 'bg-white border border-slate-200 text-slate-700 hover:bg-slate-50'
                    }`}
                  >
                    {filter.label}
                  </button>
                ))}
              </div>

              <button
                onClick={() => setShowCreateModal(true)}
                className="flex items-center gap-1 px-3 py-1.5 rounded-lg bg-[#D4AF37] hover:bg-[#c4a132] text-black text-xs font-bold shrink-0 transition"
              >
                <Plus className="w-4 h-4" />
                <span>Create Listing</span>
              </button>
            </div>

            {/* Listings Grid */}
            <div className="space-y-3">
              {marketplaceTasks.map(item => {
                const isRent = item.listingType === 'forRent';
                const isWanted = item.listingType === 'wantedToBuy';

                return (
                  <div
                    key={item.id}
                    className={`p-4 rounded-xl border transition space-y-2 ${
                      isDarkMode
                        ? 'bg-[#16192B] border-[#2C324A] hover:border-[#0096C7]/50'
                        : 'bg-white border-slate-200 hover:border-[#0096C7] shadow-sm'
                    }`}
                  >
                    <div className="flex items-start justify-between gap-3">
                      <div>
                        <div className="flex items-center gap-2 mb-1">
                          <span
                            className={`text-[10px] font-mono font-bold px-2 py-0.5 rounded border ${
                              isRent
                                ? 'bg-blue-500/20 text-blue-400 border-blue-500/40'
                                : isWanted
                                ? 'bg-orange-500/20 text-orange-400 border-orange-500/40'
                                : 'bg-green-500/20 text-green-500 border-green-500/40'
                            }`}
                          >
                            {isRent ? 'FOR RENT' : isWanted ? 'WANTED' : 'FOR SALE'}
                          </span>
                          <span className={`text-xs ${isDarkMode ? 'text-white/50' : 'text-slate-500'}`}>{item.category}</span>
                        </div>
                        <h4 className={`font-semibold text-sm ${isDarkMode ? 'text-white' : 'text-slate-900'}`}>{item.title}</h4>
                      </div>
                      <div className="text-right">
                        <span className="text-base font-mono font-bold text-[#D4AF37]">
                          ${item.budgetAmount}
                        </span>
                        {isRent && (
                          <span className={`text-[10px] block ${isDarkMode ? 'text-white/40' : 'text-slate-400'}`}>
                            /{item.rentalDuration || 'day'}
                          </span>
                        )}
                      </div>
                    </div>

                    <p className={`text-xs leading-relaxed line-clamp-2 ${isDarkMode ? 'text-white/70' : 'text-slate-600'}`}>
                      {item.description}
                    </p>

                    <div className={`flex items-center justify-between pt-2 border-t text-xs ${
                      isDarkMode ? 'border-[#2C324A] text-white/50' : 'border-slate-100 text-slate-500'
                    }`}>
                      <span>📍 {item.locationLabel}</span>
                      <button 
                        onClick={() => openComms('team', { id: item.creatorTeamId || 'water', name: item.creatorName || 'Guild', type: 'team' })}
                        className="text-[#0096C7] font-mono hover:underline flex items-center gap-1"
                      >
                        <MessageSquare className="w-3 h-3" />
                        <span>By: {item.creatorName || 'Guild'}</span>
                      </button>
                    </div>
                  </div>
                );
              })}
            </div>
          </div>
        )}

        {/* TAB 4: WARS */}
        {activeTab === 'wars' && (
          <div className="space-y-4">
            {wars.length === 0 ? (
              <div className={`text-center py-16 border rounded-2xl p-6 ${
                isDarkMode ? 'bg-[#16192B] border-[#2C324A]' : 'bg-white border-slate-200 shadow-sm'
              }`}>
                <Swords className={`w-12 h-12 mx-auto mb-2 ${isDarkMode ? 'text-white/20' : 'text-slate-300'}`} />
                <h3 className={`font-display font-semibold ${isDarkMode ? 'text-white' : 'text-slate-900'}`}>No Active Guild Wars</h3>
                <p className={`text-xs mt-1 ${isDarkMode ? 'text-white/50' : 'text-slate-500'}`}>
                  Join a team, then challenge rival factions from the My Guilds tab!
                </p>
              </div>
            ) : (
              wars.map(war => {
                const challenger = getTeamName(war.challengerTeamId);
                const defender = getTeamName(war.defenderTeamId);

                return (
                  <div
                    key={war.id}
                    className={`p-5 rounded-2xl border-2 space-y-4 ${
                      isDarkMode
                        ? 'bg-[#16192B] border-[#E74C3C]/80 shadow-[0_0_25px_rgba(231,76,60,0.25)]'
                        : 'bg-white border-red-400 shadow-md'
                    }`}
                  >
                    {/* Status Header */}
                    <div className="flex items-center justify-center gap-2">
                      <span className="text-xs font-mono font-bold uppercase tracking-widest text-[#E74C3C] px-3 py-1 rounded bg-[#E74C3C]/15 border border-[#E74C3C]/40 flex items-center gap-1.5">
                        <Swords className="w-4 h-4 animate-pulse" />
                        ACTIVE TERRITORIAL WAR
                      </span>
                    </div>

                    {/* Battle Face-off */}
                    <div className="flex items-center justify-around text-center py-2">
                      {/* Challenger */}
                      <div className="flex-1 cursor-pointer" onClick={() => openComms('team', { id: war.challengerTeamId, name: challenger, type: 'team' })}>
                        <div className="w-12 h-12 rounded-xl bg-[#0096C7]/20 border border-[#0096C7] flex items-center justify-center mx-auto mb-1">
                          {getTeamIcon(war.challengerTeamId)}
                        </div>
                        <h4 className={`font-display font-bold text-sm ${isDarkMode ? 'text-white' : 'text-slate-900'}`}>{challenger}</h4>
                        <div className="text-3xl font-mono font-bold text-[#0096C7] mt-1">
                          {war.challengerScore}
                        </div>
                      </div>

                      <div className={`text-2xl font-mono font-bold px-4 ${isDarkMode ? 'text-white/30' : 'text-slate-300'}`}>
                        VS
                      </div>

                      {/* Defender */}
                      <div className="flex-1 cursor-pointer" onClick={() => openComms('team', { id: war.defenderTeamId, name: defender, type: 'team' })}>
                        <div className="w-12 h-12 rounded-xl bg-[#E74C3C]/20 border border-[#E74C3C] flex items-center justify-center mx-auto mb-1">
                          {getTeamIcon(war.defenderTeamId)}
                        </div>
                        <h4 className={`font-display font-bold text-sm ${isDarkMode ? 'text-white' : 'text-slate-900'}`}>{defender}</h4>
                        <div className="text-3xl font-mono font-bold text-[#E74C3C] mt-1">
                          {war.defenderScore}
                        </div>
                      </div>
                    </div>

                    {/* War Message */}
                    {war.message && (
                      <p className={`text-xs italic text-center px-4 py-2 rounded-lg border ${
                        isDarkMode ? 'text-white/70 bg-[#0C0F1D] border-[#2C324A]' : 'text-slate-700 bg-slate-50 border-slate-200'
                      }`}>
                        "{war.message}"
                      </p>
                    )}
                  </div>
                );
              })
            )}
          </div>
        )}

        {/* Declare War Dialog */}
        {warEnemy && (
          <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/80 backdrop-blur-md animate-fade-in">
            <div className={`w-full max-w-md border-2 border-[#E74C3C] rounded-2xl p-6 space-y-4 shadow-[0_0_35px_rgba(231,76,60,0.4)] ${
              isDarkMode ? 'bg-[#16192B]' : 'bg-white'
            }`}>
              <div className="flex items-center justify-between">
                <div className="flex items-center gap-2 text-[#E74C3C]">
                  <Swords className="w-6 h-6 animate-pulse" />
                  <h3 className={`font-display font-bold text-base ${isDarkMode ? 'text-white' : 'text-slate-900'}`}>
                    DECLARE TERRITORIAL WAR
                  </h3>
                </div>
                <button onClick={() => setWarEnemy(null)} className={isDarkMode ? 'text-white/50 hover:text-white' : 'text-slate-400 hover:text-slate-700'}>
                  <X className="w-5 h-5" />
                </button>
              </div>

              <p className={`text-xs leading-relaxed ${isDarkMode ? 'text-white/80' : 'text-slate-700'}`}>
                You are about to declare official faction war against <strong className="text-[#E74C3C]">{warEnemy.name}</strong>.
              </p>

              <div>
                <label className={`text-xs font-mono block mb-1 ${isDarkMode ? 'text-white/60' : 'text-slate-500'}`}>
                  CASUS BELLI / WAR DECLARATION MESSAGE
                </label>
                <textarea
                  rows={3}
                  value={warMessage}
                  onChange={e => setWarMessage(e.target.value)}
                  className={`w-full border focus:border-[#E74C3C] rounded-xl p-3 text-xs focus:outline-none ${
                    isDarkMode ? 'bg-[#0C0F1D] border-[#2C324A] text-white' : 'bg-slate-50 border-slate-300 text-slate-900'
                  }`}
                />
              </div>

              <div className="flex justify-end gap-2 pt-2">
                <button
                  type="button"
                  onClick={() => setWarEnemy(null)}
                  className={`px-4 py-2 rounded-xl border text-xs font-semibold ${
                    isDarkMode ? 'border-[#2C324A] text-white/70 hover:text-white' : 'border-slate-300 text-slate-600 hover:text-slate-900'
                  }`}
                >
                  Cancel
                </button>
                <button
                  onClick={handleDeclareWarSubmit}
                  className="px-5 py-2 rounded-xl bg-[#E74C3C] hover:bg-red-700 text-white text-xs font-bold font-mono transition shadow-lg"
                >
                  Confirm Declaration
                </button>
              </div>
            </div>
          </div>
        )}

        {/* Create Marketplace Listing Modal */}
        {showCreateModal && (
          <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/80 backdrop-blur-md animate-fade-in">
            <div className={`w-full max-w-md border rounded-2xl p-6 space-y-4 shadow-[0_0_30px_rgba(0,150,199,0.3)] ${
              isDarkMode ? 'bg-[#16192B] border-[#2C324A]' : 'bg-white border-slate-300'
            }`}>
              <div className="flex items-center justify-between">
                <h3 className={`font-display font-bold text-base ${isDarkMode ? 'text-white' : 'text-slate-900'}`}>
                  Create Marketplace Listing
                </h3>
                <button onClick={() => setShowCreateModal(false)} className={isDarkMode ? 'text-white/50 hover:text-white' : 'text-slate-400 hover:text-slate-700'}>
                  <X className="w-5 h-5" />
                </button>
              </div>

              <form onSubmit={handleCreateListing} className="space-y-3">
                <div>
                  <label className={`text-xs font-mono block mb-1 ${isDarkMode ? 'text-white/60' : 'text-slate-500'}`}>Listing Type</label>
                  <select
                    value={listingType}
                    onChange={e => setListingType(e.target.value as ListingType)}
                    className={`w-full border rounded-xl px-3 py-2 text-xs focus:outline-none ${
                      isDarkMode ? 'bg-[#0C0F1D] border-[#2C324A] text-white' : 'bg-slate-50 border-slate-300 text-slate-900'
                    }`}
                  >
                    <option value="forSale">💰 For Sale</option>
                    <option value="wantedToBuy">🛒 Wanted (Buy)</option>
                    <option value="forRent">🔑 For Rent</option>
                  </select>
                </div>

                <div>
                  <label className={`text-xs font-mono block mb-1 ${isDarkMode ? 'text-white/60' : 'text-slate-500'}`}>Title</label>
                  <input
                    type="text"
                    required
                    value={listingTitle}
                    onChange={e => setListingTitle(e.target.value)}
                    placeholder="Item or service name..."
                    className={`w-full border rounded-xl px-3 py-2 text-xs focus:outline-none ${
                      isDarkMode ? 'bg-[#0C0F1D] border-[#2C324A] text-white' : 'bg-slate-50 border-slate-300 text-slate-900'
                    }`}
                  />
                </div>

                <div>
                  <label className={`text-xs font-mono block mb-1 ${isDarkMode ? 'text-white/60' : 'text-slate-500'}`}>Description</label>
                  <textarea
                    rows={2}
                    value={listingDesc}
                    onChange={e => setListingDesc(e.target.value)}
                    placeholder="Condition, pickup instructions, details..."
                    className={`w-full border rounded-xl px-3 py-2 text-xs focus:outline-none ${
                      isDarkMode ? 'bg-[#0C0F1D] border-[#2C324A] text-white' : 'bg-slate-50 border-slate-300 text-slate-900'
                    }`}
                  />
                </div>

                {listingType === 'forRent' && (
                  <div>
                    <label className={`text-xs font-mono block mb-1 ${isDarkMode ? 'text-white/60' : 'text-slate-500'}`}>Rental Period</label>
                    <select
                      value={rentalDuration}
                      onChange={e => setRentalDuration(e.target.value as RentalDuration)}
                      className={`w-full border rounded-xl px-3 py-2 text-xs focus:outline-none ${
                        isDarkMode ? 'bg-[#0C0F1D] border-[#2C324A] text-white' : 'bg-slate-50 border-slate-300 text-slate-900'
                      }`}
                    >
                      <option value="hourly">Per Hour</option>
                      <option value="daily">Per Day</option>
                      <option value="weekly">Per Week</option>
                      <option value="monthly">Per Month</option>
                    </select>
                  </div>
                )}

                <div>
                  <label className={`text-xs font-mono block mb-1 ${isDarkMode ? 'text-white/60' : 'text-slate-500'}`}>Price (USD)</label>
                  <input
                    type="number"
                    value={listingBounty}
                    onChange={e => setListingBounty(e.target.value)}
                    className={`w-full border rounded-xl px-3 py-2 text-xs focus:outline-none ${
                      isDarkMode ? 'bg-[#0C0F1D] border-[#2C324A] text-white' : 'bg-slate-50 border-slate-300 text-slate-900'
                    }`}
                  />
                </div>

                <div className="flex justify-end gap-2 pt-2">
                  <button
                    type="button"
                    onClick={() => setShowCreateModal(false)}
                    className={`px-4 py-2 rounded-xl border text-xs ${
                      isDarkMode ? 'border-[#2C324A] text-white/70' : 'border-slate-300 text-slate-600'
                    }`}
                  >
                    Cancel
                  </button>
                  <button
                    type="submit"
                    className="px-5 py-2 rounded-xl bg-[#0096C7] hover:bg-[#0082ad] text-white text-xs font-bold font-mono transition"
                  >
                    Publish Listing
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
