import React from 'react';
import { useApp } from '../context/AppContext';
import { 
  LayoutDashboard, 
  Gamepad2, 
  Compass, 
  Users, 
  User, 
  Cpu 
} from 'lucide-react';

export type NavTab = 'board' | 'game' | 'mission' | 'teams' | 'profile' | 'nexus';

interface BottomNavProps {
  activeTab: NavTab;
  onChangeTab: (tab: NavTab) => void;
}

export const BottomNav: React.FC<BottomNavProps> = ({ activeTab, onChangeTab }) => {
  const { isDarkMode } = useApp();

  const navItems: { id: NavTab; label: string; icon: React.ComponentType<{ className?: string }> }[] = [
    { id: 'board', label: 'Board', icon: LayoutDashboard },
    { id: 'game', label: 'Game', icon: Gamepad2 },
    { id: 'mission', label: 'Mission', icon: Compass },
    { id: 'teams', label: 'Teams', icon: Users },
    { id: 'profile', label: 'Profile', icon: User },
    { id: 'nexus', label: 'Nexus', icon: Cpu },
  ];

  return (
    <nav className={`fixed bottom-0 left-0 right-0 z-40 backdrop-blur-lg border-t pb-safe transition-colors ${
      isDarkMode 
        ? 'bg-[#0C0F1D]/95 border-[#2C324A]' 
        : 'bg-white/95 border-slate-200 shadow-[0_-2px_10px_rgba(0,0,0,0.05)]'
    }`}>
      <div className="max-w-xl mx-auto flex items-center justify-around py-2 px-1">
        {navItems.map(item => {
          const Icon = item.icon;
          const isActive = activeTab === item.id;
          return (
            <button
              key={item.id}
              onClick={() => onChangeTab(item.id)}
              className={`flex flex-col items-center justify-center flex-1 py-1 px-1 transition-all duration-200 relative ${
                isActive 
                  ? 'text-[#0096C7]' 
                  : isDarkMode 
                  ? 'text-white/50 hover:text-white/80' 
                  : 'text-slate-400 hover:text-slate-700'
              }`}
            >
              {isActive && (
                <span className="absolute -top-2 w-8 h-1 bg-[#0096C7] rounded-full shadow-[0_0_8px_#0096C7]" />
              )}
              <div className={`p-1 rounded-lg transition-transform ${isActive ? 'scale-110' : ''}`}>
                <Icon className="w-5 h-5" />
              </div>
              <span className={`text-[11px] font-medium tracking-tight mt-0.5 ${
                isActive 
                  ? isDarkMode ? 'font-semibold text-white' : 'font-semibold text-slate-900' 
                  : ''
              }`}>
                {item.label}
              </span>
            </button>
          );
        })}
      </div>
    </nav>
  );
};
