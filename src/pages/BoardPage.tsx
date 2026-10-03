import React, { useState } from 'react';
import { useApp } from '../context/AppContext';
import { Task, TaskCategory, GuildEvent } from '../types';
import { 
  Plus, 
  MapPin, 
  DollarSign, 
  Users, 
  ChevronDown, 
  ChevronUp, 
  Gavel, 
  CheckCircle, 
  Sliders, 
  Search, 
  Layers, 
  FileText, 
  ShieldCheck,
  Calendar,
  Sparkles,
  Clock,
  Coins,
  Radio,
  Flame
} from 'lucide-react';
import { FluoriteGlobeMap } from '../components/FluoriteGlobeMap';

interface BoardPageProps {
  onOpenCreateTask: () => void;
  onOpenCreateEvent?: () => void;
  onOpenMakeOffer: (task: Task) => void;
  onOpenTaskDetail: (task: Task) => void;
  onOpenVerify: (task: Task) => void;
}

// Distance helper
function getDistanceMi(lat1: number, lon1: number, lat2: number, lon2: number): number {
  const R = 3958.8; // Earth radius in miles
  const dLat = ((lat2 - lat1) * Math.PI) / 180;
  const dLon = ((lon2 - lon1) * Math.PI) / 180;
  const a =
    Math.sin(dLat / 2) * Math.sin(dLat / 2) +
    Math.cos((lat1 * Math.PI) / 180) *
      Math.cos((lat2 * Math.PI) / 180) *
      Math.sin(dLon / 2) *
      Math.sin(dLon / 2);
  const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
  return R * c;
}

const BASE_LAT = 30.2672;
const BASE_LNG = -97.7431;

