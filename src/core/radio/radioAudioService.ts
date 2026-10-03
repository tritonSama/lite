/**
 * Tactical Radio Audio & Web Speech Synthesizer Service
 * Implements real-time Web Audio API sound synthesis (squelch bursts, PTT chirps, Roger beeps)
 * and Web Speech API (Microphone Live Voice Recognition & Tactical Text-To-Speech)
 */

class RadioAudioService {
  private static instance: RadioAudioService;
  private audioCtx: AudioContext | null = null;
  private isMuted: boolean = false;
  private recognition: any = null;
  private isListeningMic: boolean = false;

  private constructor() {
    // Lazy init audio context on first user gesture
  }

  public static getInstance(): RadioAudioService {
    if (!RadioAudioService.instance) {
      RadioAudioService.instance = new RadioAudioService();
    }
    return RadioAudioService.instance;
  }

  private getAudioContext(): AudioContext | null {
    if (typeof window === 'undefined') return null;
    if (!this.audioCtx) {
      const AudioCtxClass = window.AudioContext || (window as any).webkitAudioContext;
      if (AudioCtxClass) {
        this.audioCtx = new AudioCtxClass();
      }
    }
    if (this.audioCtx && this.audioCtx.state === 'suspended') {
      this.audioCtx.resume();
    }
    return this.audioCtx;
  }

  public setMuted(muted: boolean) {
    this.isMuted = muted;
  }

  public getIsMuted(): boolean {
    return this.isMuted;
  }

  /**
   * Generates white noise buffer for radio static and squelch
   */
  private createNoiseBuffer(ctx: AudioContext, seconds: number = 0.5): AudioBuffer {
    const bufferSize = Math.floor(ctx.sampleRate * seconds);
    const buffer = ctx.createBuffer(1, bufferSize, ctx.sampleRate);
    const output = buffer.getChannelData(0);
    for (let i = 0; i < bufferSize; i++) {
      output[i] = Math.random() * 2 - 1;
    }
    return buffer;
  }

  /**
   * Tactical PTT Key-down Sound:
   * Quick squelch pop + 1050 Hz tactical key beep
   */
  public playPttKeyDown(volumePercent: number = 85) {
    if (this.isMuted) return;
    const ctx = this.getAudioContext();
    if (!ctx) return;

    try {
      const gainValue = (volumePercent / 100) * 0.35;
      const now = ctx.currentTime;

      // 1. Brief squelch pop
      const noiseBuffer = this.createNoiseBuffer(ctx, 0.04);
      const noiseSource = ctx.createBufferSource();
      noiseSource.buffer = noiseBuffer;

      // Bandpass filter to sound like communications radio
      const filter = ctx.createBiquadFilter();
      filter.type = 'bandpass';
      filter.frequency.setValueAtTime(1400, now);
      filter.Q.setValueAtTime(2.5, now);

      const noiseGain = ctx.createGain();
      noiseGain.gain.setValueAtTime(gainValue * 0.6, now);
      noiseGain.gain.exponentialRampToValueAtTime(0.001, now + 0.04);

      noiseSource.connect(filter);
      filter.connect(noiseGain);
      noiseGain.connect(ctx.destination);
      noiseSource.start(now);

      // 2. High chirp tone (1050 Hz)
      const osc = ctx.createOscillator();
      osc.type = 'sine';
      osc.frequency.setValueAtTime(1050, now);
      osc.frequency.exponentialRampToValueAtTime(1250, now + 0.05);

      const toneGain = ctx.createGain();
      toneGain.gain.setValueAtTime(gainValue * 0.8, now);
      toneGain.gain.exponentialRampToValueAtTime(0.001, now + 0.06);

      osc.connect(toneGain);
      toneGain.connect(ctx.destination);
      osc.start(now);
      osc.stop(now + 0.065);
    } catch (e) {
      // Audio autoplay policy fallback
    }
  }

