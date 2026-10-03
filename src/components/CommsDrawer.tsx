import React, { useState, useRef, useEffect } from 'react';
import { useApp } from '../context/AppContext';
import { CommsChannel } from '../types';
import { 
  X, 
  Send, 
  User, 
  Users, 
  Globe, 
  Radio, 
  Mic, 
  Volume2, 
  VolumeX, 
  Wifi, 
  Sliders, 
  Sparkles, 
  Activity, 
  Check, 
  RotateCw,
  Search,
  Volume1,
  MessageSquare,
  HelpCircle
} from 'lucide-react';
import { radioAudio } from '../core/radio/radioAudioService';

interface CommsDrawerProps {
  isOpen: boolean;
  onClose: () => void;
}

const CHANNELS = [
  { ch: 1, freq: '462.5625', label: 'CH 1 OPS', band: 'Operations Primary' },
  { ch: 2, freq: '462.5875', label: 'CH 2 LOG', band: 'Logistics & Supply' },
  { ch: 3, freq: '462.6125', label: 'CH 3 WAR', band: 'Territorial Defense' },
  { ch: 4, freq: '462.6375', label: 'CH 4 TAC', band: 'Tactical Recon' },
  { ch: 5, freq: '462.6625', label: 'CH 5 AIR', band: 'Satellite & Drone' },
  { ch: 6, freq: '462.6875', label: 'CH 6 EMG', band: 'Emergency S.O.S' },
];

