import React, { useState } from 'react';
import { useApp } from '../context/AppContext';
import { 
  Handshake, 
  Bell, 
  Radio, 
  Search, 
  Shield, 
  X,
  Plus,
  Calendar,
  Sun,
  Moon
} from 'lucide-react';

interface HeaderProps {
  onOpenComms: () => void;
  onOpenNotifications: () => void;
  onOpenCreateTask: () => void;
  onOpenCreateEvent?: () => void;
}

export const Header: React.FC<HeaderProps> = ({
  onOpenComms,
  onOpenNotifications,
  onOpenCreateTask,
  onOpenCreateEvent,
}) => {
  const { teams, selectedTeamId, notifications, searchQuery, setSearchQuery, isDarkMode, toggleTheme } = useApp();
  const [showSearch, setShowSearch] = useState(false);

  const currentTeam = teams.find(t => t.id === selectedTeamId);
  const unreadCount = notifications.filter(n => !n.read).length;

  return (
    <header className={`sticky top-0 z-30 backdrop-blur-md border-b px-4 py-3 transition-colors ${
      isDarkMode 
        ? 'bg-[#0C0F1D]/90 border-[#2C324A] text-white' 
        : 'bg-white/95 border-slate-200 text-slate-900 shadow-sm'
    }`}>
      <div className="max-w-7xl mx-auto flex items-center justify-between gap-3">
        {/* Brand / Logo */}
        <div className="flex items-center gap-2.5">
          <div className="w-9 h-9 rounded-lg bg-[#0096C7]/15 border border-[#0096C7] flex items-center justify-center text-[#0096C7] shadow-[0_0_12px_rgba(0,150,199,0.3)]">
            <Handshake className="w-5 h-5" />
          </div>
          <div>
            <div className="flex items-center gap-2">
              <span className="font-display font-bold text-base md:text-lg tracking-wide flex items-center gap-1.5">
                <span className="text-[#0096C7] drop-shadow-[0_0_8px_rgba(0,150,199,0.4)]">FLUORITE</span>
                <span className={`font-mono text-xs ${isDarkMode ? 'text-white/80' : 'text-slate-600'}`}>OS</span>
              </span>
              <span className="text-[10px] uppercase font-mono px-1.5 py-0.5 rounded bg-[#0096C7]/20 text-[#0096C7] border border-[#0096C7]/40 font-semibold">
                LITE
              </span>
            </div>
            {currentTeam && (
              <div className={`flex items-center gap-1.5 text-xs ${isDarkMode ? 'text-white/70' : 'text-slate-600'}`}>
                <span 
                  className="w-2 h-2 rounded-full animate-pulse" 
                  style={{ backgroundColor: currentTeam.color }} 
                />
                <span className="font-medium">{currentTeam.name}</span>
                <span className="opacity-40">•</span>
                <span className="text-[11px] opacity-70">{currentTeam.membersOnline} online</span>
              </div>
            )}
          </div>
        </div>

        {/* Global Search Bar */}
        {showSearch ? (
          <div className={`flex-1 max-w-md mx-2 flex items-center rounded-lg px-3 py-1.5 border ${
            isDarkMode 
              ? 'bg-[#16192B] border-[#0096C7] text-white' 
              : 'bg-slate-100 border-blue-400 text-slate-900'
          }`}>
            <Search className="w-4 h-4 text-[#0096C7] mr-2" />
            <input
              type="text"
              placeholder="Search tasks, guilds, events, skills..."
              value={searchQuery}
              onChange={e => setSearchQuery(e.target.value)}
              className="w-full bg-transparent text-sm placeholder-slate-400 focus:outline-none"
              autoFocus
            />
            <button
              onClick={() => {
                setShowSearch(false);
                setSearchQuery('');
              }}
              className="opacity-50 hover:opacity-100 ml-1"
            >
              <X className="w-4 h-4" />
            </button>
          </div>
        ) : null}

        {/* Action Controls */}
        <div className="flex items-center gap-2">
          {!showSearch && (
            <button
              onClick={() => setShowSearch(true)}
              className={`p-2 rounded-lg border transition ${
                isDarkMode 
                  ? 'bg-[#16192B] border-[#2C324A] text-white/80 hover:text-[#0096C7]' 
                  : 'bg-slate-100 border-slate-200 text-slate-700 hover:text-blue-600'
              }`}
              title="Search"
            >
              <Search className="w-4 h-4" />
            </button>
          )}

          {/* Quick Create Event */}
          {onOpenCreateEvent && (
            <button
              onClick={onOpenCreateEvent}
              className="hidden sm:flex items-center gap-1.5 px-3 py-1.5 rounded-lg bg-[#5300FF]/20 border border-[#5300FF] hover:bg-[#5300FF]/30 text-[#B185FF] text-xs font-mono font-bold transition shadow-sm"
              title="Create New Guild Event"
            >
              <Calendar className="w-3.5 h-3.5" />
              <span>+ Event</span>
            </button>
          )}

          {/* Quick Post Task */}
          <button
            onClick={onOpenCreateTask}
            className="flex items-center gap-1.5 px-3 py-1.5 rounded-lg bg-[#0096C7] hover:bg-[#0082ad] text-white text-xs font-semibold shadow-[0_0_12px_rgba(0,150,199,0.3)] transition"
          >
            <Plus className="w-4 h-4" />
            <span>+ Task</span>
          </button>

          {/* Light / Dark Mode Toggle */}
          <button
            onClick={toggleTheme}
            className={`p-2 rounded-lg border transition ${
              isDarkMode
                ? 'bg-[#16192B] border-[#2C324A] text-[#D4AF37] hover:border-[#D4AF37]/60'
                : 'bg-slate-100 border-slate-300 text-amber-600 hover:bg-slate-200'
            }`}
            title={isDarkMode ? 'Switch to Light Mode' : 'Switch to Dark Mode'}
          >
            {isDarkMode ? <Sun className="w-4 h-4" /> : <Moon className="w-4 h-4 text-[#5300FF]" />}
          </button>

          {/* Radio / Comms Toggle */}
          <button
            onClick={onOpenComms}
            className={`p-2 rounded-lg border transition relative ${
              isDarkMode
                ? 'bg-[#16192B] border-[#2C324A] text-[#D4AF37] hover:border-[#D4AF37]/60 hover:bg-[#D4AF37]/10'
                : 'bg-slate-100 border-slate-300 text-amber-600 hover:bg-slate-200'
            }`}
            title="Tactical Comms & Radio"
          >
            <Radio className="w-4 h-4" />
          </button>

          {/* Notifications */}
          <button
            onClick={onOpenNotifications}
            className={`p-2 rounded-lg border transition relative ${
              isDarkMode
                ? 'bg-[#16192B] border-[#2C324A] text-white/80 hover:text-[#0096C7]'
                : 'bg-slate-100 border-slate-300 text-slate-700 hover:text-blue-600'
            }`}
            title="Notifications"
          >
            <Bell className="w-4 h-4" />
            {unreadCount > 0 && (
              <span className="absolute -top-1 -right-1 w-4 h-4 rounded-full bg-[#E74C3C] text-white text-[10px] font-bold flex items-center justify-center shadow-[0_0_6px_#E74C3C]">
                {unreadCount}
              </span>
            )}
          </button>
        </div>
      </div>
    </header>
  );
};