  /**
   * Tactical Roger Beep (End of Transmission):
   * Dual-tone chirp (1200 Hz for 55ms -> 880 Hz for 55ms) + closing squelch burst
   */
  public playRogerBeep(volumePercent: number = 85) {
    if (this.isMuted) return;
    const ctx = this.getAudioContext();
    if (!ctx) return;

    try {
      const gainValue = (volumePercent / 100) * 0.3;
      const now = ctx.currentTime;

      // Tone 1: 1200 Hz
      const osc1 = ctx.createOscillator();
      osc1.type = 'sine';
      osc1.frequency.setValueAtTime(1200, now);

      const gain1 = ctx.createGain();
      gain1.gain.setValueAtTime(gainValue, now);
      gain1.gain.setValueAtTime(gainValue, now + 0.05);
      gain1.gain.linearRampToValueAtTime(0.001, now + 0.055);

      osc1.connect(gain1);
      gain1.connect(ctx.destination);
      osc1.start(now);
      osc1.stop(now + 0.06);

      // Tone 2: 880 Hz
      const osc2 = ctx.createOscillator();
      osc2.type = 'sine';
      osc2.frequency.setValueAtTime(880, now + 0.06);

      const gain2 = ctx.createGain();
      gain2.gain.setValueAtTime(0.001, now);
      gain2.gain.setValueAtTime(gainValue, now + 0.06);
      gain2.gain.setValueAtTime(gainValue, now + 0.115);
      gain2.gain.linearRampToValueAtTime(0.001, now + 0.125);

      osc2.connect(gain2);
      gain2.connect(ctx.destination);
      osc2.start(now + 0.06);
      osc2.stop(now + 0.13);

      // Squelch tail burst
      const noiseBuffer = this.createNoiseBuffer(ctx, 0.06);
      const noiseSource = ctx.createBufferSource();
      noiseSource.buffer = noiseBuffer;

      const filter = ctx.createBiquadFilter();
      filter.type = 'bandpass';
      filter.frequency.setValueAtTime(1800, now + 0.12);
      filter.Q.setValueAtTime(3.0, now + 0.12);

      const noiseGain = ctx.createGain();
      noiseGain.gain.setValueAtTime(gainValue * 0.8, now + 0.12);
      noiseGain.gain.exponentialRampToValueAtTime(0.001, now + 0.18);

      noiseSource.connect(filter);
      filter.connect(noiseGain);
      noiseGain.connect(ctx.destination);
      noiseSource.start(now + 0.12);
    } catch (e) {
      // Audio autoplay policy fallback
    }
  }

  /**
   * Squelch static burst (simulates opening or closing radio channel)
   */
  public playStaticBurst(durationSeconds: number = 0.08, volumePercent: number = 85) {
    if (this.isMuted) return;
    const ctx = this.getAudioContext();
    if (!ctx) return;

    try {
      const gainValue = (volumePercent / 100) * 0.35;
      const now = ctx.currentTime;

      const noiseBuffer = this.createNoiseBuffer(ctx, durationSeconds);
      const noiseSource = ctx.createBufferSource();
      noiseSource.buffer = noiseBuffer;

      const filter = ctx.createBiquadFilter();
      filter.type = 'bandpass';
      filter.frequency.setValueAtTime(1600, now);
      filter.Q.setValueAtTime(2.0, now);

      const noiseGain = ctx.createGain();
      noiseGain.gain.setValueAtTime(gainValue, now);
      noiseGain.gain.exponentialRampToValueAtTime(0.001, now + durationSeconds);

      noiseSource.connect(filter);
      filter.connect(noiseGain);
      noiseGain.connect(ctx.destination);
      noiseSource.start(now);
    } catch (e) {}
  }

  /**
   * Frequency tuning click & static blip
   */
  public playTuningClick(volumePercent: number = 85) {
    if (this.isMuted) return;
    const ctx = this.getAudioContext();
    if (!ctx) return;

    try {
      const gainValue = (volumePercent / 100) * 0.25;
      const now = ctx.currentTime;

      const osc = ctx.createOscillator();
      osc.type = 'triangle';
      osc.frequency.setValueAtTime(650, now);
      osc.frequency.exponentialRampToValueAtTime(300, now + 0.03);

      const gain = ctx.createGain();
      gain.gain.setValueAtTime(gainValue, now);
      gain.gain.exponentialRampToValueAtTime(0.001, now + 0.035);

      osc.connect(gain);
      gain.connect(ctx.destination);
      osc.start(now);
      osc.stop(now + 0.04);
    } catch (e) {}
  }

