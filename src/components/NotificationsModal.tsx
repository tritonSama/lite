import React from 'react';
import { useApp } from '../context/AppContext';
import { Bell, CheckCheck, Trash2, X, Swords, FileCheck, Network, DollarSign } from 'lucide-react';

interface NotificationsModalProps {
  isOpen: boolean;
  onClose: () => void;
}

export const NotificationsModal: React.FC<NotificationsModalProps> = ({ isOpen, onClose }) => {
  const { notifications, markNotificationAsRead, clearNotifications } = useApp();

  if (!isOpen) return null;

  const getIcon = (type: string) => {
    switch (type) {
      case 'war':
        return <Swords className="w-4 h-4 text-[#FF6B35]" />;
      case 'task':
        return <FileCheck className="w-4 h-4 text-[#0096C7]" />;
      case 'bid':
        return <DollarSign className="w-4 h-4 text-[#D4AF37]" />;
      default:
        return <Network className="w-4 h-4 text-[#834DFF]" />;
    }
  };

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/70 backdrop-blur-sm animate-fade-in">
      <div 
        className="w-full max-w-md bg-[#16192B] border border-[#2C324A] rounded-xl shadow-[0_0_25px_rgba(0,150,199,0.2)] overflow-hidden flex flex-col max-h-[85vh]"
        onClick={e => e.stopPropagation()}
      >
        {/* Header */}
        <div className="flex items-center justify-between px-4 py-3 border-b border-[#2C324A] bg-[#0C0F1D]">
          <div className="flex items-center gap-2">
            <Bell className="w-5 h-5 text-[#0096C7]" />
            <h3 className="font-display font-semibold text-white">System Transmissions</h3>
            <span className="text-xs px-2 py-0.5 rounded-full bg-[#0096C7]/20 text-[#0096C7] font-mono">
              {notifications.length}
            </span>
          </div>
          <div className="flex items-center gap-1">
            {notifications.length > 0 && (
              <button
                onClick={clearNotifications}
                className="p-1.5 text-white/50 hover:text-white/90 rounded hover:bg-white/5 transition"
                title="Clear all"
              >
                <Trash2 className="w-4 h-4" />
              </button>
            )}
            <button
              onClick={onClose}
              className="p-1.5 text-white/50 hover:text-white rounded hover:bg-white/5 transition"
            >
              <X className="w-5 h-5" />
            </button>
          </div>
        </div>

        {/* Content */}
        <div className="p-4 overflow-y-auto flex-1 divide-y divide-[#2C324A]/60">
          {notifications.length === 0 ? (
            <div className="text-center py-12 text-white/50">
              <CheckCheck className="w-10 h-10 mx-auto mb-2 opacity-30 text-[#0096C7]" />
              <p className="text-sm">All clear! No pending notifications.</p>
            </div>
          ) : (
            notifications.map(n => (
              <div
                key={n.id}
                onClick={() => markNotificationAsRead(n.id)}
                className={`py-3 first:pt-0 last:pb-0 flex items-start gap-3 cursor-pointer transition ${
                  n.read ? 'opacity-60' : 'opacity-100'
                }`}
              >
                <div className="p-2 rounded-lg bg-[#0C0F1D] border border-[#2C324A] mt-0.5 shrink-0">
                  {getIcon(n.type)}
                </div>
                <div className="flex-1 min-w-0">
                  <div className="flex items-center justify-between">
                    <p className="text-xs font-semibold text-white">{n.title}</p>
                    <span className="text-[10px] text-white/40 font-mono">{n.timestamp}</span>
                  </div>
                  <p className="text-xs text-white/70 mt-0.5 leading-relaxed">{n.message}</p>
                </div>
                {!n.read && (
                  <span className="w-2 h-2 rounded-full bg-[#0096C7] mt-1.5 shrink-0 shadow-[0_0_6px_#0096C7]" />
                )}
              </div>
            ))
          )}
        </div>
      </div>
    </div>
  );
};