export const CommsDrawer: React.FC<CommsDrawerProps> = ({ isOpen, onClose }) => {
  const { 
    messages, 
    sendMessage, 
    currentUser, 
    isDarkMode, 
    commsTargetChannel, 
    commsTargetRecipient 
  } = useApp();
  const [activeChannel, setActiveChannel] = useState<CommsChannel>('radio');
  const [inputText, setInputText] = useState('');
  const [isPttActive, setIsPttActive] = useState(false);
  const [radioFrequency, setRadioFrequency] = useState('462.5625');
  const [radioChannelNum, setRadioChannelNum] = useState(1);
  const [radioVolume, setRadioVolume] = useState(85);
  const [isMuted, setIsMuted] = useState(false);
  const [enableTtsVoice, setEnableTtsVoice] = useState(true);
  const [squelchLevel, setSquelchLevel] = useState(2); // 1 = Low/Open, 2 = Medium, 3 = High/Tight
  const [pttMessage, setPttMessage] = useState('Sector 7 mobile squad standing by on tactical VHF.');
  const [isScanning, setIsScanning] = useState(false);
  const [micActiveLive, setMicActiveLive] = useState(false);
  const [isAudioTransmitting, setIsAudioTransmitting] = useState(false);
  const [radioStatusNotice, setRadioStatusNotice] = useState<string | null>(null);

  const messagesEndRef = useRef<HTMLDivElement>(null);
  const scanIntervalRef = useRef<any>(null);

  // Automatically switch channel and focus when opened with a friend or team target
  useEffect(() => {
    if (isOpen) {
      if (commsTargetRecipient) {
        if (commsTargetRecipient.type === 'friend') {
          setActiveChannel('direct');
          showNotice(`DIRECT CHAT OPEN // @${commsTargetRecipient.name.toUpperCase()} (ONLINE)`);
        } else if (commsTargetRecipient.type === 'team') {
          setActiveChannel('team');
          showNotice(`GUILD COMMS OPEN // ${commsTargetRecipient.name.toUpperCase()}`);
        }
      } else if (commsTargetChannel) {
        setActiveChannel(commsTargetChannel);
      }
    }
  }, [isOpen, commsTargetChannel, commsTargetRecipient]);

  const filteredMessages = messages.filter(m => {
    if (activeChannel === 'direct') {
      if (commsTargetRecipient && commsTargetRecipient.type === 'friend') {
        return (
          m.channel === 'direct' &&
          (m.recipientId === commsTargetRecipient.id ||
            m.senderId === commsTargetRecipient.id ||
            m.recipientName === commsTargetRecipient.name ||
            m.senderName === commsTargetRecipient.name ||
            !m.recipientId)
        );
      }
      return m.channel === 'direct';
    }
    if (activeChannel === 'team') {
      if (commsTargetRecipient && commsTargetRecipient.type === 'team') {
        return (
          m.channel === 'team' &&
          (m.recipientId === commsTargetRecipient.id ||
            m.senderName.toLowerCase().includes(commsTargetRecipient.name.toLowerCase()) ||
            !m.recipientId)
        );
      }
      return m.channel === 'team';
    }
    return m.channel === activeChannel;
  });

  useEffect(() => {
    messagesEndRef.current?.scrollIntoView({ behavior: 'smooth' });
  }, [filteredMessages, activeChannel]);

  useEffect(() => {
    radioAudio.setMuted(isMuted);
  }, [isMuted]);

  // Clean up scanning on unmount
  useEffect(() => {
    return () => {
      if (scanIntervalRef.current) clearInterval(scanIntervalRef.current);
    };
  }, []);

  if (!isOpen) return null;

  const showNotice = (msg: string) => {
    setRadioStatusNotice(msg);
    setTimeout(() => setRadioStatusNotice(null), 3500);
  };

  const handleSend = (e?: React.FormEvent) => {
    if (e) e.preventDefault();
    if (!inputText.trim()) return;
    sendMessage(
      inputText.trim(), 
      activeChannel, 
      false, 
      commsTargetRecipient?.id, 
      commsTargetRecipient?.name
    );
    setInputText('');
  };

  // Push To Talk: Pressed Down
  const handlePttDown = () => {
    setIsPttActive(true);
    setIsAudioTransmitting(true);

    // Play tactical radio key-down chirp
    radioAudio.playPttKeyDown(radioVolume);

    // Try starting speech-to-text recognition if browser supports it
    const started = radioAudio.startSpeechRecognition(
      transcript => {
        setPttMessage(transcript);
        setMicActiveLive(true);
      },
      err => {
        setMicActiveLive(false);
      }
    );
    if (started) {
      setMicActiveLive(true);
    }
  };

  // Push To Talk: Released Up
  const handlePttUp = () => {
    if (isPttActive) {
      setIsPttActive(false);
      setIsAudioTransmitting(false);
      setMicActiveLive(false);

      // Stop speech-to-text
      radioAudio.stopSpeechRecognition();

      // Play iconic Roger Beep + Squelch
      radioAudio.playRogerBeep(radioVolume);

      // Broadcast transmission over radio channel
      const finalMsg = `[CH ${radioChannelNum} // ${radioFrequency} MHz] ${pttMessage}`;
      sendMessage(finalMsg, 'radio', true);

      // Speak message over synthesized radio voice if TTS is enabled
      if (enableTtsVoice && !isMuted) {
        radioAudio.speakRadioMessage(pttMessage, radioVolume);
      }

      showNotice(`TRANSMISSION COMPLETE // BROADCAST OVER ${radioFrequency} MHz`);
    }
  };

  // Change Channel
  const selectChannel = (ch: number, freq: string) => {
    setRadioChannelNum(ch);
    setRadioFrequency(freq);
    radioAudio.playTuningClick(radioVolume);
    showNotice(`TUNED TO CH ${ch} // ${freq} MHz`);
  };

  // Step Frequency +/- 0.0125 MHz
  const stepFrequency = (delta: number) => {
    const current = parseFloat(radioFrequency);
    const next = (current + delta).toFixed(4);
    setRadioFrequency(next);
    radioAudio.playTuningClick(radioVolume);
  };

  // Squelch level adjustment
  const handleSquelchChange = (level: number) => {
    setSquelchLevel(level);
    radioAudio.playStaticBurst(level === 1 ? 0.25 : 0.06, radioVolume);
    showNotice(`SQUELCH SET TO ${level === 1 ? 'OPEN (HIGH NOISE)' : level === 2 ? 'BALANCED' : 'TIGHT (FILTERED)'}`);
  };

  // Quick test of audio synthesizer sounds (chirp + roger beep)
  const handleTestRadioSound = () => {
    showNotice('TESTING SYNTHESIZER: PTT CHIRP -> ROGER BEEP');
    radioAudio.playPttKeyDown(radioVolume);
    setTimeout(() => {
      radioAudio.playRogerBeep(radioVolume);
      showNotice('TACTICAL AUDIO SYSTEM 100% OPERATIONAL');
    }, 400);
  };

  // Simulated Radio Check from Squad
  const handleRadioCheck = () => {
    showNotice('TRANSMITTING: "RADIO CHECK SECTOR 7..."');
    radioAudio.playPttKeyDown(radioVolume);

    setTimeout(() => {
      radioAudio.playRogerBeep(radioVolume);
      sendMessage(`[CH ${radioChannelNum} // ${radioFrequency} MHz] HQ, this is Unit Alpha. Requesting radio signal check.`, 'radio', true);

      // Squad operator replies 1.2s later
      setTimeout(() => {
        const responseText = `Copy loud and clear Sector 7 Command. Signal strength five by five on ${radioFrequency} MHz. Standing by for task dispatch.`;
        sendMessage(`[CH ${radioChannelNum} // ${radioFrequency} MHz] ${responseText}`, 'radio', true);

        if (enableTtsVoice && !isMuted) {
          radioAudio.speakRadioMessage(responseText, radioVolume);
        } else {
          radioAudio.playRogerBeep(radioVolume);
        }
        showNotice(`INCOMING SIGNAL LOCKED // SQUAD RESPONDED`);
      }, 1400);
    }, 400);
  };

  // Scan across frequencies
  const toggleFrequencyScan = () => {
    if (isScanning) {
      if (scanIntervalRef.current) clearInterval(scanIntervalRef.current);
      setIsScanning(false);
      showNotice('SCAN STOPPED');
    } else {
      setIsScanning(true);
      showNotice('SCANNING VHF/UHF SPECTRUM...');
      let idx = 0;
      scanIntervalRef.current = setInterval(() => {
        idx = (idx + 1) % CHANNELS.length;
        const target = CHANNELS[idx];
        setRadioChannelNum(target.ch);
        setRadioFrequency(target.freq);
        radioAudio.playTuningClick(radioVolume * 0.7);

        // Found carrier after 4 steps
        if (idx === 2) {
          clearInterval(scanIntervalRef.current);
          setIsScanning(false);
          radioAudio.playStaticBurst(0.15, radioVolume);
          showNotice(`CARRIER DETECTED ON ${target.freq} MHz // SCAN LOCKED`);
        }
      }, 700);
    }
  };

  return (
    <div className="fixed inset-0 z-50 flex flex-col justify-end bg-black/60 backdrop-blur-sm animate-fade-in">
      <div 
        className={`w-full max-w-2xl mx-auto h-[85vh] border-t-2 rounded-t-2xl shadow-[0_-5px_30px_rgba(0,150,199,0.35)] flex flex-col overflow-hidden relative transition-colors ${
          isDarkMode ? 'bg-[#0C0F1D] border-[#0096C7] text-white' : 'bg-white border-[#0096C7] text-slate-900'
        }`}
        onClick={e => e.stopPropagation()}
      >
        {/* Animated Radar Background Overlay */}
        <div className="absolute inset-0 pointer-events-none opacity-10 overflow-hidden">
          <div className="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-[500px] h-[500px] rounded-full border border-[#0096C7]">
            <div className="absolute inset-8 rounded-full border border-[#0096C7]/60" />
            <div className="absolute inset-20 rounded-full border border-[#0096C7]/40" />
            <div className="absolute inset-36 rounded-full border border-[#0096C7]/20" />
            <div className="absolute top-0 bottom-0 left-1/2 w-[1px] bg-[#0096C7]/40" />
            <div className="absolute left-0 right-0 top-1/2 h-[1px] bg-[#0096C7]/40" />
            <div className="absolute top-1/2 left-1/2 w-[250px] h-[250px] origin-top-left bg-gradient-to-br from-[#0096C7]/30 to-transparent animate-radar-sweep" />
          </div>
        </div>

        {/* Drag Handle & Header */}
        <div className={`px-4 py-2.5 border-b flex items-center justify-between z-10 ${
          isDarkMode ? 'border-[#2C324A] bg-[#16192B]/90' : 'border-slate-200 bg-slate-50'
        }`}>
          <div className="flex items-center gap-2.5">
            <div className="w-8 h-8 rounded-lg bg-[#D4AF37]/20 border border-[#D4AF37] flex items-center justify-center text-[#D4AF37] shadow-[0_0_10px_rgba(212,175,55,0.3)]">
              <Radio className="w-4 h-4 animate-pulse" />
            </div>
            <div>
              <h3 className={`font-display font-bold text-sm tracking-wide flex items-center gap-2 ${
                isDarkMode ? 'text-white' : 'text-slate-900'
              }`}>
                <span>TACTICAL COMMS & RADIO TERMINAL</span>
                <span className="text-[9px] font-mono px-1.5 py-0.2 rounded bg-green-500/20 text-green-400 border border-green-500/30">
                  REAL-TIME AUDIO
                </span>
              </h3>
              <p className="text-[10px] font-mono text-[#0096C7]">
                PTT SQUELCH SYNTHESIZER • SPEECH-TO-TEXT MIC • DUAL-TONE ROGER BEEP
              </p>
            </div>
          </div>

          <div className="flex items-center gap-2">
            {/* Quick Audio Mute Toggle */}
            <button
              onClick={() => setIsMuted(m => !m)}
              className={`p-1.5 rounded-lg border text-xs transition ${
                isMuted
                  ? 'bg-red-500/20 border-red-500 text-red-400'
                  : isDarkMode
                  ? 'bg-[#0C0F1D] border-[#2C324A] text-[#D4AF37] hover:border-[#D4AF37]'
                  : 'bg-white border-slate-300 text-amber-600 hover:border-amber-500'
              }`}
              title={isMuted ? 'Unmute Radio Sounds' : 'Mute Radio Sounds'}
            >
              {isMuted ? <VolumeX className="w-4 h-4" /> : <Volume2 className="w-4 h-4" />}
            </button>
            <button
              onClick={onClose}
              className={`p-1.5 rounded-lg transition ${
                isDarkMode ? 'text-white/50 hover:text-white hover:bg-white/5' : 'text-slate-400 hover:text-slate-700 hover:bg-slate-200'
              }`}
            >
              <X className="w-5 h-5" />
            </button>
          </div>
        </div>

        {/* Channel Navigation */}
        <div className={`flex items-center border-b z-10 px-2 overflow-x-auto no-scrollbar ${
          isDarkMode ? 'border-[#2C324A] bg-[#0C0F1D]' : 'border-slate-200 bg-white'
        }`}>
          <button
            onClick={() => setActiveChannel('radio')}
            className={`flex items-center gap-1.5 px-4 py-2.5 text-xs font-semibold border-b-2 transition whitespace-nowrap ${
              activeChannel === 'radio'
                ? 'border-[#D4AF37] text-[#D4AF37] bg-[#D4AF37]/10'
                : isDarkMode ? 'border-transparent text-white/60 hover:text-white' : 'border-transparent text-slate-500 hover:text-slate-800'
            }`}
          >
            <Radio className="w-3.5 h-3.5" />
            <span>RADIO PTT ({radioFrequency} MHz)</span>
          </button>
          <button
            onClick={() => setActiveChannel('team')}
            className={`flex items-center gap-1.5 px-4 py-2.5 text-xs font-semibold border-b-2 transition whitespace-nowrap ${
              activeChannel === 'team'
                ? 'border-[#0096C7] text-[#0096C7] bg-[#0096C7]/10'
                : isDarkMode ? 'border-transparent text-white/60 hover:text-white' : 'border-transparent text-slate-500 hover:text-slate-800'
            }`}
          >
            <Users className="w-3.5 h-3.5" />
            <span>GUILD / TEAM CHAT</span>
          </button>
          <button
            onClick={() => setActiveChannel('direct')}
            className={`flex items-center gap-1.5 px-4 py-2.5 text-xs font-semibold border-b-2 transition whitespace-nowrap ${
              activeChannel === 'direct'
                ? 'border-[#0096C7] text-[#0096C7] bg-[#0096C7]/10'
                : isDarkMode ? 'border-transparent text-white/60 hover:text-white' : 'border-transparent text-slate-500 hover:text-slate-800'
            }`}
          >
            <User className="w-3.5 h-3.5" />
            <span>DIRECT</span>
          </button>
          <button
            onClick={() => setActiveChannel('global')}
            className={`flex items-center gap-1.5 px-4 py-2.5 text-xs font-semibold border-b-2 transition whitespace-nowrap ${
              activeChannel === 'global'
                ? 'border-[#0096C7] text-[#0096C7] bg-[#0096C7]/10'
                : isDarkMode ? 'border-transparent text-white/60 hover:text-white' : 'border-transparent text-slate-500 hover:text-slate-800'
            }`}
          >
            <Globe className="w-3.5 h-3.5" />
            <span>GLOBAL MESH</span>
          </button>
        </div>

        {/* Live Status Toast Banner */}
        {radioStatusNotice && (
          <div className="bg-[#D4AF37]/15 border-b border-[#D4AF37]/40 px-4 py-1.5 text-center text-xs font-mono text-[#D4AF37] font-semibold flex items-center justify-center gap-2 z-20 animate-fade-in">
            <Activity className="w-3.5 h-3.5 animate-spin" />
            <span>{radioStatusNotice}</span>
          </div>
        )}

        {/* Channel Body */}
        {activeChannel !== 'radio' ? (
          <div className="flex-1 flex flex-col justify-between overflow-hidden z-10">
            {/* Active Direct Recipient / Guild Channel Header */}
            {commsTargetRecipient && (
              <div className={`px-4 py-2 border-b flex flex-wrap items-center justify-between gap-2 text-xs ${
                isDarkMode ? 'bg-[#0E1326] border-[#2C324A]' : 'bg-slate-100 border-slate-200'
              }`}>
                <div className="flex items-center gap-2.5">
                  <div 
                    className="w-8 h-8 rounded-full flex items-center justify-center font-bold text-xs border"
                    style={{
                      backgroundColor: commsTargetRecipient.color ? `${commsTargetRecipient.color}25` : 'rgba(0, 255, 136, 0.2)',
                      borderColor: commsTargetRecipient.color || '#00FF88',
                      color: commsTargetRecipient.color || '#00FF88'
                    }}
                  >
                    {commsTargetRecipient.type === 'friend' ? (
                      <User className="w-4 h-4" />
                    ) : (
                      <Users className="w-4 h-4" />
                    )}
                  </div>
                  <div>
                    <div className="flex items-center gap-2">
                      <span className="font-bold text-xs">{commsTargetRecipient.name}</span>
                      <span className="text-[9px] font-mono px-1.5 py-0.2 rounded bg-green-500/20 text-green-400 border border-green-500/30">
                        {commsTargetRecipient.type === 'friend' ? 'DIRECT FRIEND' : 'GUILD CHAT'}
                      </span>
                    </div>
                    <div className={`text-[10px] font-mono ${isDarkMode ? 'text-white/50' : 'text-slate-500'}`}>
                      {commsTargetRecipient.type === 'friend'
                        ? 'P2P Encrypted Mesh • Instant Response'
                        : 'Decentralized Faction Frequency'}
                    </div>
                  </div>
                </div>

                {/* Quick Transmission Preset Prompts */}
                <div className="flex items-center gap-1.5 overflow-x-auto">
                  <button
                    onClick={() => setInputText("What's your current GPS sector coordinates?")}
                    className="px-2 py-0.5 rounded text-[10px] font-mono border bg-white/5 border-[#0096C7]/30 text-[#0096C7] hover:bg-[#0096C7]/15 transition"
                  >
                    Ping GPS
                  </button>
                  <button
                    onClick={() => setInputText("Ready for task assignment in Sector 7.")}
                    className="px-2 py-0.5 rounded text-[10px] font-mono border bg-white/5 border-[#00FF88]/30 text-[#00FF88] hover:bg-[#00FF88]/15 transition"
                  >
                    Status Ready
                  </button>
                  <button
                    onClick={() => setInputText("Confirming encrypted radio signal. Roger that.")}
                    className="px-2 py-0.5 rounded text-[10px] font-mono border bg-white/5 border-[#D4AF37]/30 text-[#D4AF37] hover:bg-[#D4AF37]/15 transition"
                  >
                    Radio Check
                  </button>
                </div>
              </div>
            )}

            {/* Messages Scroll Area */}
            <div className="flex-1 p-4 overflow-y-auto space-y-3">
              {filteredMessages.length === 0 ? (
                <div className={`text-center py-16 font-mono text-xs ${isDarkMode ? 'text-white/40' : 'text-slate-400'}`}>
                  NO ACTIVE TRANSMISSIONS ON THIS FREQUENCY.
                </div>
              ) : (
                filteredMessages.map(msg => {
                  const isMe = msg.senderId === 'me' || msg.senderId === currentUser.id;
                  return (
                    <div
                      key={msg.id}
                      className={`flex flex-col ${isMe ? 'items-end' : 'items-start'}`}
                    >
                      <div className="flex items-center gap-2 mb-1 text-[11px] font-mono">
                        <span className={isMe ? 'text-[#0096C7] font-semibold' : 'text-[#D4AF37] font-semibold'}>
                          {msg.senderName}
                        </span>
                        <span className={isDarkMode ? 'text-white/40' : 'text-slate-400'}>{msg.timestamp}</span>
                      </div>
                      <div
                        className={`p-3 rounded-lg text-xs leading-relaxed max-w-[85%] font-mono ${
                          isMe
                            ? 'bg-[#0096C7]/20 border border-[#0096C7]/60 text-white rounded-tr-none'
                            : isDarkMode 
                            ? 'bg-[#16192B] border border-[#2C324A] text-white/90 rounded-tl-none'
                            : 'bg-slate-100 border border-slate-200 text-slate-800 rounded-tl-none'
                        }`}
                      >
                        {msg.content}
                      </div>
                    </div>
                  );
                })
              )}
              <div ref={messagesEndRef} />
            </div>

            {/* Input Bar */}
            <form onSubmit={handleSend} className={`p-3 border-t flex items-center gap-2 ${
              isDarkMode ? 'bg-[#16192B] border-[#2C324A]' : 'bg-slate-50 border-slate-200'
            }`}>
              <input
                type="text"
                placeholder={
                  commsTargetRecipient
                    ? `Message @${commsTargetRecipient.name}...`
                    : `Transmit on ${activeChannel.toUpperCase()} frequency...`
                }
                value={inputText}
                onChange={e => setInputText(e.target.value)}
                className={`flex-1 border focus:border-[#0096C7] rounded-lg px-3 py-2 text-xs font-mono focus:outline-none ${
                  isDarkMode 
                    ? 'bg-[#0C0F1D] border-[#2C324A] text-white placeholder-white/40' 
                    : 'bg-white border-slate-300 text-slate-900 placeholder-slate-400'
                }`}
              />
              <button
                type="submit"
                className="p-2 rounded-lg bg-[#0096C7] hover:bg-[#0082ad] text-white transition shadow-[0_0_10px_rgba(0,150,199,0.4)]"
              >
                <Send className="w-4 h-4" />
              </button>
            </form>
          </div>
        ) : (
          /* Radio Walkie Talkie Tab: Fully Functional */
          <div className="flex-1 p-3.5 sm:p-4 overflow-y-auto flex flex-col justify-between z-10 space-y-3">
            {/* Radio Frequency Tuner & Tactical Status Deck */}
            <div className={`border rounded-xl p-3.5 shadow-sm space-y-3 transition-colors ${
              isDarkMode 
                ? 'bg-[#16192B] border-[#D4AF37]/40 shadow-[0_0_15px_rgba(212,175,55,0.15)]' 
                : 'bg-slate-50 border-amber-300 shadow-sm'
            }`}>
              <div className="flex flex-wrap items-center justify-between gap-2">
                <div className="flex items-center gap-2">
                  <Wifi className="w-4 h-4 text-[#D4AF37] animate-pulse" />
                  <span className="text-xs font-mono font-bold text-[#D4AF37]">VHF/UHF TACTICAL TRANSCEIVER</span>
                </div>

                <div className="flex items-center gap-3">
                  {/* Volume Control */}
                  <div className="flex items-center gap-1.5 text-xs font-mono">
                    <button
                      onClick={() => setIsMuted(m => !m)}
                      className={isMuted ? 'text-red-400' : 'text-[#D4AF37]'}
                    >
                      {isMuted ? <VolumeX className="w-3.5 h-3.5" /> : <Volume2 className="w-3.5 h-3.5" />}
                    </button>
                    <input
                      type="range"
                      min="0"
                      max="100"
                      value={radioVolume}
                      onChange={e => {
                        setRadioVolume(parseInt(e.target.value));
                        if (isMuted) setIsMuted(false);
                      }}
                      className="w-16 h-1.5 accent-[#D4AF37] cursor-pointer"
                      title={`Volume: ${radioVolume}%`}
                    />
                    <span className="text-[10px] text-white/70 w-7">{radioVolume}%</span>
                  </div>

                  {/* Text To Speech Toggle */}
                  <button
                    onClick={() => setEnableTtsVoice(v => !v)}
                    className={`px-2 py-0.5 rounded text-[10px] font-mono border transition ${
                      enableTtsVoice
                        ? 'bg-[#0096C7]/20 border-[#0096C7] text-[#0096C7] font-semibold'
                        : isDarkMode ? 'bg-[#0C0F1D] border-[#2C324A] text-white/40' : 'bg-slate-200 border-slate-300 text-slate-500'
                    }`}
                    title="Read radio transmissions aloud with tactical voice"
                  >
                    VOICE: {enableTtsVoice ? 'ON' : 'OFF'}
                  </button>
                </div>
              </div>

              {/* Digital Frequency Display with Live Waveform Animation */}
              <div className={`border rounded-lg p-3 text-center relative overflow-hidden ${
                isDarkMode ? 'bg-[#0C0F1D] border-[#2C324A]' : 'bg-white border-slate-200 shadow-inner'
              }`}>
                {/* Background VU Meter when transmitting */}
                {isPttActive && (
                  <div className="absolute inset-0 flex items-center justify-around opacity-20 pointer-events-none">
                    {[...Array(16)].map((_, i) => (
                      <div
                        key={i}
                        className="w-1.5 bg-[#00FF88] rounded-full animate-pulse"
                        style={{
                          height: `${Math.sin(i * 0.8) * 40 + 50}%`,
                          animationDelay: `${i * 60}ms`,
                        }}
                      />
                    ))}
                  </div>
                )}

                <div className="flex items-center justify-between text-[10px] font-mono uppercase tracking-wider mb-1">
                  <span className={isDarkMode ? 'text-white/50' : 'text-slate-500'}>
                    TACTICAL CHANNEL {radioChannelNum} // {CHANNELS.find(c => c.ch === radioChannelNum)?.label}
                  </span>
                  <span className={`flex items-center gap-1 font-bold ${
                    isPttActive ? 'text-[#E74C3C] animate-pulse' : 'text-[#00FF88]'
                  }`}>
                    <Activity className="w-3 h-3" />
                    {isPttActive ? 'TX BROADCASTING' : 'RX STANDBY'}
                  </span>
                </div>

                <div className="flex items-center justify-center gap-3 my-1">
                  <button
                    onClick={() => stepFrequency(-0.0125)}
                    className={`w-7 h-7 rounded border font-mono font-bold text-xs transition ${
                      isDarkMode ? 'bg-[#16192B] border-[#2C324A] text-white hover:border-[#D4AF37]' : 'bg-slate-100 border-slate-300 text-slate-700 hover:bg-slate-200'
                    }`}
                    title="Step Frequency Down (-12.5 kHz)"
                  >
                    -
                  </button>

                  <div className="text-2xl sm:text-3xl font-mono font-bold text-[#D4AF37] tracking-widest drop-shadow-[0_0_8px_rgba(212,175,55,0.4)]">
                    {radioFrequency} <span className={`text-xs ${isDarkMode ? 'text-white/40' : 'text-slate-400'}`}>MHz</span>
                  </div>

                  <button
                    onClick={() => stepFrequency(0.0125)}
                    className={`w-7 h-7 rounded border font-mono font-bold text-xs transition ${
                      isDarkMode ? 'bg-[#16192B] border-[#2C324A] text-white hover:border-[#D4AF37]' : 'bg-slate-100 border-slate-300 text-slate-700 hover:bg-slate-200'
                    }`}
                    title="Step Frequency Up (+12.5 kHz)"
                  >
                    +
                  </button>
                </div>

                <div className="flex items-center justify-between text-[10px] text-[#0096C7] font-mono mt-1">
                  <span>CTCSS: 67.0 Hz TONE</span>
                  <span>SQUELCH: LEVEL {squelchLevel}</span>
                  <span>MOD: FM-NARROW</span>
                </div>
              </div>

              {/* Channel Preset Buttons */}
              <div className="grid grid-cols-3 sm:grid-cols-6 gap-1.5">
                {CHANNELS.map(item => (
                  <button
                    key={item.ch}
                    onClick={() => selectChannel(item.ch, item.freq)}
                    className={`py-1.5 px-1 rounded border text-[10px] font-mono transition text-center ${
                      radioChannelNum === item.ch
                        ? 'bg-[#D4AF37] text-black border-[#D4AF37] font-bold shadow-[0_0_10px_rgba(212,175,55,0.4)]'
                        : isDarkMode
                        ? 'bg-[#0C0F1D] border-[#2C324A] text-white/70 hover:text-white hover:border-[#D4AF37]/50'
                        : 'bg-white border-slate-200 text-slate-700 hover:bg-slate-100'
                    }`}
                  >
                    <div className="font-bold">{item.label}</div>
                    <div className="text-[9px] opacity-75">{item.freq}</div>
                  </button>
                ))}
              </div>

              {/* Radio Quick Operations Bar: Radio Check, Squelch, Frequency Scan */}
              <div className="flex flex-wrap items-center justify-between gap-2 pt-2 border-t border-slate-200/20 text-xs">
                <div className="flex items-center gap-1.5">
                  <span className={`text-[10px] font-mono ${isDarkMode ? 'text-white/60' : 'text-slate-500'}`}>Squelch:</span>
                  {[1, 2, 3].map(lvl => (
                    <button
                      key={lvl}
                      onClick={() => handleSquelchChange(lvl)}
                      className={`px-2 py-0.5 rounded text-[10px] font-mono border transition ${
                        squelchLevel === lvl
                          ? 'bg-[#0096C7] text-white border-[#0096C7]'
                          : isDarkMode ? 'bg-[#0C0F1D] border-[#2C324A] text-white/50' : 'bg-white border-slate-300 text-slate-600'
                      }`}
                    >
                      {lvl === 1 ? 'Open' : lvl === 2 ? 'Med' : 'Tight'}
                    </button>
                  ))}
                </div>

                <div className="flex flex-wrap items-center gap-2">
                  <button
                    onClick={handleTestRadioSound}
                    className="flex items-center gap-1 px-2.5 py-1 rounded-lg bg-[#00FF88]/15 border border-[#00FF88] text-[#00FF88] hover:bg-[#00FF88]/25 text-[11px] font-mono font-bold transition shadow-sm"
                    title="Synthesize PTT Chirp and Roger Beep sounds"
                  >
                    <Volume2 className="w-3 h-3" />
                    <span>Sound Check</span>
                  </button>

                  <button
                    onClick={handleRadioCheck}
                    className="flex items-center gap-1 px-2.5 py-1 rounded-lg bg-[#D4AF37]/15 border border-[#D4AF37] text-[#D4AF37] hover:bg-[#D4AF37]/25 text-[11px] font-mono font-bold transition shadow-sm"
                    title="Send a radio check to squad members"
                  >
                    <Sparkles className="w-3 h-3" />
                    <span>Squad Check</span>
                  </button>

                  <button
                    onClick={toggleFrequencyScan}
                    className={`flex items-center gap-1 px-2.5 py-1 rounded-lg border text-[11px] font-mono font-bold transition ${
                      isScanning
                        ? 'bg-[#E74C3C]/20 border-[#E74C3C] text-[#E74C3C] animate-pulse'
                        : isDarkMode
                        ? 'bg-[#0C0F1D] border-[#2C324A] text-white/70 hover:text-white'
                        : 'bg-white border-slate-300 text-slate-700 hover:bg-slate-100'
                    }`}
                  >
                    <RotateCw className={`w-3 h-3 ${isScanning ? 'animate-spin' : ''}`} />
                    <span>{isScanning ? 'Scanning...' : 'Scan Channels'}</span>
                  </button>
                </div>
              </div>
            </div>

            {/* Quick Radio Transmit Phrase Preset / Editable Buffer */}
            <div>
              <div className="flex items-center justify-between mb-1">
                <label className={`text-[11px] font-mono flex items-center gap-1.5 ${
                  isDarkMode ? 'text-white/60' : 'text-slate-600'
                }`}>
                  <Mic className="w-3.5 h-3.5 text-[#0096C7]" />
                  <span>TRANSMISSION BUFFER (SPEECH OR TYPED)</span>
                </label>
                {micActiveLive && (
                  <span className="text-[10px] font-mono text-[#00FF88] font-bold animate-pulse flex items-center gap-1">
                    <span className="w-2 h-2 rounded-full bg-[#00FF88]" />
                    MICROPHONE LIVE TRANSCRIBING
                  </span>
                )}
              </div>
              <input
                type="text"
                value={pttMessage}
                onChange={e => setPttMessage(e.target.value)}
                placeholder="Enter message to broadcast or hold PTT to talk into mic..."
                className={`w-full border focus:border-[#D4AF37] rounded-lg px-3 py-2 text-xs font-mono focus:outline-none transition ${
                  isDarkMode 
                    ? 'bg-[#16192B] border-[#2C324A] text-white' 
                    : 'bg-slate-50 border-slate-300 text-slate-900'
                }`}
              />
            </div>

            {/* Real Push-To-Talk Button with Web Audio + Roger Beep */}
            <div className="flex flex-col items-center justify-center my-auto py-2">
              <button
                onMouseDown={handlePttDown}
                onMouseUp={handlePttUp}
                onTouchStart={handlePttDown}
                onTouchEnd={handlePttUp}
                aria-label="Push To Talk"
                className={`w-36 h-36 rounded-full border-4 flex flex-col items-center justify-center transition-all duration-150 select-none shadow-xl cursor-pointer ${
                  isPttActive
                    ? 'bg-[#E74C3C] border-white scale-95 shadow-[0_0_40px_rgba(231,76,60,0.8)] ring-8 ring-[#E74C3C]/40'
                    : isDarkMode
                    ? 'bg-[#16192B] border-[#D4AF37] hover:border-white shadow-[0_0_25px_rgba(212,175,55,0.4)]'
                    : 'bg-amber-500 border-white text-white hover:bg-amber-600 shadow-[0_0_20px_rgba(245,158,11,0.5)]'
                }`}
              >
                <Mic className={`w-10 h-10 ${isPttActive ? 'text-white animate-bounce' : 'text-white drop-shadow'}`} />
                <span className="text-xs font-mono font-bold mt-1 text-white">
                  {isPttActive ? 'MIC LIVE: TALK NOW' : 'HOLD TO TALK'}
                </span>
                <span className="text-[9px] font-mono text-white/80">
                  {isPttActive ? 'TRANSMITTING...' : 'PTT BUTTON'}
                </span>
              </button>

              <p className={`text-[11px] font-mono mt-3 text-center max-w-sm ${
                isDarkMode ? 'text-white/50' : 'text-slate-500'
              }`}>
                Hold button to broadcast live voice on <strong>{radioFrequency} MHz</strong>.
                Releasing plays tactical <em>Roger Beep</em> and sends transmission!
              </p>
            </div>
          </div>
        )}
      </div>
    </div>
  );
};
