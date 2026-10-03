import React, { useRef, useEffect, useState, useMemo } from 'react';
import { useApp } from '../context/AppContext';
import { GlobeMarker, GlobeMarkerType } from '../types';
import { 
  Compass, 
  ZoomIn, 
  ZoomOut, 
  RotateCcw, 
  Radio, 
  Swords, 
  Users, 
  Satellite, 
  MapPin, 
  Navigation, 
  Layers, 
  Eye, 
  EyeOff, 
  Maximize2, 
  Share2, 
  Shield, 
  Sparkles, 
  Zap, 
  Activity, 
  Info, 
  X, 
  ExternalLink, 
  Gauge, 
  Battery, 
  Wifi, 
  Flame, 
  Droplet, 
  Wind, 
  TreePine, 
  Coins, 
  CheckCircle2, 
  AlertTriangle,
  Play,
  Pause,
  ArrowUpRight,
  Calendar,
  Clock,
  Sliders,
  MessageSquare,
  RotateCw
} from 'lucide-react';

interface FluoriteGlobeMapProps {
  onOpenComms?: () => void;
  onOpenTeams?: () => void;
  onOpenWars?: () => void;
  onOpenObd?: () => void;
  searchRadiusMiles?: number;
  onRadiusChange?: (miles: number) => void;
}

// Austin Sector 7 Origin (Central Command reference point)
const BASE_LAT = 30.2672;
const BASE_LNG = -97.7431;