  /**
   * Speech-to-Text: Live Microphone speech recognition while holding PTT
   */
  public startSpeechRecognition(
    onResult: (transcript: string) => void,
    onError?: (err: string) => void
  ): boolean {
    if (typeof window === 'undefined') return false;

    const SpeechRecClass =
      (window as any).SpeechRecognition || (window as any).webkitSpeechRecognition;

    if (!SpeechRecClass) {
      if (onError) onError('Speech Recognition is not supported on this browser. Type in the buffer above.');
      return false;
    }

    try {
      if (this.recognition) {
        try { this.recognition.abort(); } catch (e) {}
      }

      this.recognition = new SpeechRecClass();
      this.recognition.continuous = true;
      this.recognition.interimResults = true;
      this.recognition.lang = 'en-US';

      this.recognition.onresult = (event: any) => {
        let finalTranscript = '';
        for (let i = event.resultIndex; i < event.results.length; i++) {
          finalTranscript += event.results[i][0].transcript;
        }
        if (finalTranscript.trim()) {
          onResult(finalTranscript.trim());
        }
      };

      this.recognition.onerror = (event: any) => {
        if (event.error !== 'no-speech' && onError) {
          onError(`Mic: ${event.error}`);
        }
      };

      this.recognition.onend = () => {
        this.isListeningMic = false;
      };

      this.recognition.start();
      this.isListeningMic = true;
      return true;
    } catch (err: any) {
      if (onError) onError(err.message || 'Microphone access denied.');
      return false;
    }
  }

  public stopSpeechRecognition(): void {
    if (this.recognition) {
      try {
        this.recognition.stop();
      } catch (e) {}
      this.isListeningMic = false;
    }
  }

  public isRecognitionSupported(): boolean {
    if (typeof window === 'undefined') return false;
    return !!((window as any).SpeechRecognition || (window as any).webkitSpeechRecognition);
  }

  /**
   * Text-to-Speech: Audibly reads incoming/outgoing radio transmissions
   * with military radio cadence, opening squelch, and closing Roger Beep!
   */
  public speakRadioMessage(
    text: string,
    volumePercent: number = 85,
    onStart?: () => void,
    onEnd?: () => void
  ) {
    if (this.isMuted) {
      if (onEnd) onEnd();
      return;
    }
    if (typeof window === 'undefined' || !window.speechSynthesis) {
      if (onEnd) onEnd();
      return;
    }

    try {
      window.speechSynthesis.cancel();

      // Play opening squelch burst
      this.playStaticBurst(0.08, volumePercent);

      setTimeout(() => {
        // Clean radio text (remove metadata brackets like [CH 1 // 462.5625 MHz])
        const cleanText = text.replace(/\[.*?\]/g, '').trim() || text;

        const utterance = new SpeechSynthesisUtterance(cleanText);
        utterance.volume = Math.max(0.1, Math.min(1.0, volumePercent / 100));
        utterance.rate = 1.05; // Slightly faster tactical cadence
        utterance.pitch = 0.95; // Slightly lower tactical radio pitch

        // Select an English voice if available
        const voices = window.speechSynthesis.getVoices();
        const englishVoice = voices.find(v => v.lang.startsWith('en') && !v.name.includes('Google'));
        if (englishVoice) {
          utterance.voice = englishVoice;
        }

        utterance.onstart = () => {
          if (onStart) onStart();
        };

        utterance.onend = () => {
          // Play tactical roger beep at end of spoken transmission!
          this.playRogerBeep(volumePercent);
          if (onEnd) onEnd();
        };

        utterance.onerror = () => {
          this.playRogerBeep(volumePercent);
          if (onEnd) onEnd();
        };

        window.speechSynthesis.speak(utterance);
      }, 90);
    } catch (e) {
      this.playRogerBeep(volumePercent);
      if (onEnd) onEnd();
    }
  }
}

export const radioAudio = RadioAudioService.getInstance();
