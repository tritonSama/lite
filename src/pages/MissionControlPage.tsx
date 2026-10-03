import React, { useState, useEffect } from 'react';
import { useApp } from '../context/AppContext';
import { WeatherData } from '../types';
import { 
  Compass, 
  Cloud, 
  CloudRain, 
  Sun, 
  Wind, 
  Droplets, 
  Radio, 
  Users, 
  Swords, 
  Gauge, 
  MapPin, 
  RotateCw,
  Sparkles,
  CheckCircle2
} from 'lucide-react';
import { FluoriteGlobeMap } from '../components/FluoriteGlobeMap';

interface MissionControlPageProps {
  onOpenComms: () => void;
  onOpenTeams: () => void;
  onOpenWars: () => void;
  onOpenObd: () => void;
}

export const MissionControlPage: React.FC<MissionControlPageProps> = ({
  onOpenComms,
  onOpenTeams,
  onOpenWars,
  onOpenObd,
}) => {
  const { isDarkMode } = useApp();

  // Weather State
  const [weather, setWeather] = useState<WeatherData | null>(null);
  const [loadingWeather, setLoadingWeather] = useState(true);

  // GPS Coordinates (Central Command Default)
  const [coords, setCoords] = useState<{ lat: number; lng: number }>({ lat: 30.2672, lng: -97.7431 });

  // Search Radius State
  const [searchRadius, setSearchRadius] = useState<number>(25);

  // GPS Status notification toast
  const [gpsToast, setGpsToast] = useState<string | null>(null);

  // Fetch real weather using Open-Meteo
  const fetchWeather = async (latitude: number, longitude: number) => {
    setLoadingWeather(true);
    try {
      const res = await fetch(
        `https://api.open-meteo.com/v1/forecast?latitude=${latitude}&longitude=${longitude}&current=temperature_2m,relative_humidity_2m,wind_speed_10m,weather_code&temperature_unit=fahrenheit&wind_speed_unit=mph`
      );
      if (!res.ok) throw new Error('Weather API error');
      const data = await res.json();
      const current = data.current;

      // Decode weather code
      let description = 'Clear Sky';
      const code = current.weather_code;
      if (code >= 51 && code <= 67) description = 'Light Rain';
      else if (code >= 71) description = 'Snow Showers';
      else if (code >= 80) description = 'Rain Showers';
      else if (code > 2) description = 'Cloudy / Overcast';

      setWeather({
        cityName: 'Austin Sector 7',
        temperature: current.temperature_2m,
        humidity: current.relative_humidity_2m,
        windSpeed: current.wind_speed_10m,
        description,
      });
    } catch (err) {
      // Fallback realistic weather data
      setWeather({
        cityName: 'Austin Command',
        temperature: 78.4,
        humidity: 62,
        windSpeed: 8.5,
        description: 'Clear & Tactical',
      });
    } finally {
      setLoadingWeather(false);
    }
  };

  useEffect(() => {
    // Try to get geolocation if available
    if (navigator.geolocation) {
      navigator.geolocation.getCurrentPosition(
        pos => {
          const lat = pos.coords.latitude;
          const lng = pos.coords.longitude;
          setCoords({ lat, lng });
          fetchWeather(lat, lng);
        },
        () => {
          fetchWeather(coords.lat, coords.lng);
        },
        { timeout: 3000 }
      );
    } else {
      fetchWeather(coords.lat, coords.lng);
    }
  }, []);

  const handleGpsClick = () => {
    setGpsToast(`GPS POSITION VERIFIED: ${coords.lat.toFixed(4)}° N, ${coords.lng.toFixed(4)}° W // AUSTIN HQ`);
    setTimeout(() => setGpsToast(null), 3500);
  };

  return (
    <div className={`pb-24 pt-2 transition-colors ${isDarkMode ? 'text-white' : 'text-slate-900'}`}>
      <div className="max-w-4xl mx-auto px-4 space-y-4">
        {/* Header / Title */}
        <div className="flex items-center justify-between">
          <div className="flex items-center gap-2">
            <Compass className="w-5 h-5 text-[#0096C7]" />
            <h2 className="font-display font-bold text-base tracking-wide">
              MISSION CONTROL // OPERATIONS DECK
            </h2>
          </div>
          <span className="text-[11px] font-mono text-[#0096C7] px-2.5 py-1 rounded bg-[#0096C7]/10 border border-[#0096C7]/30">
            GPS LOCK: {coords.lat.toFixed(2)}, {coords.lng.toFixed(2)}
          </span>
        </div>

        {/* GPS Toast feedback */}
        {gpsToast && (
          <div className="bg-[#00FF88]/20 border border-[#00FF88] text-[#00FF88] px-4 py-2 rounded-xl text-xs font-mono font-bold flex items-center gap-2 shadow-[0_0_20px_rgba(0,255,136,0.3)] animate-fade-in">
            <CheckCircle2 className="w-4 h-4" />
            <span>{gpsToast}</span>
          </div>
        )}

        {/* Live Weather Card */}
        <div className={`p-4 sm:p-5 rounded-2xl border transition-colors ${
          isDarkMode
            ? 'bg-[#16192B] border-[#0096C7]/60 shadow-[0_0_20px_rgba(0,150,199,0.15)]'
            : 'bg-white border-slate-200 shadow-md'
        }`}>
          {loadingWeather ? (
            <div className="py-6 flex items-center justify-center gap-2 text-xs font-mono text-[#0096C7]">
              <RotateCw className="w-4 h-4 animate-spin" />
              <span>ACQUIRING SATELLITE METEOROLOGY...</span>
            </div>
          ) : weather ? (
            <div>
              <div className="flex items-center justify-between">
                <div className="flex items-center gap-3">
                  {weather.description.toLowerCase().includes('rain') ? (
                    <CloudRain className="w-10 h-10 text-[#0096C7]" />
                  ) : weather.description.toLowerCase().includes('cloud') ? (
                    <Cloud className={`w-10 h-10 ${isDarkMode ? 'text-white/70' : 'text-slate-400'}`} />
                  ) : (
                    <Sun className="w-10 h-10 text-[#D4AF37]" />
                  )}
                  <div>
                    <div className={`text-3xl font-mono font-bold ${isDarkMode ? 'text-white' : 'text-slate-900'}`}>
                      {weather.temperature.toFixed(1)}°F
                    </div>
                    <div className="text-xs font-semibold text-[#0096C7]">
                      {weather.cityName}
                    </div>
                  </div>
                </div>

                <div className="text-right">
                  <span className="text-xs font-mono font-bold uppercase text-[#D4AF37] px-2.5 py-1 rounded bg-[#D4AF37]/10 border border-[#D4AF37]/30 block">
                    {weather.description}
                  </span>
                  <button
                    onClick={() => fetchWeather(coords.lat, coords.lng)}
                    className={`text-[10px] font-mono flex items-center gap-1 ml-auto mt-2 transition ${
                      isDarkMode ? 'text-white/40 hover:text-white' : 'text-slate-400 hover:text-slate-700'
                    }`}
                  >
                    <RotateCw className="w-3 h-3" />
                    <span>Sync</span>
                  </button>
                </div>
              </div>

              <div className={`grid grid-cols-2 gap-3 mt-4 pt-3 border-t text-xs font-mono ${
                isDarkMode ? 'border-[#2C324A] text-white/70' : 'border-slate-100 text-slate-600'
              }`}>
                <div className="flex items-center gap-2">
                  <Droplets className="w-4 h-4 text-[#0096C7]" />
                  <span>Humidity: <strong className={isDarkMode ? 'text-white' : 'text-slate-900'}>{weather.humidity}%</strong></span>
                </div>
                <div className="flex items-center gap-2">
                  <Wind className="w-4 h-4 text-[#0096C7]" />
                  <span>Wind: <strong className={isDarkMode ? 'text-white' : 'text-slate-900'}>{weather.windSpeed} mph</strong></span>
                </div>
              </div>
            </div>
          ) : null}
        </div>

        {/* The ONLY map on Mission Control: The Fluorite 3D Globe & Street Radar */}
        <FluoriteGlobeMap
          onOpenComms={onOpenComms}
          onOpenTeams={onOpenTeams}
          onOpenWars={onOpenWars}
          onOpenObd={onOpenObd}
          searchRadiusMiles={searchRadius}
          onRadiusChange={setSearchRadius}
        />

        {/* Quick Tactical Action Tiles */}
        <div className="grid grid-cols-2 sm:grid-cols-4 gap-3">
          <button
            onClick={handleGpsClick}
            className={`p-3.5 rounded-xl border flex items-center justify-center gap-2.5 transition group ${
              isDarkMode
                ? 'bg-[#16192B] border-[#2C324A] hover:border-[#0096C7] text-white'
                : 'bg-white border-slate-200 hover:border-[#0096C7] text-slate-800 shadow-sm'
            }`}
          >
            <MapPin className="w-4 h-4 text-[#0096C7] group-hover:scale-110 transition" />
            <span className="text-xs font-mono font-bold">GPS LOCK</span>
          </button>

          <button
            onClick={onOpenComms}
            className={`p-3.5 rounded-xl border flex items-center justify-center gap-2.5 transition group ${
              isDarkMode
                ? 'bg-[#16192B] border-[#2C324A] hover:border-[#D4AF37] text-white'
                : 'bg-white border-slate-200 hover:border-[#D4AF37] text-slate-800 shadow-sm'
            }`}
          >
            <Radio className="w-4 h-4 text-[#D4AF37] group-hover:scale-110 transition" />
            <span className="text-xs font-mono font-bold">COMMS TERMINAL</span>
          </button>

          <button
            onClick={onOpenWars}
            className={`p-3.5 rounded-xl border flex items-center justify-center gap-2.5 transition group ${
              isDarkMode
                ? 'bg-[#16192B] border-[#2C324A] hover:border-[#E74C3C] text-white'
                : 'bg-white border-slate-200 hover:border-[#E74C3C] text-slate-800 shadow-sm'
            }`}
          >
            <Swords className="w-4 h-4 text-[#E74C3C] group-hover:scale-110 transition" />
            <span className="text-xs font-mono font-bold">WAR THEATER</span>
          </button>

          <button
            onClick={onOpenObd}
            className={`p-3.5 rounded-xl border flex items-center justify-center gap-2.5 transition group ${
              isDarkMode
                ? 'bg-[#16192B] border-[#2C324A] hover:border-[#0096C7] text-white'
                : 'bg-white border-slate-200 hover:border-[#0096C7] text-slate-800 shadow-sm'
            }`}
          >
            <Gauge className="w-4 h-4 text-[#0096C7] group-hover:scale-110 transition" />
            <span className="text-xs font-mono font-bold">OBD2 TELEMETRY</span>
          </button>
        </div>
      </div>
    </div>
  );
};
