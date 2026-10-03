import React, { useState } from 'react';
import { useApp } from '../context/AppContext';
import { EventCategory, GuildEvent } from '../types';
import { 
  Calendar, 
  Clock, 
  MapPin, 
  Sparkles, 
  Users, 
  Coins, 
  X, 
  CheckCircle, 
  Shield, 
  Flame, 
  Droplet, 
  TreePine, 
  Wind 
} from 'lucide-react';

interface CreateEventModalProps {
  isOpen: boolean;
  onClose: () => void;
}

const CATEGORIES: EventCategory[] = [
  'Guild Raid',
  'Community Meetup',
  'Tech Workshop',
  'Field Operation',
  'Sector Cleanup',
  'Tournament & War',
];

const PRESET_LOCATIONS = [
  { name: 'Lady Bird Harbor & Boardwalk', lat: 30.2585, lng: -97.7490, address: '111 Cesar Chavez St, Austin, TX' },
  { name: 'Vulcan Industrial Forge Depot', lat: 30.2640, lng: -97.7340, address: '901 E 5th St, Austin, TX' },
  { name: 'State Capitol Grounds & Foundry', lat: 30.2740, lng: -97.7410, address: '1200 Lavaca St, Austin, TX' },
  { name: 'Frost Bank Sky Spire Observation', lat: 30.2688, lng: -97.7420, address: '401 Congress Ave, Austin, TX' },
  { name: 'Downtown Central Command HQ', lat: 30.2672, lng: -97.7431, address: '400 Congress Ave, Austin, TX' },
  { name: 'Zilker Sector Operations Park', lat: 30.2669, lng: -97.7728, address: '2100 Barton Springs Rd, Austin, TX' },
];