export const BoardPage: React.FC<BoardPageProps> = ({
  onOpenCreateTask,
  onOpenCreateEvent,
  onOpenMakeOffer,
  onOpenTaskDetail,
  onOpenVerify,
}) => {
  const { tasks, events, toggleRsvp, selectedTeamId, teams, searchQuery, offers, isDarkMode } = useApp();
  const [activeTab, setActiveTab] = useState<'main' | 'myClub' | 'events' | 'local' | 'interacting'>('main');
  const [selectedCategory, setSelectedCategory] = useState<string>('all');
  const [expandedTaskId, setExpandedTaskId] = useState<string | null>(null);
  const [searchRadius, setSearchRadius] = useState<number>(15);

  const categories: string[] = [
    'all',
    'Field Cleanup',
    'Home Improvement',
    'Automotive & OBD',
    'Tech & Hardware',
    'Logistics & Delivery',
  ];

  // Filtering tasks
  const filteredTasks = tasks.filter(task => {
    if (searchQuery) {
      const q = searchQuery.toLowerCase();
      const match =
        task.title.toLowerCase().includes(q) ||
        task.description.toLowerCase().includes(q) ||
        task.category.toLowerCase().includes(q) ||
        task.locationLabel.toLowerCase().includes(q) ||
        task.requiredSkills.some(s => s.toLowerCase().includes(q));
      if (!match) return false;
    }

    if (selectedCategory !== 'all' && task.category !== selectedCategory) {
      return false;
    }

    if (activeTab === 'myClub') {
      return task.creatorTeamId === selectedTeamId || task.creatorId === selectedTeamId;
    }

    return true;
  });

  // Filter tasks within search radius for local tab
  const nearbyTasksWithDist = tasks.map(task => {
    const lat = task.lat || BASE_LAT + 0.01;
    const lng = task.lng || BASE_LNG + 0.01;
    const distMi = getDistanceMi(BASE_LAT, BASE_LNG, lat, lng);
    return { task, distMi };
  }).filter(item => item.distMi <= searchRadius)
    .sort((a, b) => a.distMi - b.distMi);

  // Filter events
  const filteredEvents = events.filter(ev => {
    if (searchQuery) {
      const q = searchQuery.toLowerCase();
      return (
        ev.title.toLowerCase().includes(q) ||
        ev.description.toLowerCase().includes(q) ||
        ev.category.toLowerCase().includes(q) ||
        ev.locationLabel.toLowerCase().includes(q)
      );
    }
    return true;
  });

  const activeTeam = teams.find(t => t.id === selectedTeamId);

  return (
    <div className="pb-24 pt-2">
      <div className="max-w-4xl mx-auto px-4">
        {/* Navigation Tabs */}
        <div className={`flex items-center space-x-1 border-b mb-4 overflow-x-auto no-scrollbar ${
          isDarkMode ? 'border-[#2C324A]' : 'border-slate-200'
        }`}>
          {[
            { id: 'main', label: 'Main Board' },
            { id: 'myClub', label: 'My Club' },
            { id: 'events', label: `Guild Events (${events.length})` },
            { id: 'local', label: 'Local Radar' },
            { id: 'interacting', label: `Bids (${offers.length})` },
          ].map(tab => (
            <button
              key={tab.id}
              onClick={() => setActiveTab(tab.id as any)}
              className={`px-4 py-2.5 text-xs font-semibold whitespace-nowrap border-b-2 transition ${
                activeTab === tab.id
                  ? 'border-[#0096C7] text-[#0096C7] bg-[#0096C7]/10'
                  : isDarkMode 
                  ? 'border-transparent text-white/60 hover:text-white' 
                  : 'border-transparent text-slate-500 hover:text-slate-800'
              }`}
            >
              {tab.label}
            </button>
          ))}
        </div>

        {/* Tab 1 & 2: Main / My Club */}
        {(activeTab === 'main' || activeTab === 'myClub') && (
          <div>
            {/* Category Filter Chips */}
            <div className="flex items-center gap-2 overflow-x-auto pb-3 mb-3 no-scrollbar">
              {categories.map(cat => (
                <button
                  key={cat}
                  onClick={() => setSelectedCategory(cat)}
                  className={`px-3 py-1.5 rounded-lg text-xs font-medium whitespace-nowrap transition ${
                    selectedCategory === cat
                      ? 'bg-[#0096C7] text-white font-semibold shadow-[0_0_10px_rgba(0,150,199,0.3)]'
                      : isDarkMode
                      ? 'bg-[#16192B] border border-[#2C324A] text-white/70 hover:text-white'
                      : 'bg-white border border-slate-200 text-slate-700 hover:bg-slate-50 shadow-sm'
                  }`}
                >
                  {cat === 'all' ? 'All Categories' : cat}
                </button>
              ))}
            </div>

            {/* Task Feed */}
            {filteredTasks.length === 0 ? (
              <div className={`text-center py-16 border rounded-2xl p-8 ${
                isDarkMode ? 'bg-[#16192B]/50 border-[#2C324A]' : 'bg-white border-slate-200 shadow-sm'
              }`}>
                <Layers className={`w-12 h-12 mx-auto mb-3 ${isDarkMode ? 'text-white/30' : 'text-slate-300'}`} />
                <h3 className={`font-display font-semibold text-base ${isDarkMode ? 'text-white' : 'text-slate-900'}`}>
                  No tasks found
                </h3>
                <p className={`text-xs mt-1 max-w-sm mx-auto ${isDarkMode ? 'text-white/50' : 'text-slate-500'}`}>
                  {activeTab === 'myClub'
                    ? `No tasks currently posted under ${activeTeam?.name || 'your club'}. Post one to get started!`
                    : 'Try changing category filters or posting a new task to the network.'}
                </p>
                <button
                  onClick={onOpenCreateTask}
                  className="mt-4 px-4 py-2 bg-[#0096C7] hover:bg-[#0082ad] text-white text-xs font-bold rounded-xl transition shadow-[0_0_12px_rgba(0,150,199,0.3)]"
                >
                  + Post First Task
                </button>
              </div>
            ) : (
              <div className="space-y-4">
                {filteredTasks.map(task => {
                  const isExpanded = expandedTaskId === task.id;

                  return (
                    <div
                      key={task.id}
                      className={`border rounded-xl overflow-hidden transition-all duration-200 ${
                        isDarkMode
                          ? 'bg-[#16192B] border-[#2C324A] hover:border-[#0096C7]/50 shadow-sm'
                          : 'bg-white border-slate-200 hover:border-[#0096C7] shadow-sm'
                      }`}
                    >
                      {/* Card Main Header */}
                      <div className="p-4 sm:p-5">
                        <div className="flex items-start justify-between gap-3">
                          <div className="flex-1 min-w-0">
                            <div className="flex items-center gap-2 mb-1.5 flex-wrap">
                              <span className="text-[10px] font-mono uppercase tracking-wider px-2 py-0.5 rounded bg-[#0096C7]/15 text-[#0096C7] border border-[#0096C7]/30 font-semibold">
                                {task.category}
                              </span>
                              {task.listingType === 'forRent' && (
                                <span className="text-[10px] font-mono px-2 py-0.5 rounded bg-[#D4AF37]/15 text-[#D4AF37] border border-[#D4AF37]/30 font-semibold">
                                  RENTAL ({task.rentalDuration?.toUpperCase() || 'DAILY'})
                                </span>
                              )}
                              <span className={`text-xs flex items-center gap-1 ${
                                isDarkMode ? 'text-white/40' : 'text-slate-400'
                              }`}>
                                <MapPin className="w-3 h-3 text-[#0096C7]" />
                                {task.locationLabel}
                              </span>
                            </div>

                            <h3 
                              onClick={() => onOpenTaskDetail(task)}
                              className={`font-display font-bold text-base hover:text-[#0096C7] cursor-pointer transition truncate ${
                                isDarkMode ? 'text-white' : 'text-slate-900'
                              }`}
                            >
                              {task.title}
                            </h3>

                            <p className={`text-xs line-clamp-2 mt-1 leading-relaxed ${
                              isDarkMode ? 'text-white/70' : 'text-slate-600'
                            }`}>
                              {task.description}
                            </p>
                          </div>

                          {/* Bounty Badge */}
                          <div className="text-right shrink-0">
                            <div className="font-mono font-bold text-lg text-[#D4AF37]">
                              ${task.budgetAmount}
                            </div>
                            <span className={`text-[10px] font-mono block ${
                              isDarkMode ? 'text-white/40' : 'text-slate-400'
                            }`}>
                              {task.bidCount} {task.bidCount === 1 ? 'bid' : 'bids'}
                            </span>
                          </div>
                        </div>

                        {/* Badges / Skills */}
                        <div className={`flex items-center justify-between gap-2 mt-3 pt-3 border-t ${
                          isDarkMode ? 'border-[#2C324A]/70' : 'border-slate-100'
                        }`}>
                          <div className="flex items-center gap-1.5 flex-wrap">
                            <span className={`text-[10px] flex items-center gap-1 mr-1 ${
                              isDarkMode ? 'text-white/50' : 'text-slate-500'
                            }`}>
                              <Users className="w-3 h-3" />
                              {task.workerCount}
                            </span>
                            {task.requiredSkills.slice(0, 2).map(skill => (
                              <span
                                key={skill}
                                className={`text-[10px] px-2 py-0.5 rounded border ${
                                  isDarkMode 
                                    ? 'bg-[#0C0F1D] text-white/80 border-[#2C324A]' 
                                    : 'bg-slate-100 text-slate-700 border-slate-200'
                                }`}
                              >
                                {skill}
                              </span>
                            ))}
                            {task.requiredSkills.length > 2 && (
                              <span className={`text-[10px] font-mono ${
                                isDarkMode ? 'text-white/40' : 'text-slate-400'
                              }`}>
                                +{task.requiredSkills.length - 2}
                              </span>
                            )}
                          </div>

                          <div className="flex items-center gap-2">
                            <button
                              onClick={() => setExpandedTaskId(isExpanded ? null : task.id)}
                              className={`p-1.5 rounded transition ${
                                isDarkMode ? 'text-white/50 hover:text-white' : 'text-slate-400 hover:text-slate-700'
                              }`}
                              title="Expand details"
                            >
                              {isExpanded ? (
                                <ChevronUp className="w-4 h-4 text-[#0096C7]" />
                              ) : (
                                <ChevronDown className="w-4 h-4" />
                              )}
                            </button>
                            <button
                              onClick={() => onOpenMakeOffer(task)}
                              className="px-3 py-1.5 bg-[#D4AF37] hover:bg-[#c4a132] text-black text-xs font-bold rounded-lg transition shadow-sm"
                            >
                              Bid
                            </button>
                          </div>
                        </div>
                      </div>

                      {/* Expandable Accordion Body */}
                      {isExpanded && (
                        <div className={`px-5 pb-5 pt-2 border-t text-xs space-y-3 animate-fade-in ${
                          isDarkMode ? 'bg-[#111424] border-[#2C324A]' : 'bg-slate-50 border-slate-200'
                        }`}>
                          <div className="space-y-1">
                            <span className={`text-[11px] font-bold uppercase tracking-wider ${
                              isDarkMode ? 'text-white/60' : 'text-slate-500'
                            }`}>
                              Full Instructions
                            </span>
                            <p className={`leading-relaxed whitespace-pre-line ${
                              isDarkMode ? 'text-white/80' : 'text-slate-700'
                            }`}>
                              {task.description}
                            </p>
                          </div>

                          <div className={`grid grid-cols-2 gap-2 pt-2 border-t text-[11px] ${
                            isDarkMode ? 'border-[#2C324A]/60 text-white/70' : 'border-slate-200 text-slate-600'
                          }`}>
                            <div>📅 Desired Date: <span className={isDarkMode ? 'text-white font-medium' : 'text-slate-900 font-medium'}>{task.desiredCompletionDate}</span></div>
                            <div>🛡️ Verified ID: <span className={isDarkMode ? 'text-white font-medium' : 'text-slate-900 font-medium'}>{task.requireId ? 'Required' : 'Optional'}</span></div>
                            <div>🏢 Posted by: <span className={isDarkMode ? 'text-white font-medium' : 'text-slate-900 font-medium'}>{task.creatorName || 'Guild'}</span></div>
                            <div>⚖️ Escrow: <span className="text-[#0096C7] font-medium font-mono">Fluoridian Lock</span></div>
                          </div>

                          <div className="flex items-center justify-between pt-2">
                            <button
                              onClick={() => onOpenTaskDetail(task)}
                              className="text-xs text-[#0096C7] hover:underline font-semibold"
                            >
                              View Full Task Spec →
                            </button>
                            <button
                              onClick={() => onOpenVerify(task)}
                              className="flex items-center gap-1 px-3 py-1.5 rounded-lg border border-[#0096C7] text-[#0096C7] hover:bg-[#0096C7]/10 text-xs font-semibold transition"
                            >
                              <CheckCircle className="w-3.5 h-3.5" />
                              <span>Verify Work</span>
                            </button>
                          </div>
                        </div>
                      )}
                    </div>
                  );
                })}
              </div>
            )}
          </div>
        )}

        {/* Tab: Events */}
        {activeTab === 'events' && (
          <div className="space-y-4">
            <div className={`p-4 border rounded-xl flex flex-wrap items-center justify-between gap-3 ${
              isDarkMode ? 'bg-[#16192B] border-[#2C324A]' : 'bg-white border-slate-200 shadow-sm'
            }`}>
              <div className="flex items-center gap-3">
                <div className="w-10 h-10 rounded-xl bg-[#5300FF]/20 border border-[#5300FF] flex items-center justify-center text-[#B185FF] shadow-[0_0_12px_rgba(83,0,255,0.3)]">
                  <Calendar className="w-5 h-5" />
                </div>
                <div>
                  <h3 className={`font-display font-bold text-base ${isDarkMode ? 'text-white' : 'text-slate-900'}`}>
                    Guild Operations & Events
                  </h3>
                  <p className={`text-xs ${isDarkMode ? 'text-white/60' : 'text-slate-600'}`}>
                    Scheduled community operations, raids, cleanups, and tactical meetups.
                  </p>
                </div>
              </div>

              {onOpenCreateEvent && (
                <button
                  onClick={onOpenCreateEvent}
                  className="flex items-center gap-1.5 px-3.5 py-2 rounded-xl bg-gradient-to-r from-[#5300FF] to-[#0096C7] hover:opacity-90 text-white text-xs font-bold shadow-[0_0_15px_rgba(83,0,255,0.3)] transition"
                >
                  <Plus className="w-4 h-4" />
                  <span>+ Create Event</span>
                </button>
              )}
            </div>

            {filteredEvents.length === 0 ? (
              <div className={`text-center py-16 border rounded-2xl p-8 ${
                isDarkMode ? 'bg-[#16192B]/50 border-[#2C324A]' : 'bg-white border-slate-200 shadow-sm'
              }`}>
                <Calendar className={`w-12 h-12 mx-auto mb-3 ${isDarkMode ? 'text-white/30' : 'text-slate-300'}`} />
                <h3 className={`font-display font-semibold text-base ${isDarkMode ? 'text-white' : 'text-slate-900'}`}>
                  No guild events scheduled
                </h3>
                <p className={`text-xs mt-1 max-w-sm mx-auto ${isDarkMode ? 'text-white/50' : 'text-slate-500'}`}>
                  Create the first event for your guild or community!
                </p>
                {onOpenCreateEvent && (
                  <button
                    onClick={onOpenCreateEvent}
                    className="mt-4 px-4 py-2 bg-[#5300FF] hover:bg-[#4300cc] text-white text-xs font-bold rounded-xl transition"
                  >
                    + Create Event
                  </button>
                )}
              </div>
            ) : (
              <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                {filteredEvents.map(ev => (
                  <div
                    key={ev.id}
                    className={`border rounded-xl p-4 space-y-3 transition shadow-sm ${
                      isDarkMode ? 'bg-[#16192B] border-[#2C324A] hover:border-[#5300FF]/50' : 'bg-white border-slate-200 hover:border-[#5300FF]'
                    }`}
                  >
                    <div className="flex items-start justify-between gap-2">
                      <div className="space-y-1">
                        <span className="text-[10px] font-mono uppercase tracking-wider px-2 py-0.5 rounded bg-[#5300FF]/20 text-[#B185FF] border border-[#5300FF]/40 font-semibold">
                          {ev.category}
                        </span>
                        <h4 className={`font-display font-bold text-sm ${isDarkMode ? 'text-white' : 'text-slate-900'}`}>
                          {ev.title}
                        </h4>
                      </div>
                      <span className="text-[11px] font-mono font-bold text-[#D4AF37] px-2 py-0.5 rounded bg-[#D4AF37]/10 border border-[#D4AF37]/30">
                        +{ev.rewardFlr} FLR
                      </span>
                    </div>

                    <p className={`text-xs leading-relaxed line-clamp-2 ${isDarkMode ? 'text-white/70' : 'text-slate-600'}`}>
                      {ev.description}
                    </p>

                    <div className={`space-y-1.5 text-[11px] pt-2 border-t ${
                      isDarkMode ? 'border-[#2C324A] text-white/70' : 'border-slate-100 text-slate-600'
                    }`}>
                      <div className="flex items-center gap-1.5">
                        <Clock className="w-3.5 h-3.5 text-[#0096C7]" />
                        <span>{ev.date} @ {ev.time}</span>
                      </div>
                      <div className="flex items-center gap-1.5">
                        <MapPin className="w-3.5 h-3.5 text-[#B185FF]" />
                        <span>{ev.locationLabel}</span>
                      </div>
                      <div className="flex items-center justify-between text-[10px] font-mono pt-1">
                        <span className="flex items-center gap-1">
                          <Users className="w-3 h-3 text-[#00FF88]" />
                          {ev.attendeesCount} / {ev.maxCapacity} Attending
                        </span>
                        <span className="text-[#0096C7] font-semibold">Host: {ev.hostName}</span>
                      </div>
                    </div>

                    <div className="pt-2 flex items-center justify-between gap-2 border-t border-slate-100/10">
                      <span className={`text-[10px] font-mono ${ev.isRsvp ? 'text-[#00FF88] font-bold' : isDarkMode ? 'text-white/40' : 'text-slate-400'}`}>
                        {ev.isRsvp ? '✓ RSVP CONFIRMED' : 'RSVP OPEN'}
                      </span>
                      <button
                        onClick={() => toggleRsvp(ev.id)}
                        className={`px-3 py-1.5 rounded-lg text-xs font-semibold transition ${
                          ev.isRsvp 
                            ? 'bg-[#00FF88]/20 text-[#00FF88] border border-[#00FF88]/40 hover:bg-[#00FF88]/30' 
                            : 'bg-[#5300FF] hover:bg-[#4300cc] text-white shadow-sm'
                        }`}
                      >
                        {ev.isRsvp ? 'Leave Event' : 'RSVP (+25 FLR)'}
                      </button>
                    </div>
                  </div>
                ))}
              </div>
            )}
          </div>
        )}

        {/* Tab 3: Local Radar */}
        {activeTab === 'local' && (
          <div className="space-y-4">
            {/* Radius Slider Bar */}
            <div className={`p-4 border rounded-xl space-y-3 transition-colors ${
              isDarkMode ? 'bg-[#16192B] border-[#2C324A]' : 'bg-white border-slate-200 shadow-sm'
            }`}>
              <div className="flex items-center justify-between">
                <span className={`text-xs font-bold uppercase tracking-wider flex items-center gap-1.5 ${
                  isDarkMode ? 'text-white' : 'text-slate-900'
                }`}>
                  <Sliders className="w-4 h-4 text-[#0096C7]" />
                  Search Radius: <span className="text-[#0096C7] font-mono font-bold">{searchRadius} Miles</span>
                </span>
                <span className="text-xs font-mono text-[#0096C7] font-semibold bg-[#0096C7]/15 px-2 py-0.5 rounded border border-[#0096C7]/30">
                  {nearbyTasksWithDist.length} Target(s) in Perimeter
                </span>
              </div>
              <input
                type="range"
                min="1"
                max="100"
                value={searchRadius}
                onChange={e => setSearchRadius(parseInt(e.target.value))}
                className={`w-full h-2.5 rounded-lg appearance-none cursor-pointer accent-[#0096C7] ${
                  isDarkMode ? 'bg-[#0C0F1D]' : 'bg-slate-200'
                }`}
              />
              <div className={`flex justify-between text-[10px] font-mono ${
                isDarkMode ? 'text-white/50' : 'text-slate-500'
              }`}>
                <span>1 mi (Walking)</span>
                <span>15 mi (City Grid)</span>
                <span>35 mi (Metro Austin)</span>
                <span>65 mi (County)</span>
                <span>100 mi (Central Texas)</span>
              </div>
            </div>

            {/* Fluorite 3D Globe Feature for Local Radar with Search Radius Connected! */}
            <FluoriteGlobeMap searchRadiusMiles={searchRadius} />

            {/* List of Nearby Tasks in Radius */}
            <div className="space-y-3">
              <div className="flex items-center justify-between">
                <h4 className={`text-xs font-mono uppercase tracking-wider ${
                  isDarkMode ? 'text-white/60' : 'text-slate-500'
                }`}>
                  Tasks within {searchRadius} miles ({nearbyTasksWithDist.length})
                </h4>
                <span className="text-[10px] font-mono text-[#0096C7]">
                  Origin: 400 Congress Ave HQ
                </span>
              </div>

              {nearbyTasksWithDist.length === 0 ? (
                <div className={`p-6 border rounded-xl text-center text-xs ${
                  isDarkMode ? 'bg-[#16192B] border-[#2C324A] text-white/50' : 'bg-white border-slate-200 text-slate-500'
                }`}>
                  No tasks currently inside this {searchRadius}-mile radar geofence. Try sliding to a wider radius.
                </div>
              ) : (
                nearbyTasksWithDist.map(({ task, distMi }) => (
                  <div
                    key={task.id}
                    onClick={() => onOpenTaskDetail(task)}
                    className={`p-3.5 border rounded-xl flex items-center justify-between cursor-pointer transition ${
                      isDarkMode 
                        ? 'bg-[#16192B] border-[#2C324A] hover:border-[#0096C7]' 
                        : 'bg-white border-slate-200 hover:border-[#0096C7] shadow-sm'
                    }`}
                  >
                    <div>
                      <div className="flex items-center gap-2 mb-0.5">
                        <span className="text-[9px] font-mono px-1.5 py-0.5 rounded bg-[#0096C7]/15 text-[#0096C7] font-semibold">
                          {task.category}
                        </span>
                        <h5 className={`font-semibold text-xs ${isDarkMode ? 'text-white' : 'text-slate-900'}`}>{task.title}</h5>
                      </div>
                      <span className={`text-[11px] flex items-center gap-1 ${isDarkMode ? 'text-white/50' : 'text-slate-500'}`}>
                        <MapPin className="w-3 h-3 text-[#0096C7]" />
                        {task.locationLabel}
                      </span>
                    </div>
                    <div className="text-right">
                      <span className="text-xs font-mono font-bold text-[#D4AF37]">${task.budgetAmount}</span>
                      <span className="text-[10px] font-mono text-[#0096C7] block font-semibold">{distMi.toFixed(1)} mi away</span>
                    </div>
                  </div>
                ))
              )}
            </div>
          </div>
        )}

        {/* Tab 4: Interacting (Bids & Negotiations) */}
        {activeTab === 'interacting' && (
          <div className="space-y-4">
            <div className={`p-4 border rounded-xl ${
              isDarkMode ? 'bg-[#16192B] border-[#2C324A]' : 'bg-white border-slate-200 shadow-sm'
            }`}>
              <div className="flex items-center gap-2 mb-2">
                <Gavel className="w-5 h-5 text-[#D4AF37]" />
                <h3 className={`font-display font-bold text-base ${isDarkMode ? 'text-white' : 'text-slate-900'}`}>
                  Active Contracts & Bids
                </h3>
              </div>
              <p className={`text-xs ${isDarkMode ? 'text-white/60' : 'text-slate-600'}`}>
                Review and respond to counteroffers, active negotiations, and escrow milestones.
              </p>
            </div>

            <div className="space-y-3">
              {offers.length === 0 ? (
                <div className={`text-center py-12 text-xs border rounded-xl ${
                  isDarkMode ? 'bg-[#16192B]/40 border-[#2C324A] text-white/40' : 'bg-white border-slate-200 text-slate-400'
                }`}>
                  No active bids or contracts in progress.
                </div>
              ) : (
                offers.map(offer => (
                  <div
                    key={offer.id}
                    className={`p-4 border rounded-xl space-y-2 transition ${
                      isDarkMode ? 'bg-[#16192B] border-[#2C324A]' : 'bg-white border-slate-200 shadow-sm'
                    }`}
                  >
                    <div className="flex items-center justify-between">
                      <span className="text-xs font-mono font-bold text-[#0096C7]">
                        BID ID: {offer.id}
                      </span>
                      <span className="text-xs font-mono font-bold text-[#D4AF37]">
                        ${offer.amount} USD
                      </span>
                    </div>

                    <h4 className={`text-sm font-semibold ${isDarkMode ? 'text-white' : 'text-slate-900'}`}>
                      {offer.taskTitle}
                    </h4>
                    <p className={`text-xs italic ${isDarkMode ? 'text-white/70' : 'text-slate-600'}`}>
                      "{offer.message}"
                    </p>

                    <div className={`flex items-center justify-between pt-2 border-t text-xs ${
                      isDarkMode ? 'border-[#2C324A] text-white/60' : 'border-slate-100 text-slate-500'
                    }`}>
                      <span>Provider: <strong className={isDarkMode ? 'text-white' : 'text-slate-800'}>{offer.providerName}</strong></span>
                      <span className="font-mono text-[#0096C7] font-semibold uppercase">{offer.status}</span>
                    </div>
                  </div>
                ))
              )}
            </div>
          </div>
        )}
      </div>
    </div>
  );
};