// Haversine formula to calculate real distance in kilometers
function getDistanceKm(lat1: number, lon1: number, lat2: number, lon2: number): number {
  const R = 6371; // Earth radius in km
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

// Calculate compass bearing from point 1 to point 2 in degrees
function getBearingDeg(lat1: number, lon1: number, lat2: number, lon2: number): number {
  const y = Math.sin(((lon2 - lon1) * Math.PI) / 180) * Math.cos((lat2 * Math.PI) / 180);
  const x =
    Math.cos((lat1 * Math.PI) / 180) * Math.sin((lat2 * Math.PI) / 180) -
    Math.sin((lat1 * Math.PI) / 180) *
      Math.cos((lat2 * Math.PI) / 180) *
      Math.cos(((lon2 - lon1) * Math.PI) / 180);
  const brng = (Math.atan2(y, x) * 180) / Math.PI;
  return (brng + 360) % 360;
}

// Convert bearing in degrees to 8-point compass cardinal
function getCardinal(deg: number): string {
  const cardinals = ['N', 'NE', 'E', 'SE', 'S', 'SW', 'W', 'NW'];
  const index = Math.round(deg / 45) % 8;
  return cardinals[index];
}

export const FluoriteGlobeMap: React.FC<FluoriteGlobeMapProps> = ({
  onOpenComms,
  onOpenTeams,
  onOpenWars,
  onOpenObd,
  searchRadiusMiles,
  onRadiusChange,
}) => {
  const { 
    teams, 
    friends, 
    selectedTeamId, 
    wars, 
    obdState, 
    declareWar, 
    inspectEnvelope, 
    events, 
    toggleRsvp, 
    isDarkMode, 
    openComms 
  } = useApp();

  const canvasRef = useRef<HTMLCanvasElement>(null);

  // Active search radius state: initialized from searchRadiusMiles prop or default 25
  const [activeRadius, setActiveRadius] = useState<number>(searchRadiusMiles ?? 25);
  const [filterAllByRadius, setFilterAllByRadius] = useState<boolean>(true);

  // 15-second countdown timer for rotation after last touch
  const [secondsRemaining, setSecondsRemaining] = useState<number>(0);

  useEffect(() => {
    if (searchRadiusMiles !== undefined) {
      setActiveRadius(searchRadiusMiles);
    }
  }, [searchRadiusMiles]);

  // Camera 3D Spherical & Pan State
  // yaw: Longitude rotation angle
  // pitch: Latitude tilt angle
  // zoom: 0.5 (Outer Space) to 25.0+ (Street Level)
  const [yaw, setYaw] = useState<number>(-BASE_LNG * (Math.PI / 180));
  const [pitch, setPitch] = useState<number>(BASE_LAT * (Math.PI / 180));
  const [zoom, setZoom] = useState<number>(() => {
    if (searchRadiusMiles !== undefined) {
      if (searchRadiusMiles <= 2) return 14.0;
      if (searchRadiusMiles <= 25) return 6.0;
      if (searchRadiusMiles <= 50) return 3.5;
      return 1.8;
    }
    return 1.0;
  });
  const [isAutoOrbit, setIsAutoOrbit] = useState<boolean>(true); // Rotating at idle by default

  // 15-second idle timer: user requested exactly 15 seconds before rotating after last touch
  const IDLE_ROTATION_DELAY_MS = 15000;
  const lastTouchTimeRef = useRef<number>(Date.now());
  const idleResumeTimerRef = useRef<number | null>(null);

  useEffect(() => {
    const timer = setInterval(() => {
      const elapsed = Date.now() - lastTouchTimeRef.current;
      const rem = Math.max(0, Math.ceil((IDLE_ROTATION_DELAY_MS - elapsed) / 1000));
      setSecondsRemaining(rem);
    }, 200);
    return () => clearInterval(timer);
  }, []);

  // Recenter visual pulse timestamp for targeting reticle on My Club
  const [recenterPulseTime, setRecenterPulseTime] = useState<number>(0);

  // Synchronize zoom and focus when searchRadiusMiles changes from slider
  useEffect(() => {
    if (searchRadiusMiles !== undefined) {
      if (searchRadiusMiles <= 2) {
        setZoom(14.0); // Street level
      } else if (searchRadiusMiles <= 25) {
        setZoom(6.0); // City sector
      } else if (searchRadiusMiles <= 50) {
        setZoom(3.5); // County
      } else {
        setZoom(1.8); // State / regional
      }
      setYaw(-BASE_LNG * (Math.PI / 180));
      setPitch(BASE_LAT * (Math.PI / 180));
    }
  }, [searchRadiusMiles]);

  // Interaction registrar: resets the 15-second idle timer
  const registerInteraction = () => {
    lastTouchTimeRef.current = Date.now();
    setIsAutoOrbit(false);
    if (idleResumeTimerRef.current) clearTimeout(idleResumeTimerRef.current);
    idleResumeTimerRef.current = setTimeout(() => {
      setIsAutoOrbit(true);
    }, IDLE_ROTATION_DELAY_MS);
  };

  // Toast feedback
  const [toastMessage, setToastMessage] = useState<string | null>(null);
  const toastTimeoutRef = useRef<number | null>(null);

  const showToast = (msg: string) => {
    if (toastTimeoutRef.current) clearTimeout(toastTimeoutRef.current);
    setToastMessage(msg);
    toastTimeoutRef.current = setTimeout(() => setToastMessage(null), 3000);
  };

  // Drag interaction
  const [isDragging, setIsDragging] = useState(false);
  const dragStartRef = useRef({ x: 0, y: 0, startYaw: 0, startPitch: 0 });

  // Selected Marker for Full Information Dossier
  const [selectedMarker, setSelectedMarker] = useState<GlobeMarker | null>(null);
  const [hoveredMarker, setHoveredMarker] = useState<GlobeMarker | null>(null);

  // Layer Visibility Toggles
  const [showFriends, setShowFriends] = useState(true);
  const [showOtherClubs, setShowOtherClubs] = useState(true);
  const [showSatellites, setShowSatellites] = useState(true);
  const [showTasks, setShowTasks] = useState(true);
  const [showEvents, setShowEvents] = useState(true);
  const [showComparisonRays, setShowComparisonRays] = useState(true);
  const [showStreetGrid, setShowStreetGrid] = useState(true);
  const [showComparisonDrawer, setShowComparisonDrawer] = useState(false);

  // Real-time animation clock
  const [time, setTime] = useState(0);

  // My Club Identification
  const myClubId = selectedTeamId || 'water';
  const myClubData = useMemo(() => {
    return teams.find(t => t.id === myClubId) || teams[0];
  }, [teams, myClubId]);

  // Construct All Comprehensive Globe Markers
  const allMarkers: GlobeMarker[] = useMemo(() => {
    const list: GlobeMarker[] = [];

    // 1. MY CLUB (Home Base / Central Command)
    list.push({
      id: 'marker-my-club',
      name: `${myClubData.name} (My Club HQ)`,
      type: 'my_club',
      lat: BASE_LAT,
      lng: BASE_LNG,
      altitudeKm: 0.15,
      color: myClubData.color || '#00FFFF',
      streetAddress: '400 Congress Ave, Austin, TX 78701',
      sectorId: 'Sector 7 Alpha [Downtown Core]',
      clubId: myClubData.id,
      memberCount: myClubData.memberCount,
      stakedFlr: 45200,
      statusText: 'Home Command • Active Perimeter Defense',
      did: `did:nexus:team:${myClubData.id}:7a4c9d1e`,
      ed25519Key: `ed25519:${myClubData.id}_command_key_8371`,
    });

    // 2. OTHER CLUBS / GUILDS (Worldwide & Regional)
    teams.forEach((team, idx) => {
      if (team.id === myClubData.id) return;

      let lat = BASE_LAT;
      let lng = BASE_LNG;
      let street = '';
      let sector = '';
      let stakedFlr = 15000;

      if (team.id === 'water') {
        lat = 30.2585;
        lng = -97.7490;
        street = '111 Cesar Chavez St (Lady Bird Harbor)';
        sector = 'Sector 7 Maritime';
        stakedFlr = 24500;
      } else if (team.id === 'fire') {
        lat = 30.2640;
        lng = -97.7340;
        street = '901 E 5th St (East Industrial Depot)';
        sector = 'Sector 7 Vulcan Depot';
        stakedFlr = 18900;
      } else if (team.id === 'earth') {
        lat = 30.2740;
        lng = -97.7410;
        street = '1200 Lavaca St (State Capital Foundry)';
        sector = 'Sector 7 Terra Citadel';
        stakedFlr = 31200;
      } else if (team.id === 'wind') {
        lat = 30.2688;
        lng = -97.7420;
        street = '401 Congress Ave (Frost Sky Spire)';
        sector = 'Sector 7 Zephyr Recon';
        stakedFlr = 16400;
      } else {
        // Offset for custom user-created clubs
        lat = BASE_LAT + (idx * 0.015 - 0.03);
        lng = BASE_LNG + (idx * 0.018 - 0.02);
        street = `Sector Perimeter Route ${idx + 10}`;
        sector = `Sector Outpost #${idx}`;
        stakedFlr = 12000;
      }

      list.push({
        id: `marker-club-${team.id}`,
        name: team.name,
        type: 'other_club',
        lat,
        lng,
        altitudeKm: 0.12,
        color: team.color || '#D4AF37',
        streetAddress: street,
        sectorId: sector,
        clubId: team.id,
        memberCount: team.memberCount,
        stakedFlr,
        statusText: `Rival Faction • ${team.rating.toFixed(1)} Rating • ${team.treatyIds?.length || 0} Treaties`,
        did: `did:nexus:team:${team.id}:${Math.abs(team.id.charCodeAt(0) * 1337).toString(16)}`,
        ed25519Key: `ed25519:${team.id}_vault_sign_00f8`,
      });
    });

    // 3. FRIENDS / SQUAD UNITS (Real-time locations on the ground & in flight)
    friends.forEach(fr => {
      list.push({
        id: fr.id,
        name: fr.name,
        type: 'friend',
        lat: fr.lat,
        lng: fr.lng,
        altitudeKm: fr.callsign === 'GHOST-2' ? 0.25 : 0.04,
        color: fr.color,
        streetAddress: fr.street,
        sectorId: 'Sector 7 Friendly Force',
        friendCallsign: fr.callsign,
        velocityMph: fr.callsign === 'TITAN-1' ? 28 : fr.callsign === 'GHOST-2' ? 44 : 4,
        batteryPercent: fr.battery,
        healthPercent: fr.health,
        radioFrequency: fr.freq,
        statusText: `Allied Squad • Callsign ${fr.callsign} • Radio ${fr.freq}`,
        did: `did:nexus:user:${fr.callsign.toLowerCase()}:8f2a`,
        ed25519Key: `ed25519:${fr.callsign.toLowerCase()}_secp_vault`,
      });
    });

    // 4. SATELLITES (Orbiting High Above the Globe)
    const satellitesData = [
      {
        id: 'sat-nexus-recon-1',
        name: 'NEXUS-RECON-1 (Orbital Sensor)',
        lat: 34.5,
        lng: -88.0,
        altKm: 480, // LEO
        color: '#00FFFF',
        period: 94.2,
        inc: 51.6,
        sensor: 'Multispectral Optical + SAR Radar',
        downlink: '10.5 Gbps Q-Band',
      },
      {
        id: 'sat-fluoridian-relay',
        name: 'FLUORIDIAN-RELAY-ALPHA (P2P Mesh Hub)',
        lat: 18.2,
        lng: -112.5,
        altKm: 1200, // MEO
        color: '#00FF88',
        period: 112.8,
        inc: 42.0,
        sensor: 'Fluoridian Quantum Validator Node',
        downlink: '40 Gbps Laser Crosslink',
      },
      {
        id: 'sat-noaa-metsat-16',
        name: 'NOAA-METSAT-16 (Atmospheric Radar)',
        lat: 0.0,
        lng: -75.2,
        altKm: 35786, // GEO
        color: '#D4AF37',
        period: 1436.1,
        inc: 0.1,
        sensor: 'Advanced Baseline Imager (ABI) + Space Weather',
        downlink: 'Weather Feed Direct Broadcast',
      },
      {
        id: 'sat-starlink-flr-88',
        name: 'STARLINK-FLR-88 (Broadband Constellation)',
        lat: 42.1,
        lng: -95.4,
        altKm: 550, // LEO
        color: '#4DBBDF',
        period: 95.8,
        inc: 53.2,
        sensor: 'Phased Array Ku/Ka Downlink',
        downlink: '350 Mbps Low-Latency',
      },
      {
        id: 'sat-gps-iii-f2',
        name: 'GPS-BLOCK-III-F2 (Atomic Clock Nav)',
        lat: -22.4,
        lng: -60.8,
        altKm: 20200, // MEO
        color: '#FF6B35',
        period: 718.0,
        inc: 55.0,
        sensor: 'Rubidium Atomic Frequency Standard (RAFS)',
        downlink: 'L1C/A, L2C, L5 PNT Carrier',
      },
    ];

    satellitesData.forEach(sat => {
      list.push({
        id: sat.id,
        name: sat.name,
        type: 'satellite',
        lat: sat.lat,
        lng: sat.lng,
        altitudeKm: sat.altKm,
        color: sat.color,
        streetAddress: `Orbital Track • Altitude ${sat.altKm} km`,
        sectorId: `Orbital Plane Inc ${sat.inc}°`,
        orbitPeriodMin: sat.period,
        orbitInclinationDeg: sat.inc,
        sensorPayload: sat.sensor,
        downlinkBandwidth: sat.downlink,
        statusText: `LEO/MEO Satellite • Speed 7.6 km/s • Active Telemetry`,
        did: `did:nexus:sat:${sat.id.slice(4)}:orbit_0`,
        ed25519Key: `ed25519:satellite_transponder_${sat.id.slice(4)}`,
      });
    });

    // 5. TASKS / MARKETPLACE BOUNTIES (Real Street Geocoded Locations)
    list.push({
      id: 'marker-task-lot-cleanup',
      name: 'Bounty: Demolition & Lot Clearing',
      type: 'task',
      lat: 30.2655,
      lng: -97.7450,
      altitudeKm: 0.05,
      color: '#D4AF37',
      streetAddress: '300 W 3rd St, Austin, TX',
      sectorId: 'Sector 7 Downtown Parcel',
      bountyUsd: 180,
      bountyFlr: 20,
      taskCategory: 'Equipment & Labor',
      statusText: 'Published Bounty • Escrow Locked • Bidding Active',
      did: 'did:nexus:task:lot-cleanup:8f2a',
    });

    list.push({
      id: 'marker-task-obd-fleet',
      name: 'Bounty: Commercial Fleet OBD-II Scan',
      type: 'task',
      lat: 30.2710,
      lng: -97.7440,
      altitudeKm: 0.05,
      color: '#0096C7',
      streetAddress: '800 Colorado St, Austin, TX',
      sectorId: 'Sector 7 Logistics Zone',
      bountyUsd: 240,
      bountyFlr: 35,
      taskCategory: 'Vehicle Telemetry',
      statusText: 'Published Bounty • Escrow Locked • Verified Provider Selected',
      did: 'did:nexus:task:obd-fleet:3c7e',
    });

    // 6. CONNECTED OBD2 VEHICLE (if active)
    if (obdState.isConnected) {
      list.push({
        id: 'marker-obd-vehicle',
        name: 'My Vehicle (OBD-II Bluetooth Link)',
        type: 'obd_vehicle',
        lat: BASE_LAT + 0.002,
        lng: BASE_LNG - 0.003,
        altitudeKm: 0.02,
        color: '#00FF88',
        streetAddress: 'Congress Ave & 6th St Intersection',
        sectorId: 'Live Mobile Vehicle Transceiver',
        obdRpm: obdState.rpm,
        obdSpeedMph: obdState.speed,
        statusText: `Live Bluetooth Telemetry • ${obdState.rpm} RPM • ${obdState.speed} MPH`,
        did: `did:nexus:obd:${obdState.deviceMac.replace(/:/g, '')}`,
      });
    }

    // 7. EVENTS / SECTOR OPERATIONS
    events.forEach(ev => {
      list.push({
        id: ev.id,
        name: `Event: ${ev.title}`,
        type: 'event',
        lat: ev.lat,
        lng: ev.lng,
        altitudeKm: 0.08,
        color: '#B185FF', // Purple / Fluorite Violet
        streetAddress: ev.locationLabel,
        sectorId: `Sector Event [${ev.category}]`,
        eventDate: ev.date,
        eventTime: ev.time,
        eventAttendees: ev.attendeesCount,
        bountyFlr: ev.rewardFlr,
        statusText: `Event • ${ev.date} @ ${ev.time} • ${ev.attendeesCount} Attending • ${ev.isRsvp ? 'RSVP Active' : 'RSVP Open'}`,
        did: `did:nexus:event:${ev.id.slice(6)}`,
      });
    });

    return list;
  }, [teams, friends, myClubData, obdState, events]);

  // Compute Relative Comparisons between My Club and Every Marker
  const comparisonList = useMemo(() => {
    return allMarkers
      .filter(m => m.type !== 'my_club')
      .map(m => {
        const distKm = getDistanceKm(BASE_LAT, BASE_LNG, m.lat, m.lng);
        const distMi = distKm * 0.621371;
        const bearing = getBearingDeg(BASE_LAT, BASE_LNG, m.lat, m.lng);
        const cardinal = getCardinal(bearing);

        return {
          marker: m,
          distKm,
          distMi,
          bearing,
          cardinal,
        };
      })
      .sort((a, b) => a.distKm - b.distKm);
  }, [allMarkers]);

  // Count of markers strictly inside the active search radius perimeter
  const inPerimeterCount = useMemo(() => {
    return allMarkers.filter(m => {
      if (m.type === 'satellite' || m.type === 'my_club') return false;
      const d = getDistanceKm(BASE_LAT, BASE_LNG, m.lat, m.lng) * 0.621371;
      return d <= activeRadius;
    }).length;
  }, [allMarkers, activeRadius]);

  // Continuous animation loop for satellites, pulsing beacons, and idle rotation
  useEffect(() => {
    let animId: number;
    const loop = () => {
      setTime(t => t + 0.02);

      // Rotate at idle ONLY when at least 15 seconds have elapsed since last user touch / interaction
      const elapsedSinceTouch = Date.now() - lastTouchTimeRef.current;
      if (isAutoOrbit && !isDragging && elapsedSinceTouch >= IDLE_ROTATION_DELAY_MS) {
        // Slow rotation at high zoom, steady gentle orbit at global/space view
        const orbitSpeed = zoom > 6.0 ? 0.0003 : 0.0016;
        setYaw(y => y + orbitSpeed);
      }

      animId = requestAnimationFrame(loop);
    };
    animId = requestAnimationFrame(loop);
    return () => cancelAnimationFrame(animId);
  }, [isAutoOrbit, isDragging, zoom]);

  // Project Spherical (Lat, Lng, Alt) to 3D Screen Coordinates (x, y, visible)
  const project3D = (
    lat: number,
    lng: number,
    altKm: number,
    width: number,
    height: number
  ): { x: number; y: number; visible: boolean; scale: number; distToCamera: number } => {
    const centerX = width / 2;
    const centerY = height / 2;

    // Base globe radius on canvas
    const baseSphereRadius = Math.min(width, height) * 0.36 * zoom;

    // Satellite altitude scale factor
    const altitudeOffset = Math.min(altKm / 200, 120) * (zoom < 3 ? 1 : 0.2);
    const radius = baseSphereRadius + altitudeOffset;

    // Coordinates in radians
    const latRad = (lat * Math.PI) / 180;
    const lngRad = (lng * Math.PI) / 180;

    // 1. Longitude rotation around Y-axis (polar axis)
    // When yaw = -lngRad, relLng = 0, so target longitude points directly forward (+Z)
    const relLng = lngRad + yaw;
    const x0 = radius * Math.cos(latRad) * Math.sin(relLng);
    const y0 = radius * Math.sin(latRad);
    const z0 = radius * Math.cos(latRad) * Math.cos(relLng);

    // 2. Latitude tilt (pitch) around X-axis
    // When pitch = latRad, target latitude tilts down so it lies on the equator facing camera
    const cosPitch = Math.cos(pitch);
    const sinPitch = Math.sin(pitch);
    const y1 = y0 * cosPitch - z0 * sinPitch;
    const z1 = y0 * sinPitch + z0 * cosPitch;

    // Visibility threshold: on visible front hemisphere facing camera (z1 >= 0)
    // High-altitude satellites are visible beyond the horizon
    const horizonThreshold = altKm > 100 ? -radius * 0.35 : 0;
    const visible = z1 >= horizonThreshold;

    // Screen projection (canvas Y increases downwards, so screenY = centerY - y1)
    const screenX = centerX + x0;
    const screenY = centerY - y1;

    return {
      x: screenX,
      y: screenY,
      visible,
      scale: Math.max(0.5, (z1 + radius) / (2 * radius)),
      distToCamera: radius * 2 - z1,
    };
  };

  // 3D Canvas Rendering Loop
  useEffect(() => {
    const canvas = canvasRef.current;
    if (!canvas) return;
    const ctx = canvas.getContext('2d');
    if (!ctx) return;

    const width = canvas.width;
    const height = canvas.height;
    ctx.clearRect(0, 0, width, height);

    const centerX = width / 2;
    const centerY = height / 2;
    const sphereRadius = Math.min(width, height) * 0.36 * zoom;

    const isStreetZoom = zoom >= 6.0;
    const isDeepStreetZoom = zoom >= 14.0;

    // 1. Deep Space Fluorite Starfield Background
    const bgGrad = ctx.createRadialGradient(
      centerX,
      centerY,
      30,
      centerX,
      centerY,
      Math.max(width, height) * 0.85
    );
    bgGrad.addColorStop(0, '#0E1326');
    bgGrad.addColorStop(0.6, '#080B15');
    bgGrad.addColorStop(1, '#04050A');
    ctx.fillStyle = bgGrad;
    ctx.fillRect(0, 0, width, height);

    // Subtle background stars (if not deep in street zoom)
    if (!isDeepStreetZoom) {
      for (let i = 0; i < 70; i++) {
        const sx = ((i * 137.5) % width);
        const sy = ((i * 269.3) % height);
        const twinkle = Math.sin(time * 3 + i) * 0.4 + 0.6;
        ctx.fillStyle = `rgba(255, 255, 255, ${0.35 * twinkle})`;
        ctx.fillRect(sx, sy, 1.2, 1.2);
      }
    }

    // 2. Render 3D Globe Sphere
    if (sphereRadius > 15) {
      // Atmospheric Outer Glow Halo
      const atmoGrad = ctx.createRadialGradient(
        centerX,
        centerY,
        sphereRadius * 0.95,
        centerX,
        centerY,
        sphereRadius * 1.18
      );
      atmoGrad.addColorStop(0, 'rgba(0, 255, 255, 0.22)');
      atmoGrad.addColorStop(0.5, 'rgba(83, 0, 255, 0.12)');
      atmoGrad.addColorStop(1, 'rgba(0, 0, 0, 0)');
      ctx.fillStyle = atmoGrad;
      ctx.beginPath();
      ctx.arc(centerX, centerY, sphereRadius * 1.18, 0, Math.PI * 2);
      ctx.fill();

      // Globe Base Dark Oceanic Sphere
      const oceanGrad = ctx.createRadialGradient(
        centerX - sphereRadius * 0.3,
        centerY - sphereRadius * 0.3,
        10,
        centerX,
        centerY,
        sphereRadius
      );
      oceanGrad.addColorStop(0, '#10223D');
      oceanGrad.addColorStop(0.5, '#0C172A');
      oceanGrad.addColorStop(1, '#060B14');
      ctx.fillStyle = oceanGrad;
      ctx.beginPath();
      ctx.arc(centerX, centerY, sphereRadius, 0, Math.PI * 2);
      ctx.fill();

      // 3. Latitude & Longitude Meridians (3D Wireframe Grid)
      ctx.strokeStyle = 'rgba(0, 150, 199, 0.15)';
      ctx.lineWidth = 1;

      // Draw latitude parallels every 30 degrees
      for (let lat = -60; lat <= 60; lat += 30) {
        ctx.beginPath();
        let first = true;
        for (let lng = -180; lng <= 180; lng += 10) {
          const pt = project3D(lat, lng, 0, width, height);
          if (pt.visible) {
            if (first) {
              ctx.moveTo(pt.x, pt.y);
              first = false;
            } else {
              ctx.lineTo(pt.x, pt.y);
            }
          } else {
            first = true;
          }
        }
        ctx.stroke();
      }

      // Draw longitude meridians every 45 degrees
      for (let lng = -180; lng < 180; lng += 45) {
        ctx.beginPath();
        let first = true;
        for (let lat = -85; lat <= 85; lat += 5) {
          const pt = project3D(lat, lng, 0, width, height);
          if (pt.visible) {
            if (first) {
              ctx.moveTo(pt.x, pt.y);
              first = false;
            } else {
              ctx.lineTo(pt.x, pt.y);
            }
          } else {
            first = true;
          }
        }
        ctx.stroke();
      }

      // 4. Stylized Continents / Continental Outlines
      // Major continental landmarks: North America, South America, Eurasia, Africa, Australia
      const continentalPolys: [number, number][][] = [
        // North America contour
        [
          [55, -130], [65, -165], [70, -130], [60, -90], [50, -60],
          [40, -70], [30, -80], [25, -80], [20, -100], [30, -115],
          [45, -125], [55, -130]
        ],
        // South America contour
        [
          [10, -75], [5, -50], [-10, -35], [-25, -45], [-50, -70],
          [-55, -65], [-40, -75], [-20, -70], [0, -80], [10, -75]
        ],
        // Europe / Africa contour
        [
          [60, 10], [70, 40], [55, 30], [45, 10], [35, -5],
          [20, -15], [5, 10], [-30, 20], [-35, 30], [5, 45],
          [30, 35], [40, 25], [50, 15], [60, 10]
        ],
        // Asia contour
        [
          [65, 40], [75, 100], [70, 170], [50, 140], [35, 120],
          [20, 110], [10, 80], [25, 60], [40, 50], [65, 40]
        ],
        // Australia
        [
          [-15, 130], [-12, 142], [-25, 150], [-38, 145], [-35, 118],
          [-22, 115], [-15, 130]
        ]
      ];

      ctx.fillStyle = 'rgba(0, 150, 199, 0.08)';
      ctx.strokeStyle = 'rgba(0, 255, 255, 0.28)';
      ctx.lineWidth = 1.2;

      continentalPolys.forEach(poly => {
        ctx.beginPath();
        let count = 0;
        poly.forEach(([cLat, cLng]) => {
          const pt = project3D(cLat, cLng, 0, width, height);
          if (pt.visible) {
            if (count === 0) ctx.moveTo(pt.x, pt.y);
            else ctx.lineTo(pt.x, pt.y);
            count++;
          }
        });
        if (count > 2) {
          ctx.closePath();
          ctx.fill();
          ctx.stroke();
        }
      });
    }

    // 5. If Zoomed to Street Level (zoom >= 6.0), Render Austin Tactical Street Grid
    if (showStreetGrid && isStreetZoom) {
      const myPt = project3D(BASE_LAT, BASE_LNG, 0, width, height);
      if (myPt.visible) {
        ctx.save();
        ctx.translate(myPt.x, myPt.y);

        // Street grid scale in pixels
        const streetScale = (zoom - 5.0) * 35;

        // Street background parcel blocks
        ctx.fillStyle = 'rgba(12, 22, 40, 0.65)';
        ctx.strokeStyle = 'rgba(0, 255, 255, 0.15)';
        ctx.lineWidth = 1;

        // Draw grid lines representing Austin downtown streets
        const streetLines = [
          // East-West streets
          { name: '1st St / Cesar Chavez', offset: 120, axis: 'EW' },
          { name: '2nd St', offset: 80, axis: 'EW' },
          { name: '3rd St', offset: 40, axis: 'EW' },
          { name: '4th St', offset: 0, axis: 'EW' },
          { name: '5th St', offset: -40, axis: 'EW' },
          { name: '6th St', offset: -80, axis: 'EW' },
          { name: '7th St', offset: -120, axis: 'EW' },
          // North-South avenues
          { name: 'San Antonio St', offset: -120, axis: 'NS' },
          { name: 'Guadalupe St', offset: -80, axis: 'NS' },
          { name: 'Lavaca St', offset: -40, axis: 'NS' },
          { name: 'Congress Ave', offset: 0, axis: 'NS', main: true },
          { name: 'Brazos St', offset: 40, axis: 'NS' },
          { name: 'San Jacinto Blvd', offset: 80, axis: 'NS' },
          { name: 'Trinity St', offset: 120, axis: 'NS' },
        ];

        // Draw building block parcels
        for (let bx = -3; bx <= 2; bx++) {
          for (let by = -3; by <= 2; by++) {
            const px = bx * 40 * (streetScale / 40) + 4;
            const py = by * 40 * (streetScale / 40) + 4;
            const pw = 32 * (streetScale / 40);
            const ph = 32 * (streetScale / 40);

            ctx.fillStyle = 'rgba(16, 25, 48, 0.5)';
            ctx.fillRect(px, py, pw, ph);

            // Parcel neon corner accents
            ctx.strokeStyle = 'rgba(0, 150, 199, 0.25)';
            ctx.strokeRect(px, py, pw, ph);
          }
        }

        // Draw road arteries
        streetLines.forEach(st => {
          const scaledOffset = st.offset * (streetScale / 40);

          ctx.beginPath();
          if (st.axis === 'EW') {
            ctx.moveTo(-220 * (streetScale / 40), scaledOffset);
            ctx.lineTo(220 * (streetScale / 40), scaledOffset);
          } else {
            ctx.moveTo(scaledOffset, -220 * (streetScale / 40));
            ctx.lineTo(scaledOffset, 220 * (streetScale / 40));
          }

          ctx.strokeStyle = st.main
            ? 'rgba(0, 255, 255, 0.7)'
            : 'rgba(0, 150, 199, 0.35)';
          ctx.lineWidth = st.main ? 2.5 : 1.2;
          ctx.stroke();

          // Street names when zoomed deep
          if (isDeepStreetZoom) {
            ctx.font = 'bold 9px JetBrains Mono, monospace';
            ctx.fillStyle = st.main ? '#00FFFF' : 'rgba(255, 255, 255, 0.6)';
            if (st.axis === 'EW') {
              ctx.fillText(st.name, -190 * (streetScale / 40), scaledOffset - 4);
            } else {
              ctx.save();
              ctx.translate(scaledOffset + 4, -160 * (streetScale / 40));
              ctx.rotate(Math.PI / 2);
              ctx.fillText(st.name, 0, 0);
              ctx.restore();
            }
          }
        });

        ctx.restore();
      }
    }

    // 6. Pre-project all markers and sort by depth (Z-distance to camera)
    const projectedMarkers = allMarkers
      .map(m => {
        // Filter out based on toggles
        if (m.type === 'friend' && !showFriends) return null;
        if (m.type === 'other_club' && !showOtherClubs) return null;
        if (m.type === 'satellite' && !showSatellites) return null;
        if (m.type === 'task' && !showTasks) return null;
        if (m.type === 'event' && !showEvents) return null;

        // Search Radius filter: accurately filter ground entities outside activeRadius
        const distMi = getDistanceKm(BASE_LAT, BASE_LNG, m.lat, m.lng) * 0.621371;
        if (filterAllByRadius) {
          if (m.type !== 'satellite' && m.type !== 'my_club' && distMi > activeRadius) {
            return null;
          }
        } else {
          if ((m.type === 'task' || m.type === 'event' || m.type === 'obd_vehicle') && distMi > activeRadius) {
            return null;
          }
        }

        // Dynamic satellite orbital motion
        let curLat = m.lat;
        let curLng = m.lng;
        if (m.type === 'satellite') {
          // Orbit angle progresses with time
          const speed = (2 * Math.PI) / (m.orbitPeriodMin || 90);
          curLng = ((m.lng + time * speed * 25) % 360);
        }

        const pt = project3D(curLat, curLng, m.altitudeKm, width, height);
        return {
          marker: m,
          screenX: pt.x,
          screenY: pt.y,
          visible: pt.visible,
          scale: pt.scale,
          distToCam: pt.distToCamera,
          calcLat: curLat,
          calcLng: curLng,
          distMi,
        };
      })
      .filter(item => item !== null && item.visible)
      .sort((a, b) => b!.distToCam - a!.distToCam); // Draw back to front

    // 6.5. Render 3D Radar Geofence Perimeter Ring around My Club HQ at activeRadius miles
    const radarAngDist = activeRadius / 3958.8; // Earth radius in miles
    const baseLatRad = (BASE_LAT * Math.PI) / 180;
    const baseLngRad = (BASE_LNG * Math.PI) / 180;
    const numRingPoints = 64;

    ctx.beginPath();
    let ringFirst = true;
    for (let i = 0; i <= numRingPoints; i++) {
      const bearing = (i * 2 * Math.PI) / numRingPoints;
      const pLatRad = Math.asin(
        Math.sin(baseLatRad) * Math.cos(radarAngDist) +
        Math.cos(baseLatRad) * Math.sin(radarAngDist) * Math.cos(bearing)
      );
      const pLngRad = baseLngRad + Math.atan2(
        Math.sin(bearing) * Math.sin(radarAngDist) * Math.cos(baseLatRad),
        Math.cos(radarAngDist) - Math.sin(baseLatRad) * Math.sin(pLatRad)
      );
      const pt = project3D((pLatRad * 180) / Math.PI, (pLngRad * 180) / Math.PI, 0.05, width, height);
      if (pt.visible) {
        if (ringFirst) {
          ctx.moveTo(pt.x, pt.y);
          ringFirst = false;
        } else {
          ctx.lineTo(pt.x, pt.y);
        }
      }
    }
    ctx.strokeStyle = 'rgba(0, 255, 255, 0.85)';
    ctx.lineWidth = 2;
    ctx.setLineDash([5, 5]);
    ctx.stroke();
    ctx.setLineDash([]);
    ctx.fillStyle = 'rgba(0, 150, 199, 0.08)';
    ctx.fill();

    // Radar scan radial line sweeping the perimeter
    const sweepAngle = (time * 1.8) % (Math.PI * 2);
    const swLatRad = Math.asin(
      Math.sin(baseLatRad) * Math.cos(radarAngDist) +
      Math.cos(baseLatRad) * Math.sin(radarAngDist) * Math.cos(sweepAngle)
    );
    const swLngRad = baseLngRad + Math.atan2(
      Math.sin(sweepAngle) * Math.sin(radarAngDist) * Math.cos(baseLatRad),
      Math.cos(radarAngDist) - Math.sin(baseLatRad) * Math.sin(swLatRad)
    );
    const myClubScreenPt = project3D(BASE_LAT, BASE_LNG, 0.1, width, height);
    const swEdgePt = project3D((swLatRad * 180) / Math.PI, (swLngRad * 180) / Math.PI, 0.05, width, height);
    if (myClubScreenPt.visible && swEdgePt.visible) {
      ctx.beginPath();
      ctx.moveTo(myClubScreenPt.x, myClubScreenPt.y);
      ctx.lineTo(swEdgePt.x, swEdgePt.y);
      ctx.strokeStyle = 'rgba(0, 255, 255, 0.7)';
      ctx.lineWidth = 1.5;
      ctx.stroke();
    }

    // 7. Draw Comparison Vectors (Connecting My Club to Other Clubs & Friends)
    if (showComparisonRays) {
      const myClubProjected = projectedMarkers.find(p => p?.marker.type === 'my_club');

      if (myClubProjected) {
        projectedMarkers.forEach(p => {
          if (!p) return;
          if (p.marker.type === 'other_club' || p.marker.type === 'friend') {
            ctx.beginPath();
            ctx.moveTo(myClubProjected.screenX, myClubProjected.screenY);
            ctx.lineTo(p.screenX, p.screenY);

            const isWarTarget = wars.some(
              w =>
                w.status === 'active' &&
                (w.challengerTeamId === p.marker.clubId || w.defenderTeamId === p.marker.clubId)
            );

            ctx.strokeStyle = isWarTarget
              ? 'rgba(231, 76, 60, 0.65)'
              : p.marker.type === 'friend'
              ? 'rgba(0, 255, 136, 0.45)'
              : 'rgba(212, 175, 55, 0.45)';
            ctx.lineWidth = 1.5;
            ctx.setLineDash([4, 6]);
            ctx.stroke();
            ctx.setLineDash([]);

            // Moving Fluorite Packet pulse on vector
            const progress = (time * 0.6 + p.distToCam * 0.001) % 1.0;
            const pulseX = myClubProjected.screenX + (p.screenX - myClubProjected.screenX) * progress;
            const pulseY = myClubProjected.screenY + (p.screenY - myClubProjected.screenY) * progress;

            ctx.fillStyle = isWarTarget ? '#FF4D4D' : '#00FFFF';
            ctx.beginPath();
            ctx.arc(pulseX, pulseY, 2.5, 0, Math.PI * 2);
            ctx.fill();

            // Distance label midway on line (when hovered or selected)
            if (
              selectedMarker?.id === p.marker.id ||
              hoveredMarker?.id === p.marker.id ||
              isStreetZoom
            ) {
              const midX = (myClubProjected.screenX + p.screenX) / 2;
              const midY = (myClubProjected.screenY + p.screenY) / 2;
              const distKm = getDistanceKm(BASE_LAT, BASE_LNG, p.calcLat, p.calcLng);

              ctx.font = 'bold 9px JetBrains Mono, monospace';
              ctx.fillStyle = '#FFFFFF';
              ctx.fillText(`${distKm.toFixed(1)} km`, midX + 6, midY - 4);
            }
          }
        });
      }
    }

    // 8. Render Markers
    projectedMarkers.forEach(p => {
      if (!p) return;
      const { marker, screenX, screenY, scale } = p;

      const isSelected = selectedMarker?.id === marker.id;
      const isHovered = hoveredMarker?.id === marker.id;
      const markerSize = (isSelected ? 16 : isHovered ? 14 : 10) * Math.max(0.7, scale);

      // A. Outer Glow Aura
      const aura = ctx.createRadialGradient(
        screenX,
        screenY,
        markerSize * 0.3,
        screenX,
        screenY,
        markerSize * 2.2
      );
      aura.addColorStop(0, `${marker.color}88`);
      aura.addColorStop(1, `${marker.color}00`);
      ctx.fillStyle = aura;
      ctx.beginPath();
      ctx.arc(screenX, screenY, markerSize * 2.2, 0, Math.PI * 2);
      ctx.fill();

      // B. Beacon Rings for My Club & Satellites
      if (marker.type === 'my_club') {
        // Emerald/Cyan Pulsing Command Beacon Ring
        const beaconPulse = (time * 4) % 25;
        ctx.strokeStyle = '#00FFFF';
        ctx.lineWidth = 2;
        ctx.beginPath();
        ctx.arc(screenX, screenY, markerSize + beaconPulse, 0, Math.PI * 2);
        ctx.stroke();
      } else if (marker.type === 'satellite') {
        // Satellite Solar Array Line Icons
        ctx.strokeStyle = marker.color;
        ctx.lineWidth = 1.8;
        ctx.beginPath();
        ctx.moveTo(screenX - markerSize * 1.5, screenY);
        ctx.lineTo(screenX + markerSize * 1.5, screenY);
        ctx.stroke();

        // Orbit Ground Sub-point Dotted Line
        const groundPt = project3D(p.calcLat, p.calcLng, 0, width, height);
        if (groundPt.visible) {
          ctx.beginPath();
          ctx.moveTo(screenX, screenY);
          ctx.lineTo(groundPt.x, groundPt.y);
          ctx.strokeStyle = `${marker.color}44`;
          ctx.lineWidth = 1;
          ctx.setLineDash([3, 4]);
          ctx.stroke();
          ctx.setLineDash([]);
        }
      }

      // C. Marker Core Shape
      ctx.fillStyle = marker.color;
      ctx.beginPath();
      ctx.arc(screenX, screenY, markerSize, 0, Math.PI * 2);
      ctx.fill();

      ctx.strokeStyle = '#FFFFFF';
      ctx.lineWidth = isSelected ? 2.5 : 1.2;
      ctx.stroke();

      // D. Labels & Relative Distance
      const showLabel =
        isSelected ||
        isHovered ||
        marker.type === 'my_club' ||
        zoom > 2.0;

      if (showLabel) {
        ctx.font = isSelected
          ? 'bold 11px JetBrains Mono, monospace'
          : '10px JetBrains Mono, monospace';
        ctx.fillStyle = isSelected ? '#FFFFFF' : '#E9EDF2';
        ctx.fillText(marker.name, screenX + markerSize + 6, screenY - 2);

        // Subtext: Distance from My Club + Type
        if (marker.type !== 'my_club') {
          const distKm = getDistanceKm(BASE_LAT, BASE_LNG, p.calcLat, p.calcLng);
          const bearing = getBearingDeg(BASE_LAT, BASE_LNG, p.calcLat, p.calcLng);
          const card = getCardinal(bearing);

          ctx.font = '9px JetBrains Mono, monospace';
          ctx.fillStyle = marker.type === 'satellite' ? '#D4AF37' : '#00FFFF';
          ctx.fillText(
            `${distKm.toFixed(1)} km (${card}) • ${marker.altitudeKm > 10 ? `${marker.altitudeKm}km alt` : marker.type.toUpperCase()}`,
            screenX + markerSize + 6,
            screenY + 11
          );
        }
      }
    });

    // 8. Recenter Lock-On Reticle Animation for My Club HQ
    if (recenterPulseTime > 0 && Date.now() - recenterPulseTime < 4500) {
      const myClubPt = project3D(BASE_LAT, BASE_LNG, 0.1, width, height);
      if (myClubPt.visible) {
        const pulseElapsed = (Date.now() - recenterPulseTime) / 1000;
        const pulseScale = 1 + Math.sin(pulseElapsed * 8) * 0.15;
        const reticleRadius = 26 * pulseScale;

        ctx.save();
        ctx.translate(myClubPt.x, myClubPt.y);

        // Rotating outer brackets
        ctx.rotate(pulseElapsed * 1.5);
        ctx.strokeStyle = '#00FF88';
        ctx.lineWidth = 2;

        // 4 corner brackets
        for (let i = 0; i < 4; i++) {
          ctx.beginPath();
          ctx.arc(0, 0, reticleRadius, (i * Math.PI) / 2 + 0.2, (i * Math.PI) / 2 + 0.8);
          ctx.stroke();
        }

        // Inner crosshairs
        ctx.beginPath();
        ctx.moveTo(-reticleRadius - 8, 0);
        ctx.lineTo(-reticleRadius + 4, 0);
        ctx.moveTo(reticleRadius - 4, 0);
        ctx.lineTo(reticleRadius + 8, 0);
        ctx.moveTo(0, -reticleRadius - 8);
        ctx.lineTo(0, -reticleRadius + 4);
        ctx.moveTo(0, reticleRadius - 4);
        ctx.lineTo(0, reticleRadius + 8);
        ctx.strokeStyle = '#00FFFF';
        ctx.lineWidth = 1.5;
        ctx.stroke();

        ctx.restore();

        // Lock text badge below My Club
        ctx.font = 'bold 10px JetBrains Mono, monospace';
        ctx.fillStyle = '#00FF88';
        ctx.fillText('TARGET LOCKED: MY CLUB HQ', myClubPt.x + 36, myClubPt.y - 12);
        ctx.font = '9px JetBrains Mono, monospace';
        ctx.fillStyle = '#00FFFF';
        ctx.fillText('30.2672° N, 97.7431° W // AUSTIN SECTOR 7', myClubPt.x + 36, myClubPt.y + 2);
      }
    }
  }, [
    yaw,
    pitch,
    zoom,
    time,
    allMarkers,
    selectedMarker,
    hoveredMarker,
    showFriends,
    showOtherClubs,
    showSatellites,
    showTasks,
    showComparisonRays,
    showStreetGrid,
    wars,
    activeRadius,
    recenterPulseTime,
  ]);

  // Mouse & Touch Drag Interaction
  const handleMouseDown = (e: React.MouseEvent) => {
    setIsDragging(true);
    registerInteraction();
    dragStartRef.current = {
      x: e.clientX,
      y: e.clientY,
      startYaw: yaw,
      startPitch: pitch,
    };
  };

  const handleMouseMove = (e: React.MouseEvent) => {
    const canvas = canvasRef.current;
    if (!canvas) return;
    const rect = canvas.getBoundingClientRect();
    const mouseX = e.clientX - rect.left;
    const mouseY = e.clientY - rect.top;

    if (isDragging) {
      registerInteraction();
      const dx = e.clientX - dragStartRef.current.x;
      const dy = e.clientY - dragStartRef.current.y;

      // Sensitivity changes based on zoom level
      const sensitivity = 0.005 / Math.max(1, zoom * 0.4);
      setYaw(dragStartRef.current.startYaw + dx * sensitivity);
      setPitch(
        Math.max(
          -Math.PI / 2 + 0.05,
          Math.min(Math.PI / 2 - 0.05, dragStartRef.current.startPitch + dy * sensitivity)
        )
      );
    } else {
      // Hover hit-testing
      let found: GlobeMarker | null = null;
      for (const m of allMarkers) {
        const pt = project3D(m.lat, m.lng, m.altitudeKm, canvas.width, canvas.height);
        if (pt.visible) {
          const dist = Math.hypot(mouseX - pt.x, mouseY - pt.y);
          if (dist <= 18) {
            found = m;
            break;
          }
        }
      }
      setHoveredMarker(found);
    }
  };

  const handleMouseUp = (e: React.MouseEvent) => {
    if (isDragging) {
      setIsDragging(false);
      registerInteraction();

      const moveDist = Math.hypot(
        e.clientX - dragStartRef.current.x,
        e.clientY - dragStartRef.current.y
      );
      // Minimal drag means click
      if (moveDist < 6) {
        const canvas = canvasRef.current;
        if (!canvas) return;
        const rect = canvas.getBoundingClientRect();
        const mouseX = e.clientX - rect.left;
        const mouseY = e.clientY - rect.top;

        for (const m of allMarkers) {
          const pt = project3D(m.lat, m.lng, m.altitudeKm, canvas.width, canvas.height);
          if (pt.visible) {
            const dist = Math.hypot(mouseX - pt.x, mouseY - pt.y);
            if (dist <= 20) {
              setSelectedMarker(m);
              break;
            }
          }
        }
      }
    }
  };

  const handleMouseLeave = () => {
    if (isDragging) {
      setIsDragging(false);
      registerInteraction();
    }
  };

  // Touch handlers for mobile/tablet screens
  const handleTouchStart = (e: React.TouchEvent) => {
    if (e.touches.length === 1) {
      setIsDragging(true);
      registerInteraction();
      dragStartRef.current = {
        x: e.touches[0].clientX,
        y: e.touches[0].clientY,
        startYaw: yaw,
        startPitch: pitch,
      };
    }
  };

  const handleTouchMove = (e: React.TouchEvent) => {
    if (isDragging && e.touches.length === 1) {
      registerInteraction();
      const dx = e.touches[0].clientX - dragStartRef.current.x;
      const dy = e.touches[0].clientY - dragStartRef.current.y;
      const sensitivity = 0.005 / Math.max(1, zoom * 0.4);
      setYaw(dragStartRef.current.startYaw + dx * sensitivity);
      setPitch(
        Math.max(
          -Math.PI / 2 + 0.05,
          Math.min(Math.PI / 2 - 0.05, dragStartRef.current.startPitch + dy * sensitivity)
        )
      );
    }
  };

  const handleTouchEnd = (e: React.TouchEvent) => {
    if (isDragging) {
      setIsDragging(false);
      registerInteraction();

      if (e.changedTouches.length > 0) {
        const touch = e.changedTouches[0];
        const moveDist = Math.hypot(
          touch.clientX - dragStartRef.current.x,
          touch.clientY - dragStartRef.current.y
        );
        if (moveDist < 10) {
          const canvas = canvasRef.current;
          if (!canvas) return;
          const rect = canvas.getBoundingClientRect();
          const mouseX = touch.clientX - rect.left;
          const mouseY = touch.clientY - rect.top;

          for (const m of allMarkers) {
            const pt = project3D(m.lat, m.lng, m.altitudeKm, canvas.width, canvas.height);
            if (pt.visible) {
              const dist = Math.hypot(mouseX - pt.x, mouseY - pt.y);
              if (dist <= 24) {
                setSelectedMarker(m);
                break;
              }
            }
          }
        }
      }
    }
  };

  // Zoom preset jumps
  const setZoomLevel = (targetZoom: number, focusLat?: number, focusLng?: number) => {
    registerInteraction();
    setZoom(targetZoom);
    if (focusLat !== undefined && focusLng !== undefined) {
      setYaw(-focusLng * (Math.PI / 180));
      setPitch(focusLat * (Math.PI / 180));
    }
  };

  // Focus directly on a selected marker
  const focusOnMarker = (marker: GlobeMarker) => {
    registerInteraction();
    setSelectedMarker(marker);
    const targetYaw = -marker.lng * (Math.PI / 180);
    const targetPitch = marker.lat * (Math.PI / 180);
    setYaw(targetYaw);
    setPitch(targetPitch);

    if (marker.type === 'satellite') {
      setZoom(0.85); // Space view for satellites
    } else if (marker.altitudeKm < 1.0) {
      setZoom(16.0); // Street level for ground targets
    }

    showToast(`TARGET LOCKED: ${marker.name.toUpperCase()}`);
  };

  // Recenter to My Club - precisely centers the globe/street on My Club HQ
  const recenterMyClub = () => {
    registerInteraction();

    const targetYaw = -BASE_LNG * (Math.PI / 180);
    const targetPitch = BASE_LAT * (Math.PI / 180);
    setYaw(targetYaw);
    setPitch(targetPitch);

    // If currently zoomed far out to space, set zoom to a clean 3.2x tactical focus
    // so My Club and the radar radius ring are clearly visible in center view;
    // If already zoomed in deep, maintain street focus (~12x)
    setZoom(z => (z < 2.5 ? 3.2 : z > 16.0 ? 12.0 : z));

    const myClubMarker = allMarkers.find(m => m.type === 'my_club');
    if (myClubMarker) setSelectedMarker(myClubMarker);

    // Trigger visual targeting reticle lock-on animation
    setRecenterPulseTime(Date.now());
    showToast('TARGET LOCKED: MY CLUB HQ [AUSTIN SECTOR 7 // 400 CONGRESS AVE]');
  };

  const handleRadiusChange = (newRadius: number) => {
    setActiveRadius(newRadius);
    registerInteraction();
    if (onRadiusChange) onRadiusChange(newRadius);
  };

  return (
    <div className={`relative rounded-2xl border shadow-xl overflow-hidden transition-colors ${
      isDarkMode ? 'bg-[#080B15] border-[#0096C7]/60 shadow-[0_0_35px_rgba(0,150,199,0.2)]' : 'bg-white border-slate-200 shadow-md'
    }`}>
      {/* 1. Fluorite Tactical Top Telemetry HUD */}
      <div className={`p-3.5 border-b flex flex-wrap items-center justify-between gap-3 transition-colors ${
        isDarkMode ? 'bg-[#121629]/95 border-[#2C324A]' : 'bg-slate-100 border-slate-200'
      }`}>
        <div className="flex items-center gap-2.5">
          <div className="w-8 h-8 rounded-lg bg-[#0096C7]/20 border border-[#0096C7] flex items-center justify-center text-[#00FFFF] shadow-[0_0_12px_rgba(0,255,255,0.4)]">
            <Compass className="w-4 h-4 animate-spin-slow" />
          </div>
          <div>
            <div className="flex items-center gap-2">
              <span className={`font-display font-bold text-xs tracking-wider uppercase ${isDarkMode ? 'text-white' : 'text-slate-900'}`}>
                FLUORITE GLOBAL MISSION DECK // 3D GLOBE & STREET RADAR
              </span>
              <span className="text-[10px] font-mono px-2 py-0.5 rounded bg-[#00FFFF]/10 border border-[#00FFFF]/30 text-[#0096C7] font-semibold">
                {zoom < 1.5
                  ? 'ORBITAL SPACE'
                  : zoom < 6.0
                  ? 'CONTINENTAL'
                  : zoom < 12.0
                  ? 'CITY SECTOR'
                  : 'STREET LEVEL'}
              </span>
            </div>
            <div className={`text-[10px] font-mono flex items-center gap-3 mt-0.5 ${isDarkMode ? 'text-white/50' : 'text-slate-500'}`}>
              <span>MY CLUB: <strong className={isDarkMode ? 'text-white' : 'text-slate-800'}>{myClubData.name}</strong></span>
              <span>•</span>
              <span>ZOOM: {(zoom).toFixed(1)}x</span>
              <span>•</span>
              <span className="text-green-500 font-semibold flex items-center gap-1">
                <Shield className="w-2.5 h-2.5" /> 100% SENSOR COVERAGE
              </span>
            </div>
          </div>
        </div>

        {/* Comparison Drawer Toggle & Quick Actions */}
        <div className="flex items-center gap-2">
          <button
            onClick={() => setShowComparisonDrawer(d => !d)}
            className={`px-3 py-1.5 rounded-xl border text-xs font-mono font-bold flex items-center gap-1.5 transition ${
              showComparisonDrawer
                ? 'bg-[#D4AF37]/20 border-[#D4AF37] text-[#D4AF37]'
                : isDarkMode
                ? 'bg-[#16192B] border-[#2C324A] text-white/70 hover:text-white hover:border-[#0096C7]'
                : 'bg-white border-slate-200 text-slate-700 hover:bg-slate-50'
            }`}
          >
            <Layers className="w-3.5 h-3.5" />
            <span>Relative Comparison ({comparisonList.length})</span>
          </button>

          <button
            onClick={() => setIsAutoOrbit(a => !a)}
            className={`p-1.5 rounded-xl border text-xs font-mono transition ${
              isAutoOrbit
                ? 'bg-[#00FFFF]/20 border-[#00FFFF] text-[#00FFFF]'
                : isDarkMode
                ? 'bg-[#16192B] border-[#2C324A] text-white/50 hover:text-white'
                : 'bg-white border-slate-200 text-slate-500 hover:text-slate-800'
            }`}
            title={isAutoOrbit ? 'Pause Orbit' : 'Auto-Orbit Globe'}
          >
            {isAutoOrbit ? <Pause className="w-4 h-4" /> : <Play className="w-4 h-4" />}
          </button>
        </div>
      </div>

      {/* 1.5. Search Radius & 15-Second Idle Rotation HUD Control Bar */}
      <div className={`px-3.5 py-2 border-b flex flex-wrap items-center justify-between gap-3 text-xs transition-colors ${
        isDarkMode ? 'bg-[#0E1326] border-[#2C324A]' : 'bg-slate-50 border-slate-200'
      }`}>
        <div className="flex flex-wrap items-center gap-3">
          <div className="flex items-center gap-2">
            <Sliders className="w-4 h-4 text-[#0096C7]" />
            <span className={`font-mono font-bold text-xs ${isDarkMode ? 'text-white' : 'text-slate-900'}`}>
              RADAR RADIUS:
            </span>
            <span className="px-2 py-0.5 rounded bg-[#0096C7] text-white font-mono font-bold text-xs shadow-sm">
              {activeRadius} MILES
            </span>
          </div>

          <div className="flex items-center gap-1.5">
            {[1, 5, 15, 25, 50, 100].map(mi => (
              <button
                key={mi}
                onClick={() => handleRadiusChange(mi)}
                className={`px-2 py-0.5 rounded text-[10px] font-mono font-bold transition ${
                  activeRadius === mi
                    ? 'bg-[#0096C7] text-white shadow-sm'
                    : isDarkMode
                    ? 'bg-[#16192B] border border-[#2C324A] text-white/60 hover:text-white'
                    : 'bg-white border border-slate-200 text-slate-700 hover:bg-slate-100'
                }`}
                title={`Set search radius to ${mi} miles`}
              >
                {mi}m
              </button>
            ))}
            <input
              type="range"
              min="1"
              max="100"
              value={activeRadius}
              onChange={e => handleRadiusChange(parseInt(e.target.value))}
              className="w-20 sm:w-28 h-1.5 rounded-lg appearance-none cursor-pointer accent-[#0096C7] bg-[#2C324A]"
            />
          </div>

          <label className={`flex items-center gap-1.5 text-[11px] font-mono cursor-pointer select-none ${
            isDarkMode ? 'text-white/70' : 'text-slate-600'
          }`}>
            <input
              type="checkbox"
              checked={filterAllByRadius}
              onChange={e => setFilterAllByRadius(e.target.checked)}
              className="rounded accent-[#0096C7]"
            />
            <span>Perimeter Filter ({inPerimeterCount} in range)</span>
          </label>
        </div>

        {/* 15-Second Idle Rotation Timer Indicator Badge */}
        <div className="flex items-center gap-2">
          {secondsRemaining > 0 ? (
            <div className="flex items-center gap-1.5 px-2.5 py-1 rounded-lg bg-amber-500/15 border border-amber-500/30 text-amber-400 font-mono text-[10px] font-bold shadow-sm">
              <Clock className="w-3.5 h-3.5 animate-spin" />
              <span>ROTATION PAUSED ({secondsRemaining}s REMAINING)</span>
            </div>
          ) : (
            <div className="flex items-center gap-1.5 px-2.5 py-1 rounded-lg bg-[#00FF88]/15 border border-[#00FF88]/30 text-[#00FF88] font-mono text-[10px] font-bold shadow-sm">
              <RotateCw className="w-3.5 h-3.5" />
              <span>AUTO-ORBIT ENGAGED</span>
            </div>
          )}
        </div>
      </div>

      {/* 2. Interactive Canvas Container */}
      <div
        className="cursor-grab active:cursor-grabbing relative h-[440px] sm:h-[520px] w-full flex items-center justify-center overflow-hidden touch-none"
        onMouseDown={handleMouseDown}
        onMouseMove={handleMouseMove}
        onMouseUp={handleMouseUp}
        onMouseLeave={handleMouseLeave}
        onTouchStart={handleTouchStart}
        onTouchMove={handleTouchMove}
        onTouchEnd={handleTouchEnd}
        onTouchCancel={handleTouchEnd}
      >
        <canvas
          ref={canvasRef}
          width={840}
          height={520}
          className="w-full h-full object-contain pointer-events-none"
        />

        {/* Target Lock Toast Notification */}
        {toastMessage && (
          <div className="absolute top-14 left-1/2 -translate-x-1/2 bg-[#080B15]/95 border border-[#00FF88] text-[#00FF88] px-4 py-2 rounded-xl shadow-[0_0_20px_rgba(0,255,136,0.35)] text-xs font-mono font-bold flex items-center gap-2 z-30 animate-in fade-in slide-in-from-top duration-200">
            <CheckCircle2 className="w-4 h-4 text-[#00FF88]" />
            <span>{toastMessage}</span>
          </div>
        )}

        {/* Floating Quick Camera Controls */}
        <div className="absolute top-3 right-3 flex flex-col gap-1.5 z-20">
          <button
            onClick={() => setZoom(z => Math.min(26.0, z * 1.35))}
            className="p-2 rounded-lg bg-[#121629]/90 border border-[#2C324A] text-white hover:border-[#00FFFF] transition shadow-md"
            title="Zoom In"
          >
            <ZoomIn className="w-4 h-4" />
          </button>
          <button
            onClick={() => setZoom(z => Math.max(0.4, z / 1.35))}
            className="p-2 rounded-lg bg-[#121629]/90 border border-[#2C324A] text-white hover:border-[#00FFFF] transition shadow-md"
            title="Zoom Out"
          >
            <ZoomOut className="w-4 h-4" />
          </button>
          <button
            onClick={recenterMyClub}
            className="p-2 rounded-lg bg-[#121629]/95 border border-[#00FF88] text-[#00FF88] hover:bg-[#00FF88]/20 transition shadow-[0_0_12px_rgba(0,255,136,0.3)]"
            title="Recenter on My Club (Street Level)"
          >
            <Navigation className="w-4 h-4 text-[#00FF88]" />
          </button>
          <button
            onClick={() => {
              setYaw(-BASE_LNG * (Math.PI / 180));
              setPitch(BASE_LAT * (Math.PI / 180));
              setZoom(0.85);
            }}
            className="p-2 rounded-lg bg-[#121629]/90 border border-[#2C324A] text-white hover:border-[#D4AF37] transition shadow-md"
            title="View Entire Globe (Orbital)"
          >
            <RotateCcw className="w-4 h-4 text-[#D4AF37]" />
          </button>
        </div>

        {/* Zoom Scale Preset Chips & Recenter Action */}
        <div className="absolute top-3 left-3 flex flex-wrap gap-1.5 z-20">
          <button
            onClick={recenterMyClub}
            className="px-2.5 py-1 rounded-lg text-[10px] font-mono font-bold transition border bg-[#00FF88]/20 border-[#00FF88] text-[#00FF88] hover:bg-[#00FF88]/30 flex items-center gap-1 shadow-[0_0_10px_rgba(0,255,136,0.3)]"
            title="Recenter Camera on My Club HQ"
          >
            <Navigation className="w-3 h-3 text-[#00FF88]" />
            <span>RECENTER MY CLUB</span>
          </button>
          <button
            onClick={() => setZoomLevel(0.85)}
            className={`px-2.5 py-1 rounded-lg text-[10px] font-mono font-bold transition border ${
              zoom < 1.5
                ? 'bg-[#0096C7] text-white border-[#0096C7] shadow-[0_0_10px_rgba(0,150,199,0.5)]'
                : 'bg-[#121629]/80 border-[#2C324A] text-white/60 hover:text-white'
            }`}
          >
            ORBIT / SATELLITES
          </button>
          <button
            onClick={() => setZoomLevel(3.2, BASE_LAT, BASE_LNG)}
            className={`px-2.5 py-1 rounded-lg text-[10px] font-mono font-bold transition border ${
              zoom >= 1.5 && zoom < 6.0
                ? 'bg-[#0096C7] text-white border-[#0096C7] shadow-[0_0_10px_rgba(0,150,199,0.5)]'
                : 'bg-[#121629]/80 border-[#2C324A] text-white/60 hover:text-white'
            }`}
          >
            CONTINENTAL
          </button>
          <button
            onClick={() => setZoomLevel(9.0, BASE_LAT, BASE_LNG)}
            className={`px-2.5 py-1 rounded-lg text-[10px] font-mono font-bold transition border ${
              zoom >= 6.0 && zoom < 14.0
                ? 'bg-[#0096C7] text-white border-[#0096C7] shadow-[0_0_10px_rgba(0,150,199,0.5)]'
                : 'bg-[#121629]/80 border-[#2C324A] text-white/60 hover:text-white'
            }`}
          >
            CITY SECTOR
          </button>
          <button
            onClick={() => setZoomLevel(18.0, BASE_LAT, BASE_LNG)}
            className={`px-2.5 py-1 rounded-lg text-[10px] font-mono font-bold transition border ${
              zoom >= 14.0
                ? 'bg-[#00FF88] text-[#080B15] border-[#00FF88] shadow-[0_0_12px_rgba(0,255,136,0.6)]'
                : 'bg-[#121629]/80 border-[#2C324A] text-white/60 hover:text-white'
            }`}
          >
            STREET LEVEL
          </button>
        </div>

        {/* Layer Visibility Toggles (Bottom Left) */}
        <div className="absolute bottom-3 left-3 flex flex-wrap gap-1 z-20 bg-[#121629]/90 p-1.5 rounded-xl border border-[#2C324A] backdrop-blur-md">
          <button
            onClick={() => setShowFriends(f => !f)}
            className={`px-2 py-0.5 rounded text-[9px] font-mono font-bold transition flex items-center gap-1 ${
              showFriends
                ? 'bg-[#00FF88]/20 text-[#00FF88] border border-[#00FF88]/30'
                : 'text-white/40 hover:text-white'
            }`}
          >
            <Users className="w-2.5 h-2.5" /> Friends
          </button>

          <button
            onClick={() => setShowOtherClubs(c => !c)}
            className={`px-2 py-0.5 rounded text-[9px] font-mono font-bold transition flex items-center gap-1 ${
              showOtherClubs
                ? 'bg-[#D4AF37]/20 text-[#D4AF37] border border-[#D4AF37]/30'
                : 'text-white/40 hover:text-white'
            }`}
          >
            <Shield className="w-2.5 h-2.5" /> Other Clubs
          </button>

          <button
            onClick={() => setShowSatellites(s => !s)}
            className={`px-2 py-0.5 rounded text-[9px] font-mono font-bold transition flex items-center gap-1 ${
              showSatellites
                ? 'bg-[#00FFFF]/20 text-[#00FFFF] border border-[#00FFFF]/30'
                : 'text-white/40 hover:text-white'
            }`}
          >
            <Satellite className="w-2.5 h-2.5" /> Satellites
          </button>

          <button
            onClick={() => setShowTasks(t => !t)}
            className={`px-2 py-0.5 rounded text-[9px] font-mono font-bold transition flex items-center gap-1 ${
              showTasks
                ? 'bg-[#FF6B35]/20 text-[#FF6B35] border border-[#FF6B35]/30'
                : 'text-white/40 hover:text-white'
            }`}
          >
            <Coins className="w-2.5 h-2.5" /> Bounties
          </button>

          <button
            onClick={() => setShowEvents(e => !e)}
            className={`px-2 py-0.5 rounded text-[9px] font-mono font-bold transition flex items-center gap-1 ${
              showEvents
                ? 'bg-[#B185FF]/20 text-[#B185FF] border border-[#B185FF]/40'
                : 'text-white/40 hover:text-white'
            }`}
          >
            <Calendar className="w-2.5 h-2.5" /> Events
          </button>

          <button
            onClick={() => setShowComparisonRays(r => !r)}
            className={`px-2 py-0.5 rounded text-[9px] font-mono font-bold transition flex items-center gap-1 ${
              showComparisonRays
                ? 'bg-[#5300FF]/20 text-[#B185FF] border border-[#5300FF]/40'
                : 'text-white/40 hover:text-white'
            }`}
          >
            <Share2 className="w-2.5 h-2.5" /> Vectors
          </button>
        </div>

        {/* Hover Tooltip when not clicked */}
        {hoveredMarker && !selectedMarker && (
          <div className="absolute top-14 right-3 bg-[#121629]/95 border border-[#00FFFF] p-2.5 rounded-xl shadow-2xl max-w-[240px] pointer-events-none z-30 animate-in fade-in duration-150">
            <div className="flex items-center gap-1.5">
              <span 
                className="w-2 h-2 rounded-full" 
                style={{ backgroundColor: hoveredMarker.color }} 
              />
              <span className="text-xs font-bold text-white font-display truncate">
                {hoveredMarker.name}
              </span>
            </div>
            <div className="text-[10px] font-mono text-[#00FFFF] mt-0.5">
              {hoveredMarker.streetAddress}
            </div>
            {hoveredMarker.type !== 'my_club' && (
              <div className="text-[10px] font-mono text-[#D4AF37] mt-1 font-bold">
                DIST TO MY CLUB: {getDistanceKm(BASE_LAT, BASE_LNG, hoveredMarker.lat, hoveredMarker.lng).toFixed(1)} km
              </div>
            )}
            <div className="text-[9px] font-mono text-white/50 mt-1">
              Click marker for complete tactical dossier
            </div>
          </div>
        )}
      </div>

      {/* 3. Relative Comparison Drawer (Comparing other clubs & friends to Mine) */}
      {showComparisonDrawer && (
        <div className={`p-4 border-t transition-colors ${
          isDarkMode ? 'bg-[#0E1326] border-[#2C324A]' : 'bg-slate-50 border-slate-200'
        } animate-in slide-in-from-bottom duration-200`}>
          <div className="flex items-center justify-between mb-3">
            <div className="flex items-center gap-2">
              <Layers className="w-4 h-4 text-[#D4AF37]" />
              <h4 className={`text-xs font-mono font-bold uppercase tracking-wider ${isDarkMode ? 'text-white' : 'text-slate-900'}`}>
                TACTICAL COMPARISON RELATIVE TO MY CLUB [{myClubData.name.toUpperCase()}]
              </h4>
            </div>
            <button
              onClick={() => setShowComparisonDrawer(false)}
              className={isDarkMode ? 'p-1 rounded text-white/40 hover:text-white' : 'p-1 rounded text-slate-400 hover:text-slate-700'}
            >
              <X className="w-4 h-4" />
            </button>
          </div>

          <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 gap-2.5 max-h-[220px] overflow-y-auto pr-1">
            {comparisonList.map(({ marker, distKm, distMi, bearing, cardinal }) => {
              const isSelected = selectedMarker?.id === marker.id;
              const isChattable = marker.type === 'friend' || marker.type === 'other_club';

              return (
                <div
                  key={marker.id}
                  onClick={() => focusOnMarker(marker)}
                  className={`p-2.5 rounded-xl border transition cursor-pointer flex flex-col justify-between ${
                    isSelected
                      ? isDarkMode
                        ? 'bg-[#16192B] border-[#00FFFF] shadow-[0_0_12px_rgba(0,255,255,0.2)]'
                        : 'bg-blue-50 border-[#0096C7] shadow-sm'
                      : isDarkMode
                      ? 'bg-[#121629] border-[#2C324A] hover:border-white/50'
                      : 'bg-white border-slate-200 hover:border-slate-400 shadow-sm'
                  }`}
                >
                  <div className="flex items-start justify-between gap-2">
                    <div className="flex items-center gap-2 min-w-0">
                      <span 
                        className="w-2.5 h-2.5 rounded-full shrink-0" 
                        style={{ backgroundColor: marker.color }} 
                      />
                      <span className={`text-xs font-bold truncate ${isDarkMode ? 'text-white' : 'text-slate-900'}`}>
                        {marker.name}
                      </span>
                    </div>

                    <div className="flex items-center gap-1.5 shrink-0">
                      {isChattable && (
                        <button
                          onClick={(e) => {
                            e.stopPropagation();
                            if (marker.type === 'friend') {
                              openComms('direct', { id: marker.id, name: marker.friendCallsign || marker.name, type: 'friend', color: marker.color });
                            } else {
                              openComms('team', { id: marker.clubId || marker.id, name: marker.name, type: 'team', color: marker.color });
                            }
                            if (onOpenComms) onOpenComms();
                          }}
                          className={`p-1 rounded-md border text-[10px] font-mono font-bold flex items-center gap-1 transition ${
                            marker.type === 'friend'
                              ? 'bg-[#00FF88]/20 border-[#00FF88] text-[#00FF88] hover:bg-[#00FF88]/30'
                              : 'bg-[#0096C7]/20 border-[#0096C7] text-[#4DBBDF] hover:bg-[#0096C7]/30'
                          }`}
                          title={`Chat with ${marker.name}`}
                        >
                          <MessageSquare className="w-3 h-3" />
                          <span>Chat</span>
                        </button>
                      )}
                      <span className={`text-[9px] font-mono uppercase px-1.5 py-0.5 rounded ${
                        isDarkMode ? 'bg-white/5 text-white/60' : 'bg-slate-100 text-slate-600'
                      }`}>
                        {marker.type.replace('_', ' ')}
                      </span>
                    </div>
                  </div>

                  <div className={`mt-2 pt-2 border-t grid grid-cols-2 gap-2 text-[10px] font-mono ${
                    isDarkMode ? 'border-[#2C324A]' : 'border-slate-100'
                  }`}>
                    <div>
                      <span className={isDarkMode ? 'text-white/40 block' : 'text-slate-400 block'}>DISTANCE:</span>
                      <strong className="text-[#0096C7]">{distKm.toFixed(1)} km</strong>
                      <span className={`text-[9px] ml-1 ${isDarkMode ? 'text-white/50' : 'text-slate-500'}`}>({distMi.toFixed(1)} mi)</span>
                    </div>
                    <div>
                      <span className={isDarkMode ? 'text-white/40 block' : 'text-slate-400 block'}>BEARING:</span>
                      <strong className="text-[#D4AF37]">{bearing.toFixed(0)}° {cardinal}</strong>
                    </div>
                  </div>
                </div>
              );
            })}
          </div>
        </div>
      )}

      {/* 4. Complete Information Dossier Panel for Selected Marker */}
      {selectedMarker && (
        <div className={`p-4 sm:p-5 border-t transition-colors ${
          isDarkMode ? 'bg-[#121629] border-[#00FFFF]/50' : 'bg-white border-slate-200 shadow-xl'
        } animate-in slide-in-from-bottom duration-200`}>
          <div className="flex items-start justify-between gap-4">
            <div className="flex items-center gap-3">
              <div
                className="w-12 h-12 rounded-xl flex items-center justify-center border shadow-lg"
                style={{
                  backgroundColor: `${selectedMarker.color}20`,
                  borderColor: selectedMarker.color,
                }}
              >
                {selectedMarker.type === 'my_club' || selectedMarker.type === 'other_club' ? (
                  <Shield className="w-6 h-6" style={{ color: selectedMarker.color }} />
                ) : selectedMarker.type === 'friend' ? (
                  <Users className="w-6 h-6 text-[#00FF88]" />
                ) : selectedMarker.type === 'satellite' ? (
                  <Satellite className="w-6 h-6 text-[#00FFFF]" />
                ) : selectedMarker.type === 'obd_vehicle' ? (
                  <Gauge className="w-6 h-6 text-[#00FF88]" />
                ) : (
                  <Coins className="w-6 h-6 text-[#D4AF37]" />
                )}
              </div>

              <div>
                <div className="flex items-center gap-2">
                  <h3 className={`text-base font-display font-bold ${isDarkMode ? 'text-white' : 'text-slate-900'}`}>
                    {selectedMarker.name}
                  </h3>
                  <span className="text-[10px] font-mono px-2 py-0.5 rounded uppercase font-semibold border"
                    style={{
                      backgroundColor: `${selectedMarker.color}15`,
                      color: selectedMarker.color,
                      borderColor: `${selectedMarker.color}40`,
                    }}
                  >
                    {selectedMarker.type.replace('_', ' ')}
                  </span>
                </div>
                <div className={`text-xs font-mono mt-0.5 ${isDarkMode ? 'text-white/60' : 'text-slate-500'}`}>
                  {selectedMarker.streetAddress}
                </div>
              </div>
            </div>

            <div className="flex items-center gap-2">
              <button
                onClick={() => focusOnMarker(selectedMarker)}
                className={`p-1.5 rounded-lg border transition text-xs font-mono flex items-center gap-1 ${
                  isDarkMode ? 'bg-[#16192B] text-[#00FFFF] hover:border-[#00FFFF] border-[#2C324A]' : 'bg-slate-100 text-blue-600 hover:border-blue-400 border-slate-300'
                }`}
                title="Target & Focus"
              >
                <ArrowUpRight className="w-4 h-4" />
                <span>Focus</span>
              </button>
              <button
                onClick={() => setSelectedMarker(null)}
                className={`p-1.5 rounded-lg border transition ${
                  isDarkMode ? 'bg-[#16192B] text-white/50 hover:text-white border-[#2C324A]' : 'bg-slate-100 text-slate-500 hover:text-slate-800 border-slate-300'
                }`}
              >
                <X className="w-4 h-4" />
              </button>
            </div>
          </div>

          {/* Real-time Comparison Metrics to My Club */}
          {selectedMarker.type !== 'my_club' && (
            <div className="mt-3.5 p-3 rounded-xl bg-[#080B15] border border-[#D4AF37]/40 grid grid-cols-2 sm:grid-cols-4 gap-3 text-xs font-mono">
              <div>
                <span className="text-white/40 block text-[9px] uppercase">DISTANCE FROM MY CLUB</span>
                <span className="text-sm font-bold text-[#00FFFF]">
                  {getDistanceKm(BASE_LAT, BASE_LNG, selectedMarker.lat, selectedMarker.lng).toFixed(2)} km
                </span>
                <span className="text-white/50 text-[10px] ml-1">
                  ({(getDistanceKm(BASE_LAT, BASE_LNG, selectedMarker.lat, selectedMarker.lng) * 0.621371).toFixed(2)} mi)
                </span>
              </div>

              <div>
                <span className="text-white/40 block text-[9px] uppercase">COMPASS BEARING</span>
                <span className="text-sm font-bold text-[#D4AF37]">
                  {getBearingDeg(BASE_LAT, BASE_LNG, selectedMarker.lat, selectedMarker.lng).toFixed(0)}°{' '}
                  {getCardinal(getBearingDeg(BASE_LAT, BASE_LNG, selectedMarker.lat, selectedMarker.lng))}
                </span>
              </div>

              <div>
                <span className="text-white/40 block text-[9px] uppercase">TRANSIT TIME (DRIVE)</span>
                <span className="text-sm font-bold text-white">
                  {Math.max(
                    1,
                    Math.round(
                      (getDistanceKm(BASE_LAT, BASE_LNG, selectedMarker.lat, selectedMarker.lng) / 35) * 60
                    )
                  )}{' '}
                  min
                </span>
              </div>

              <div>
                <span className="text-white/40 block text-[9px] uppercase">ALTITUDE</span>
                <span className="text-sm font-bold text-[#00FF88]">
                  {selectedMarker.altitudeKm > 0
                    ? `${selectedMarker.altitudeKm.toLocaleString()} km`
                    : 'Ground Level'}
                </span>
              </div>
            </div>
          )}

          {/* Marker Specialized Detail Metrics */}
          <div className="grid grid-cols-2 sm:grid-cols-4 gap-2.5 mt-3 text-xs font-mono">
            {/* If Club */}
            {(selectedMarker.type === 'my_club' || selectedMarker.type === 'other_club') && (
              <>
                <div className="p-2.5 rounded-xl bg-[#16192B] border border-[#2C324A]">
                  <span className="text-[9px] text-white/40 uppercase block">MEMBERS ACTIVE</span>
                  <span className="text-sm font-bold text-white">
                    {selectedMarker.memberCount?.toLocaleString() || '1,420'}
                  </span>
                </div>
                <div className="p-2.5 rounded-xl bg-[#16192B] border border-[#2C324A]">
                  <span className="text-[9px] text-white/40 uppercase block">STAKED ESCROW</span>
                  <span className="text-sm font-bold text-[#D4AF37]">
                    {selectedMarker.stakedFlr?.toLocaleString() || '24,500'} FLR
                  </span>
                </div>
                <div className="p-2.5 rounded-xl bg-[#16192B] border border-[#2C324A]">
                  <span className="text-[9px] text-white/40 uppercase block">SECTOR ZONE</span>
                  <span className="text-xs font-bold text-[#00FFFF] truncate block">
                    {selectedMarker.sectorId}
                  </span>
                </div>
                <div className="p-2.5 rounded-xl bg-[#16192B] border border-[#2C324A]">
                  <span className="text-[9px] text-white/40 uppercase block">DIPLOMATIC STATUS</span>
                  <span className="text-xs font-bold text-[#00FF88]">
                    {selectedMarker.type === 'my_club' ? 'HEADQUARTERS' : 'ALLIED TREATY'}
                  </span>
                </div>
              </>
            )}

            {/* If Friend */}
            {selectedMarker.type === 'friend' && (
              <>
                <div className="p-2.5 rounded-xl bg-[#16192B] border border-[#2C324A]">
                  <span className="text-[9px] text-white/40 uppercase block">CALLSIGN</span>
                  <span className="text-sm font-bold text-[#00FFFF]">{selectedMarker.friendCallsign}</span>
                </div>
                <div className="p-2.5 rounded-xl bg-[#16192B] border border-[#2C324A]">
                  <span className="text-[9px] text-white/40 uppercase block">PATROL VELOCITY</span>
                  <span className="text-sm font-bold text-white">{selectedMarker.velocityMph} MPH</span>
                </div>
                <div className="p-2.5 rounded-xl bg-[#16192B] border border-[#2C324A]">
                  <span className="text-[9px] text-white/40 uppercase block">BATTERY & HEALTH</span>
                  <span className="text-sm font-bold text-[#00FF88]">
                    {selectedMarker.batteryPercent}% / {selectedMarker.healthPercent}%
                  </span>
                </div>
                <div className="p-2.5 rounded-xl bg-[#16192B] border border-[#2C324A]">
                  <span className="text-[9px] text-white/40 uppercase block">RADIO FREQ</span>
                  <span className="text-sm font-bold text-[#D4AF37]">{selectedMarker.radioFrequency}</span>
                </div>
              </>
            )}

            {/* If Satellite */}
            {selectedMarker.type === 'satellite' && (
              <>
                <div className="p-2.5 rounded-xl bg-[#16192B] border border-[#2C324A]">
                  <span className="text-[9px] text-white/40 uppercase block">ORBITAL PERIOD</span>
                  <span className="text-sm font-bold text-white">{selectedMarker.orbitPeriodMin} min</span>
                </div>
                <div className="p-2.5 rounded-xl bg-[#16192B] border border-[#2C324A]">
                  <span className="text-[9px] text-white/40 uppercase block">INCLINATION</span>
                  <span className="text-sm font-bold text-[#00FFFF]">{selectedMarker.orbitInclinationDeg}°</span>
                </div>
                <div className="p-2.5 rounded-xl bg-[#16192B] border border-[#2C324A]">
                  <span className="text-[9px] text-white/40 uppercase block">PAYLOAD</span>
                  <span className="text-xs font-bold text-white truncate block">{selectedMarker.sensorPayload}</span>
                </div>
                <div className="p-2.5 rounded-xl bg-[#16192B] border border-[#2C324A]">
                  <span className="text-[9px] text-white/40 uppercase block">DOWNLINK LINK</span>
                  <span className="text-xs font-bold text-[#D4AF37] truncate block">{selectedMarker.downlinkBandwidth}</span>
                </div>
              </>
            )}

            {/* If Task Bounty */}
            {selectedMarker.type === 'task' && (
              <>
                <div className="p-2.5 rounded-xl bg-[#16192B] border border-[#2C324A]">
                  <span className="text-[9px] text-white/40 uppercase block">REWARD BOUNTY</span>
                  <span className="text-sm font-bold text-[#00FF88]">
                    ${selectedMarker.bountyUsd} + {selectedMarker.bountyFlr} FLR
                  </span>
                </div>
                <div className="p-2.5 rounded-xl bg-[#16192B] border border-[#2C324A]">
                  <span className="text-[9px] text-white/40 uppercase block">CATEGORY</span>
                  <span className="text-xs font-bold text-white">{selectedMarker.taskCategory}</span>
                </div>
                <div className="p-2.5 rounded-xl bg-[#16192B] border border-[#2C324A]">
                  <span className="text-[9px] text-white/40 uppercase block">ESCROW STATUS</span>
                  <span className="text-xs font-bold text-[#D4AF37]">LOCKED IN FLR LEDGER</span>
                </div>
                <div className="p-2.5 rounded-xl bg-[#16192B] border border-[#2C324A]">
                  <span className="text-[9px] text-white/40 uppercase block">VERIFICATION</span>
                  <span className="text-xs font-bold text-[#00FFFF]">GPS + PHOTO PROOF</span>
                </div>
              </>
            )}

            {/* If Event */}
            {selectedMarker.type === 'event' && (
              <>
                <div className="p-2.5 rounded-xl bg-[#16192B] border border-[#2C324A]">
                  <span className="text-[9px] text-white/40 uppercase block">DATE & TIME</span>
                  <span className="text-xs font-bold text-white block">
                    {selectedMarker.eventDate} @ {selectedMarker.eventTime}
                  </span>
                </div>
                <div className="p-2.5 rounded-xl bg-[#16192B] border border-[#2C324A]">
                  <span className="text-[9px] text-white/40 uppercase block">ATTENDEES</span>
                  <span className="text-sm font-bold text-[#00FFFF]">
                    {selectedMarker.eventAttendees} Operators
                  </span>
                </div>
                <div className="p-2.5 rounded-xl bg-[#16192B] border border-[#2C324A]">
                  <span className="text-[9px] text-white/40 uppercase block">ATTENDANCE REWARD</span>
                  <span className="text-sm font-bold text-[#D4AF37]">
                    +{selectedMarker.bountyFlr || 35} FLR
                  </span>
                </div>
                <div className="p-2.5 rounded-xl bg-[#16192B] border border-[#2C324A]">
                  <span className="text-[9px] text-white/40 uppercase block">SECTOR EVENT</span>
                  <span className="text-xs font-bold text-[#B185FF] truncate block">
                    {selectedMarker.sectorId}
                  </span>
                </div>
              </>
            )}
          </div>

          {/* Cryptographic DID */}
          {selectedMarker.did && (
            <div className="mt-3 p-2.5 rounded-xl bg-[#080B15] border border-[#2C324A] flex items-center justify-between gap-3 text-xs font-mono">
              <div className="truncate">
                <span className="text-white/40 mr-2">DECENTRALIZED ID:</span>
                <span className="text-white font-bold">{selectedMarker.did}</span>
              </div>
              <span className="text-[10px] text-[#00FF88] flex items-center gap-1 shrink-0">
                <CheckCircle2 className="w-3 h-3" /> VERIFIED ED25519
              </span>
            </div>
          )}

          {/* Context Actions */}
          <div className="flex flex-wrap items-center gap-2 mt-3.5">
            {selectedMarker.type === 'friend' && (
              <button
                onClick={() => {
                  openComms('direct', {
                    id: selectedMarker.id,
                    name: selectedMarker.friendCallsign || selectedMarker.name,
                    type: 'friend',
                    color: selectedMarker.color,
                  });
                  if (onOpenComms) onOpenComms();
                }}
                className="px-3.5 py-2 rounded-xl bg-[#00FF88]/20 border border-[#00FF88] text-[#00FF88] hover:bg-[#00FF88]/30 text-xs font-mono font-bold flex items-center gap-1.5 transition shadow-[0_0_15px_rgba(0,255,136,0.35)]"
              >
                <MessageSquare className="w-3.5 h-3.5" />
                <span>CHAT WITH {selectedMarker.friendCallsign || selectedMarker.name}</span>
              </button>
            )}

            {(selectedMarker.type === 'other_club' || selectedMarker.type === 'my_club') && (
              <button
                onClick={() => {
                  openComms('team', {
                    id: selectedMarker.clubId || selectedMarker.id,
                    name: selectedMarker.name,
                    type: 'team',
                    color: selectedMarker.color,
                  });
                  if (onOpenComms) onOpenComms();
                }}
                className="px-3.5 py-2 rounded-xl bg-[#0096C7]/20 border border-[#0096C7] text-[#4DBBDF] hover:bg-[#0096C7]/30 text-xs font-mono font-bold flex items-center gap-1.5 transition shadow-[0_0_15px_rgba(0,150,199,0.35)]"
              >
                <MessageSquare className="w-3.5 h-3.5" />
                <span>OPEN GUILD CHAT</span>
              </button>
            )}

            {selectedMarker.type === 'other_club' && (
              <>
                <button
                  onClick={() => {
                    declareWar(selectedMarker.clubId || 'fire', 'Territorial contestation initiated via Globe.');
                    if (onOpenWars) onOpenWars();
                  }}
                  className="px-3.5 py-2 rounded-xl bg-[#E74C3C]/20 border border-[#E74C3C] text-[#FF8E82] hover:bg-[#E74C3C]/30 text-xs font-mono font-bold flex items-center gap-1.5 transition"
                >
                  <Swords className="w-3.5 h-3.5" />
                  <span>DECLARE WAR / CONTEST</span>
                </button>

                {onOpenTeams && (
                  <button
                    onClick={onOpenTeams}
                    className={`px-3.5 py-2 rounded-xl border text-xs font-mono font-bold flex items-center gap-1.5 transition ${
                      isDarkMode ? 'bg-[#16192B] border-[#2C324A] text-white/80 hover:text-white' : 'bg-slate-100 border-slate-300 text-slate-700 hover:bg-slate-200'
                    }`}
                  >
                    <Users className="w-3.5 h-3.5" />
                    <span>VIEW GUILD DOSSIER</span>
                  </button>
                )}
              </>
            )}

            {selectedMarker.type === 'obd_vehicle' && onOpenObd && (
              <button
                onClick={onOpenObd}
                className="px-3.5 py-2 rounded-xl bg-[#00FF88]/20 border border-[#00FF88] text-[#00FF88] hover:bg-[#00FF88]/30 text-xs font-mono font-bold flex items-center gap-1.5 transition"
              >
                <Gauge className="w-3.5 h-3.5" />
                <span>OPEN OBD-II TELEMETRY</span>
              </button>
            )}

            <button
              onClick={() => {
                setZoomLevel(18.0, selectedMarker.lat, selectedMarker.lng);
              }}
              className="px-3.5 py-2 rounded-xl bg-[#0096C7]/20 border border-[#0096C7] text-[#4DBBDF] hover:bg-[#0096C7]/30 text-xs font-mono font-bold flex items-center gap-1.5 transition ml-auto"
            >
              <Navigation className="w-3.5 h-3.5" />
              <span>ZOOM TO STREET LEVEL</span>
            </button>
          </div>
        </div>
      )}
    </div>
  );
};