export const CreateEventModal: React.FC<CreateEventModalProps> = ({ isOpen, onClose }) => {
  const { teams, selectedTeamId, createEvent } = useApp();

  const [title, setTitle] = useState('');
  const [description, setDescription] = useState('');
  const [category, setCategory] = useState<EventCategory>('Community Meetup');
  const [date, setDate] = useState('2026-10-15');
  const [time, setTime] = useState('18:00');
  const [selectedLocationIdx, setSelectedLocationIdx] = useState(0);
  const [customLocation, setCustomLocation] = useState('');
  const [maxCapacity, setMaxCapacity] = useState('50');
  const [rewardFlr, setRewardFlr] = useState('25');
  const [rewardExp, setRewardExp] = useState('100');
  const [hostTeamId, setHostTeamId] = useState(selectedTeamId || 'water');
  const [error, setError] = useState('');

  if (!isOpen) return null;

  const currentHostTeam = teams.find(t => t.id === hostTeamId) || teams[0];

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    if (!title.trim()) {
      setError('Please provide an event title.');
      return;
    }
    if (!description.trim()) {
      setError('Please provide an event description.');
      return;
    }

    const loc = PRESET_LOCATIONS[selectedLocationIdx];
    const finalLocationLabel = customLocation.trim() || loc.name;

    createEvent({
      title: title.trim(),
      description: description.trim(),
      category,
      hostTeamId,
      hostName: currentHostTeam.name,
      date,
      time,
      locationLabel: finalLocationLabel,
      lat: loc.lat,
      lng: loc.lng,
      maxCapacity: parseInt(maxCapacity) || 50,
      rewardFlr: parseInt(rewardFlr) || 20,
      rewardExp: parseInt(rewardExp) || 100,
      status: 'upcoming',
    });

    onClose();
  };

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/80 backdrop-blur-md animate-fade-in overflow-y-auto">
      <div className="w-full max-w-lg bg-[#121629] border border-[#00FFFF]/50 rounded-2xl p-5 sm:p-6 space-y-4 shadow-[0_0_35px_rgba(0,255,255,0.2)] my-8">
        {/* Header */}
        <div className="flex items-center justify-between border-b border-[#2C324A] pb-3">
          <div className="flex items-center gap-2.5">
            <div className="w-9 h-9 rounded-xl bg-[#00FFFF]/15 border border-[#00FFFF] flex items-center justify-center text-[#00FFFF] shadow-[0_0_12px_rgba(0,255,255,0.3)]">
              <Calendar className="w-5 h-5" />
            </div>
            <div>
              <h3 className="font-display font-bold text-base text-white">
                CREATE GUILD & SECTOR EVENT
              </h3>
              <p className="text-[10px] font-mono text-[#00FFFF]">
                Fluorite Decentralized Meetup & Operations Scheduler
              </p>
            </div>
          </div>
          <button
            onClick={onClose}
            className="p-1 rounded-lg text-white/50 hover:text-white hover:border-[#00FFFF] border border-transparent transition"
          >
            <X className="w-5 h-5" />
          </button>
        </div>

        {error && (
          <div className="p-2.5 rounded-xl bg-red-500/10 border border-red-500/30 text-xs font-mono text-red-400">
            {error}
          </div>
        )}

        <form onSubmit={handleSubmit} className="space-y-4">
          {/* Title */}
          <div>
            <label className="text-xs font-mono text-white/70 block mb-1">EVENT TITLE</label>
            <input
              type="text"
              placeholder="e.g., Downtown Drone Recon Rally & Mesh Calibration"
              value={title}
              onChange={e => setTitle(e.target.value)}
              className="w-full bg-[#080B15] border border-[#2C324A] focus:border-[#00FFFF] rounded-xl px-3.5 py-2 text-xs text-white focus:outline-none"
            />
          </div>

          {/* Category & Host Guild */}
          <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
            <div>
              <label className="text-xs font-mono text-white/70 block mb-1">CATEGORY</label>
              <select
                value={category}
                onChange={e => setCategory(e.target.value as EventCategory)}
                className="w-full bg-[#080B15] border border-[#2C324A] focus:border-[#00FFFF] rounded-xl px-3 py-2 text-xs text-white focus:outline-none"
              >
                {CATEGORIES.map(c => (
                  <option key={c} value={c} className="bg-[#121629]">
                    {c}
                  </option>
                ))}
              </select>
            </div>

            <div>
              <label className="text-xs font-mono text-white/70 block mb-1">HOST GUILD</label>
              <select
                value={hostTeamId}
                onChange={e => setHostTeamId(e.target.value)}
                className="w-full bg-[#080B15] border border-[#2C324A] focus:border-[#00FFFF] rounded-xl px-3 py-2 text-xs text-white focus:outline-none"
              >
                {teams.map(t => (
                  <option key={t.id} value={t.id} className="bg-[#121629]">
                    {t.name}
                  </option>
                ))}
              </select>
            </div>
          </div>

          {/* Date & Time */}
          <div className="grid grid-cols-2 gap-3">
            <div>
              <label className="text-xs font-mono text-white/70 block mb-1">EVENT DATE</label>
              <div className="relative">
                <input
                  type="date"
                  value={date}
                  onChange={e => setDate(e.target.value)}
                  className="w-full bg-[#080B15] border border-[#2C324A] focus:border-[#00FFFF] rounded-xl px-3 py-2 text-xs text-white focus:outline-none"
                />
              </div>
            </div>

            <div>
              <label className="text-xs font-mono text-white/70 block mb-1">TIME (24H)</label>
              <input
                type="time"
                value={time}
                onChange={e => setTime(e.target.value)}
                className="w-full bg-[#080B15] border border-[#2C324A] focus:border-[#00FFFF] rounded-xl px-3 py-2 text-xs text-white focus:outline-none"
              />
            </div>
          </div>

          {/* Location Preset Selector */}
          <div>
            <label className="text-xs font-mono text-white/70 block mb-1">
              GEOLOCATION / VENUE PRESET (PINS TO 3D GLOBE)
            </label>
            <select
              value={selectedLocationIdx}
              onChange={e => setSelectedLocationIdx(parseInt(e.target.value))}
              className="w-full bg-[#080B15] border border-[#2C324A] focus:border-[#00FFFF] rounded-xl px-3 py-2 text-xs text-white focus:outline-none"
            >
              {PRESET_LOCATIONS.map((loc, idx) => (
                <option key={idx} value={idx} className="bg-[#121629]">
                  {loc.name} ({loc.address})
                </option>
              ))}
            </select>
          </div>

          {/* Description */}
          <div>
            <label className="text-xs font-mono text-white/70 block mb-1">OPERATIONAL DESCRIPTION</label>
            <textarea
              rows={3}
              placeholder="Detail mission objectives, safety protocols, required gear, and agenda..."
              value={description}
              onChange={e => setDescription(e.target.value)}
              className="w-full bg-[#080B15] border border-[#2C324A] focus:border-[#00FFFF] rounded-xl px-3 py-2 text-xs text-white focus:outline-none"
            />
          </div>

          {/* Capacity & Rewards */}
          <div className="grid grid-cols-3 gap-2.5">
            <div>
              <label className="text-[10px] font-mono text-white/70 block mb-1">MAX ATTENDEES</label>
              <input
                type="number"
                min="5"
                max="500"
                value={maxCapacity}
                onChange={e => setMaxCapacity(e.target.value)}
                className="w-full bg-[#080B15] border border-[#2C324A] focus:border-[#00FFFF] rounded-xl px-3 py-1.5 text-xs text-white focus:outline-none"
              />
            </div>

            <div>
              <label className="text-[10px] font-mono text-white/70 block mb-1">FLR REWARD</label>
              <input
                type="number"
                min="0"
                max="500"
                value={rewardFlr}
                onChange={e => setRewardFlr(e.target.value)}
                className="w-full bg-[#080B15] border border-[#2C324A] focus:border-[#00FFFF] rounded-xl px-3 py-1.5 text-xs text-white focus:outline-none"
              />
            </div>

            <div>
              <label className="text-[10px] font-mono text-white/70 block mb-1">EXP REWARD</label>
              <input
                type="number"
                min="0"
                max="1000"
                value={rewardExp}
                onChange={e => setRewardExp(e.target.value)}
                className="w-full bg-[#080B15] border border-[#2C324A] focus:border-[#00FFFF] rounded-xl px-3 py-1.5 text-xs text-white focus:outline-none"
              />
            </div>
          </div>

          {/* Submit */}
          <button
            type="submit"
            className="w-full py-2.5 rounded-xl bg-gradient-to-r from-[#0096C7] to-[#00FFFF] hover:opacity-90 text-[#080B15] text-xs font-bold font-mono tracking-wider transition shadow-[0_0_15px_rgba(0,255,255,0.4)] flex items-center justify-center gap-1.5 mt-2"
          >
            <Sparkles className="w-4 h-4" />
            <span>PUBLISH EVENT TO 3D GLOBE & SECTOR FEED</span>
          </button>
        </form>
      </div>
    </div>
  );
};
