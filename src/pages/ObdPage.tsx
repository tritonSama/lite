import React, { useState } from 'react';
import { useApp } from '../context/AppContext';
import { 
  Gauge, 
  Bluetooth, 
  Power, 
  ArrowLeft, 
  Activity, 
  Thermometer, 
  Fuel, 
  Zap, 
  CheckCircle2 
} from 'lucide-react';

interface ObdPageProps {
  onBack: () => void;
}

export const ObdPage: React.FC<ObdPageProps> = ({ onBack }) => {
  const { obdState, connectObd, disconnectObd } = useApp();
  const [macAddress, setMacAddress] = useState('00:1D:A5:68:9B:4C');

  const handleConnect = (e: React.FormEvent) => {
    e.preventDefault();
    if (macAddress.trim()) {
      connectObd(macAddress.trim());
    }
  };

  return (
    <div className="pb-24 pt-2">
      <div className="max-w-2xl mx-auto px-4 space-y-5">
        {/* Header */}
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
              OBD2 CAN BUS TELEMETRY
            </h2>
            <p className="text-[10px] font-mono text-[#0096C7]">
              ELM327 BLUETOOTH ADAPTER
            </p>
          </div>
        </div>

        {/* Connection Box */}
        <div className="p-5 rounded-2xl bg-[#16192B] border border-[#2C324A] space-y-4">
          <div className="flex items-center justify-between">
            <div className="flex items-center gap-2.5">
              <div
                className={`w-3 h-3 rounded-full ${
                  obdState.isConnected
                    ? 'bg-green-500 shadow-[0_0_10px_#22c55e] animate-pulse'
                    : 'bg-red-500/50'
                }`}
              />
              <span className="text-xs font-mono font-bold text-white uppercase">
                {obdState.isConnected ? 'LINK ACTIVE // PROTOCOL ISO 15765-4' : 'SCANNER OFFLINE'}
              </span>
            </div>

            {obdState.isConnected && (
              <span className="text-[11px] font-mono text-[#0096C7]">
                CAN 11-BIT 500KBPS
              </span>
            )}
          </div>

          {!obdState.isConnected ? (
            <form onSubmit={handleConnect} className="space-y-3">
              <div>
                <label className="text-xs font-mono text-white/60 block mb-1">
                  OBD2 BLUETOOTH MAC ADDRESS
                </label>
                <input
                  type="text"
                  value={macAddress}
                  onChange={e => setMacAddress(e.target.value)}
                  placeholder="00:1D:A5:00:11:22"
                  className="w-full bg-[#0C0F1D] border border-[#2C324A] focus:border-[#0096C7] rounded-xl px-4 py-2.5 text-xs font-mono text-white focus:outline-none"
                />
              </div>

              <button
                type="submit"
                className="w-full py-2.5 rounded-xl bg-[#0096C7] hover:bg-[#0082ad] text-white text-xs font-bold font-mono flex items-center justify-center gap-2 shadow-[0_0_15px_rgba(0,150,199,0.3)] transition"
              >
                <Bluetooth className="w-4 h-4" />
                <span>Pair & Stream Telemetry</span>
              </button>
            </form>
          ) : (
            <div className="flex items-center justify-between pt-1">
              <span className="text-xs font-mono text-white/60">
                Paired: <strong className="text-white">{obdState.deviceMac}</strong>
              </span>
              <button
                onClick={disconnectObd}
                className="px-4 py-1.5 rounded-xl bg-red-500/20 border border-red-500/40 text-red-400 hover:bg-red-500/30 text-xs font-mono font-bold transition flex items-center gap-1.5"
              >
                <Power className="w-3.5 h-3.5" />
                <span>Disconnect</span>
              </button>
            </div>
          )}
        </div>

        {/* Live Gauges & Dials */}
        {obdState.isConnected ? (
          <div className="space-y-4 animate-fade-in">
            {/* Speed & RPM Primary Cluster */}
            <div className="grid grid-cols-2 gap-3">
              {/* Tachometer */}
              <div className="p-5 rounded-2xl bg-[#16192B] border border-[#0096C7]/50 text-center space-y-2 shadow-[0_0_20px_rgba(0,150,199,0.15)]">
                <span className="text-[10px] font-mono uppercase text-white/50 block">
                  ENGINE RPM
                </span>
                <div className="text-4xl font-mono font-bold text-[#0096C7]">
                  {obdState.rpm}
                </div>
                <div className="w-full bg-[#0C0F1D] h-2 rounded-full overflow-hidden border border-[#2C324A]">
                  <div
                    className="h-full bg-gradient-to-r from-[#0096C7] to-red-500 transition-all duration-300"
                    style={{ width: `${Math.min(100, (obdState.rpm / 6000) * 100)}%` }}
                  />
                </div>
                <span className="text-[10px] font-mono text-white/40 block">0 - 6,000 RPM</span>
              </div>

              {/* Speedometer */}
              <div className="p-5 rounded-2xl bg-[#16192B] border border-[#D4AF37]/50 text-center space-y-2 shadow-[0_0_20px_rgba(212,175,55,0.15)]">
                <span className="text-[10px] font-mono uppercase text-white/50 block">
                  VEHICLE SPEED
                </span>
                <div className="text-4xl font-mono font-bold text-[#D4AF37]">
                  {obdState.speed}
                </div>
                <div className="w-full bg-[#0C0F1D] h-2 rounded-full overflow-hidden border border-[#2C324A]">
                  <div
                    className="h-full bg-gradient-to-r from-[#D4AF37] to-amber-500 transition-all duration-300"
                    style={{ width: `${Math.min(100, (obdState.speed / 140) * 100)}%` }}
                  />
                </div>
                <span className="text-[10px] font-mono text-white/40 block">KM/H</span>
              </div>
            </div>

            {/* Secondary Diagnostics Cluster */}
            <div className="grid grid-cols-3 gap-3">
              <div className="p-3.5 rounded-xl bg-[#16192B] border border-[#2C324A] text-center space-y-1">
                <Thermometer className="w-4 h-4 text-[#0096C7] mx-auto" />
                <span className="text-[10px] font-mono text-white/50 block">COOLANT</span>
                <div className="text-base font-mono font-bold text-white">
                  {obdState.coolantTemp}°F
                </div>
              </div>

              <div className="p-3.5 rounded-xl bg-[#16192B] border border-[#2C324A] text-center space-y-1">
                <Fuel className="w-4 h-4 text-[#D4AF37] mx-auto" />
                <span className="text-[10px] font-mono text-white/50 block">FUEL LEVEL</span>
                <div className="text-base font-mono font-bold text-white">
                  {obdState.fuelLevel}%
                </div>
              </div>

              <div className="p-3.5 rounded-xl bg-[#16192B] border border-[#2C324A] text-center space-y-1">
                <Zap className="w-4 h-4 text-[#2EC4B6] mx-auto" />
                <span className="text-[10px] font-mono text-white/50 block">VOLTAGE</span>
                <div className="text-base font-mono font-bold text-white">
                  {obdState.voltage}V
                </div>
              </div>
            </div>
          </div>
        ) : (
          <div className="p-10 rounded-2xl bg-[#16192B]/50 border border-[#2C324A] text-center space-y-2">
            <Gauge className="w-12 h-12 text-white/20 mx-auto" />
            <h4 className="font-display font-semibold text-white text-sm">
              Telemetry Offline
            </h4>
            <p className="text-xs text-white/50 max-w-xs mx-auto">
              Connect to vehicle OBD2 port to monitor RPM, speed, temperature, and CAN bus error diagnostics in real-time.
            </p>
          </div>
        )}
      </div>
    </div>
  );
};
