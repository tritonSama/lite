import React, { createContext, useContext, useState, useEffect } from 'react';
import {
  Task,
  Offer,
  Team,
  TeamWar,
  UserProfile,
  CommsMessage,
  CommsChannel,
  NotificationItem,
  ObdState,
  GuildEvent,
  SquadFriend,
} from '../types';
import { NetworkEvent, EscrowTransaction, ProofOfHealthTelemetry } from '../core/tithex/networkEvent';
import { MobileVaultSdk } from '../core/tithex/vaultSdk';
import { FluoridianService } from '../core/tithex/fluoridianService';
import { TitheXEscrowLedger } from '../core/tithex/escrowLedger';
import { ProofOfHealthDaemon } from '../core/tithex/proofOfHealth';

export interface CommsRecipient {
  id: string;
  name: string;
  type: 'friend' | 'team';
  color?: string;
  callsign?: string;
}

interface AppContextType {
  // User & Vault
  currentUser: UserProfile;
  userDid: string;
  updateUserProfile: (updates: Partial<UserProfile>) => void;
  selectedTeamId: string | null;
  selectTeam: (teamId: string) => void;

  // Tasks
  tasks: Task[];
  createTask: (task: Omit<Task, 'id' | 'createdAt' | 'updatedAt' | 'bidCount'>) => Task;
  updateTask: (id: string, updates: Partial<Task>) => void;
  getTaskById: (id: string) => Task | undefined;

  // Events
  events: GuildEvent[];
  createEvent: (eventData: Omit<GuildEvent, 'id' | 'createdAt' | 'attendeesCount' | 'isRsvp'>) => GuildEvent;
  toggleRsvp: (eventId: string) => void;

  // Offers / Bids
  offers: Offer[];
  createOffer: (taskId: string, amount: number, message?: string) => void;
  updateOfferStatus: (offerId: string, status: Offer['status']) => void;

  // Teams & Wars
  teams: Team[];
  friends: SquadFriend[];
  wars: TeamWar[];
  declareWar: (defenderTeamId: string, message?: string) => void;
  recordWarVictory: (warId: string, winnerTeamId: string) => void;

  // Comms
  messages: CommsMessage[];
  sendMessage: (
    content: string, 
    channel: CommsChannel, 
    isRadioPtt?: boolean,
    recipientId?: string,
    recipientName?: string
  ) => void;
  isCommsOpen: boolean;
  commsTargetChannel: CommsChannel;
  commsTargetRecipient: CommsRecipient | null;
  openComms: (channel?: CommsChannel, recipient?: CommsRecipient | null) => void;
  closeComms: () => void;

  // Notifications
  notifications: NotificationItem[];
  markNotificationAsRead: (id: string) => void;
  clearNotifications: () => void;

  // Nexus Waitlist & PoH Daemon
  isOnWaitlist: boolean;
  joinWaitlist: (name: string, email: string) => Promise<void>;
  pohTelemetry: ProofOfHealthTelemetry;
  isPohDaemonActive: boolean;
  togglePohDaemon: () => void;

  // TitheX & Fluoridian Protocol Services
  peerCount: number;
  escrowTransactions: EscrowTransaction[];
  inspectedEnvelope: { event?: NetworkEvent; escrowTx?: EscrowTransaction } | null;
  inspectEnvelope: (event?: NetworkEvent, escrowTx?: EscrowTransaction) => void;
  closeEnvelopeInspector: () => void;

  // OBD2 Telemetry
  obdState: ObdState;
  connectObd: (macAddress: string) => void;
  disconnectObd: () => void;

  // Theme
  isDarkMode: boolean;
  toggleTheme: () => void;

  // Global search query
  searchQuery: string;
  setSearchQuery: (q: string) => void;
}

const AppContext = createContext<AppContextType | undefined>(undefined);

const INITIAL_TEAMS: Team[] = [
  {
    id: 'water',
    name: 'Water Clan',
    description: 'Specialists in coastal logistics, aquatic maintenance, and fluid intelligence ops.',
    ownerId: 'user_water_leader',
    memberCount: 1420,
    membersOnline: 124,
    icon: 'water_drop',
    color: '#0096C7', // Cyan
    credentialIds: ['cred_1', 'cred_2'],
    parentIds: ['org_oceanic'],
    sisterClubIds: ['wind'],
    treatyIds: ['earth'],
    rating: 4.9,
    completedJobCount: 382,
    createdAt: '2026-01-10T12:00:00Z',
  },
  {
    id: 'fire',
    name: 'Fire Tribe',
    description: 'Heavy welding, demolition, thermal infrastructure, and rapid kinetic response.',
    ownerId: 'user_fire_leader',
    memberCount: 980,
    membersOnline: 89,
    icon: 'local_fire_department',
    color: '#FF6B35', // Orange / Flame
    credentialIds: ['cred_3'],
    parentIds: ['org_vulcan'],
    sisterClubIds: [],
    treatyIds: [],
    rating: 4.8,
    completedJobCount: 295,
    createdAt: '2026-01-15T12:00:00Z',
  },
  {
    id: 'earth',
    name: 'Earth Guild',
    description: 'Structural foundations, landscaping, agriculture, and geological resource logistics.',
    ownerId: 'user_earth_leader',
    memberCount: 2150,
    membersOnline: 210,
    icon: 'eco',
    color: '#2EC4B6', // Emerald / Green
    credentialIds: ['cred_4', 'cred_5'],
    parentIds: ['org_terra'],
    sisterClubIds: ['water'],
    treatyIds: ['water'],
    rating: 4.95,
    completedJobCount: 512,
    createdAt: '2026-01-05T12:00:00Z',
  },
  {
    id: 'wind',
    name: 'Wind Order',
    description: 'Aerial telemetry, drone recon, distributed micro-grid comms, and swift transit.',
    ownerId: 'user_wind_leader',
    memberCount: 1310,
    membersOnline: 156,
    icon: 'air',
    color: '#70C1B3', // Sky / Cyan
    credentialIds: ['cred_6'],
    parentIds: ['org_zephyr'],
    sisterClubIds: ['water'],
    treatyIds: [],
    rating: 4.88,
    completedJobCount: 418,
    createdAt: '2026-01-20T12:00:00Z',
  },
];

const INITIAL_TASKS: Task[] = [
  {
    id: 'task-lot-cleanup',
    creatorId: 'water',
    creatorName: 'Water Clan Logistics',
    creatorTeamId: 'water',
    title: 'Clear Brush & Debris from Urban Lot',
    description: 'Approximately 2-3 hours of brush clearing and loading wood into haul trailer. Heavy gloves and steel toe boots recommended. Bounty escrow funded on Fluoridian chain.',
    photoUrls: ['https://images.unsplash.com/photo-1590856029826-c7a73142bbf1?w=600&auto=format&fit=crop&q=80'],
    locationLabel: 'Austin, TX (East Downtown)',
    lat: 30.2672,
    lng: -97.7431,
    desiredCompletionDate: '2026-10-15',
    budgetAmount: 180,
    currencyCode: 'USD',
    requiredSkills: ['General Labor', 'Hauling', 'Yard Care'],
    workerCount: 2,
    requireId: true,
    requireInsurance: false,
    status: 'published',
    bidCount: 3,
    category: 'Field Cleanup',
    listingType: 'forSale',
    createdAt: '2026-10-01T08:30:00Z',
    updatedAt: '2026-10-01T08:30:00Z',
  },
  {
    id: 'task-obd-fleet',
    creatorId: 'fire',
    creatorName: 'Fire Tribe Motorpool',
    creatorTeamId: 'fire',
    title: 'OBD2 Diagnostic & Sensor Replacement',
    description: 'Need certified auto technician to hook up CAN bus scanner, diagnose misfire on cylinder 3, and clear fuel trim fault codes on Ford Transit utility van.',
    photoUrls: ['https://images.unsplash.com/photo-1486006920555-c77dce18193b?w=600&auto=format&fit=crop&q=80'],
    locationLabel: 'Houston, TX (Industrial Corridor)',
    lat: 29.7604,
    lng: -95.3698,
    desiredCompletionDate: '2026-10-12',
    budgetAmount: 240,
    currencyCode: 'USD',
    requiredSkills: ['Automotive & OBD', 'Diagnostics', 'Electrical'],
    workerCount: 1,
    requireId: true,
    requireInsurance: true,
    status: 'bidding',
    bidCount: 5,
    category: 'Automotive & OBD',
    listingType: 'forSale',
    createdAt: '2026-10-01T10:15:00Z',
    updatedAt: '2026-10-01T10:15:00Z',
  },
  {
    id: 'task-event-rigging',
    creatorId: 'wind',
    creatorName: 'Wind Order Aerials',
    creatorTeamId: 'wind',
    title: 'Solar Array & High-Gain Antenna Mount',
    description: 'Assist in rigging a 400W folding solar array and omni-directional Nexus radio beacon on temporary rooftop mast for community mesh network.',
    photoUrls: ['https://images.unsplash.com/photo-1509391365360-2e959784a276?w=600&auto=format&fit=crop&q=80'],
    locationLabel: 'San Antonio, TX (Tech District)',
    lat: 29.4241,
    lng: -98.4936,
    desiredCompletionDate: '2026-10-18',
    budgetAmount: 320,
    currencyCode: 'USD',
    requiredSkills: ['Tech & Hardware', 'Solar Rigging', 'Climbing'],
    workerCount: 2,
    requireId: true,
    requireInsurance: true,
    status: 'published',
    bidCount: 2,
    category: 'Tech & Hardware',
    listingType: 'forSale',
    createdAt: '2026-10-02T14:00:00Z',
    updatedAt: '2026-10-02T14:00:00Z',
  },
  {
    id: 'task-tool-rental',
    creatorId: 'earth',
    creatorName: 'Earth Guild Equipment',
    creatorTeamId: 'earth',
    title: 'High-Torque Hydraulic Post Hole Digger',
    description: 'Available for rental: 2-man gas-powered earth auger with 8-inch and 12-inch bits. Fully serviced and ready for perimeter fencing projects.',
    photoUrls: ['https://images.unsplash.com/photo-1581092160607-ee22621dd758?w=600&auto=format&fit=crop&q=80'],
    locationLabel: 'Austin, TX (Warehouse Hub)',
    lat: 30.2900,
    lng: -97.7100,
    desiredCompletionDate: '2026-10-25',
    budgetAmount: 65,
    currencyCode: 'USD',
    requiredSkills: ['Equipment Operation'],
    workerCount: 1,
    requireId: true,
    requireInsurance: false,
    status: 'published',
    bidCount: 1,
    category: 'Home Improvement',
    listingType: 'forRent',
    rentalDuration: 'daily',
    createdAt: '2026-10-02T16:20:00Z',
    updatedAt: '2026-10-02T16:20:00Z',
  },
];

const INITIAL_OFFERS: Offer[] = [
  {
    id: 'bid-101',
    taskId: 'task-lot-cleanup',
    taskTitle: 'Clear Brush & Debris from Urban Lot',
    providerId: 'user_operator_1',
    providerName: 'Alex Mercer (Titan Crew)',
    providerRating: 4.9,
    amount: 170,
    message: 'We have a 16ft dump trailer and heavy-duty gas trimmers. Can finish within 2 hours Saturday morning.',
    proposedDate: '2026-10-15',
    status: 'pending',
    createdAt: '2026-10-02T09:00:00Z',
  },
  {
    id: 'bid-102',
    taskId: 'task-obd-fleet',
    taskTitle: 'OBD2 Diagnostic & Sensor Replacement',
    providerId: 'user_operator_me',
    providerName: 'Operator Joshua',
    providerRating: 4.95,
    amount: 220,
    message: 'Equipped with professional Autel CAN scanner and replacement Bosch O2 sensors in mobile rig.',
    proposedDate: '2026-10-12',
    status: 'pending',
    createdAt: '2026-10-02T11:20:00Z',
  },
];

const INITIAL_WARS: TeamWar[] = [
  {
    id: 'war-water-vs-fire',
    challengerTeamId: 'water',
    defenderTeamId: 'fire',
    challengerScore: 148,
    defenderScore: 132,
    status: 'active',
    declaredAt: Date.now() - 1000 * 60 * 60 * 24 * 2,
    message: 'Contesting territory rights across Sector 7 Industrial Corridor.',
  },
  {
    id: 'war-earth-vs-wind',
    challengerTeamId: 'earth',
    defenderTeamId: 'wind',
    challengerScore: 89,
    defenderScore: 94,
    status: 'active',
    declaredAt: Date.now() - 1000 * 60 * 60 * 12,
    message: 'Skirmish over drone landing easements at East Hub.',
  },
];

export const INITIAL_FRIENDS: SquadFriend[] = [
  {
    id: 'friend-titan-1',
    name: 'Titan-1',
    callsign: 'TITAN-1',
    role: 'Patrol Unit & Heavy Operator',
    status: 'patrol',
    lat: 30.2695,
    lng: -97.7415,
    street: '800 Congress Ave (Moving North)',
    freq: '144.390 MHz',
    battery: 84,
    health: 98,
    color: '#00FFFF',
    assignedTeamId: 'water',
    assignedTeamName: 'Water Clan',
    avatarUrl: 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=150&auto=format&fit=crop&q=80',
  },
  {
    id: 'friend-raven-7',
    name: 'Raven-7',
    callsign: 'RAVEN-7',
    role: 'Foot Scout & Urban Recon',
    status: 'online',
    lat: 30.2678,
    lng: -97.7380,
    street: '500 E 6th St (Historic District)',
    freq: '146.520 MHz',
    battery: 92,
    health: 100,
    color: '#4DBBDF',
    assignedTeamId: 'fire',
    assignedTeamName: 'Fire Tribe',
    avatarUrl: 'https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?w=150&auto=format&fit=crop&q=80',
  },
  {
    id: 'friend-echo-4',
    name: 'Echo-4',
    callsign: 'ECHO-4',
    role: 'Tactical Relay & Communications',
    status: 'online',
    lat: 30.2520,
    lng: -97.7510,
    street: '1200 S Congress Ave (SoCo Hub)',
    freq: '446.000 MHz',
    battery: 76,
    health: 95,
    color: '#00FF88',
    assignedTeamId: 'earth',
    assignedTeamName: 'Earth Guild',
    avatarUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150&auto=format&fit=crop&q=80',
  },
  {
    id: 'friend-ghost-2',
    name: 'Ghost-2',
    callsign: 'GHOST-2',
    role: 'Sky Recon Drone Operator',
    status: 'recon',
    lat: 30.2630,
    lng: -97.7470,
    street: 'Airspace over Lady Bird Lake',
    freq: '2.4 GHz Telemetry',
    battery: 68,
    health: 100,
    color: '#D4AF37',
    assignedTeamId: 'wind',
    assignedTeamName: 'Wind Order',
    avatarUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&auto=format&fit=crop&q=80',
  },
  {
    id: 'friend-cipher-9',
    name: 'Cipher-9',
    callsign: 'CIPHER-9',
    role: 'Mobile Node & Cryptographic Validator',
    status: 'standby',
    lat: 30.2760,
    lng: -97.7350,
    street: '15th & Red River (Medical District)',
    freq: '433.920 MHz',
    battery: 88,
    health: 96,
    color: '#5300FF',
    assignedTeamId: 'water',
    assignedTeamName: 'Water Clan',
    avatarUrl: 'https://images.unsplash.com/photo-1522075469751-3a6694fb2f61?w=150&auto=format&fit=crop&q=80',
  },
];

const INITIAL_MESSAGES: CommsMessage[] = [
  {
    id: 'msg-1',
    senderId: 'dispatcher_echo',
    senderName: 'HQ Dispatch',
    content: 'All units check in. GPS telemetry synchronizing with orbital layer.',
    channel: 'global',
    timestamp: '19:12',
  },
  {
    id: 'msg-2',
    senderId: 'me',
    senderName: 'Operator',
    content: 'Unit online and monitoring tactical VHF.',
    channel: 'global',
    timestamp: '19:14',
  },
  {
    id: 'msg-team-water',
    senderId: 'team_leader_water',
    senderName: 'Water Clan Command',
    content: 'Clan bounty pool has received 1,200 Fluoridian credits. Check open lot cleanups in Sector 7 Maritime.',
    channel: 'team',
    recipientId: 'water',
    recipientName: 'Water Clan',
    timestamp: '19:16',
  },
  {
    id: 'msg-team-fire',
    senderId: 'team_leader_fire',
    senderName: 'Fire Tribe Motorpool',
    content: 'All units: Vulcan Industrial Depot has OBD-II scanners ready for engine diagnostic contracts.',
    channel: 'team',
    recipientId: 'fire',
    recipientName: 'Fire Tribe',
    timestamp: '19:17',
  },
  {
    id: 'msg-team-earth',
    senderId: 'team_leader_earth',
    senderName: 'Earth Citadel Master',
    content: 'Capitol Foundry power nodes are 100% operational. Staking yields distributed.',
    channel: 'team',
    recipientId: 'earth',
    recipientName: 'Earth Guild',
    timestamp: '19:18',
  },
  {
    id: 'msg-team-wind',
    senderId: 'team_leader_wind',
    senderName: 'Wind Order Aerials',
    content: 'Frost Sky Spire repeaters are live on 462.6375 MHz. Drone air corridors clear.',
    channel: 'team',
    recipientId: 'wind',
    recipientName: 'Wind Order',
    timestamp: '19:19',
  },
  {
    id: 'msg-friend-titan-1',
    senderId: 'friend-titan-1',
    senderName: 'TITAN-1',
    content: 'Titan-1 patrol unit on station at 800 Congress Ave. Radar clear. Ready for squad task deployment.',
    channel: 'direct',
    recipientId: 'user_operator_me',
    recipientName: 'Operator Joshua',
    timestamp: '19:20',
  },
  {
    id: 'msg-friend-raven-7',
    senderId: 'friend-raven-7',
    senderName: 'RAVEN-7',
    content: 'Scout Raven-7 reporting in from 6th St district. 146.520 MHz link verified solid.',
    channel: 'direct',
    recipientId: 'user_operator_me',
    recipientName: 'Operator Joshua',
    timestamp: '19:21',
  },
  {
    id: 'msg-friend-echo-4',
    senderId: 'friend-echo-4',
    senderName: 'ECHO-4',
    content: 'Echo-4 relay node online at SoCo Hub. Cryptographic mesh relay active on 446.000 MHz.',
    channel: 'direct',
    recipientId: 'user_operator_me',
    recipientName: 'Operator Joshua',
    timestamp: '19:22',
  },
  {
    id: 'msg-friend-ghost-2',
    senderId: 'friend-ghost-2',
    senderName: 'GHOST-2',
    content: 'Ghost-2 drone airborne at 250m over Lady Bird Lake. Downlink locked at 2.4 GHz. Visual telemetry active.',
    channel: 'direct',
    recipientId: 'user_operator_me',
    recipientName: 'Operator Joshua',
    timestamp: '19:23',
  },
  {
    id: 'msg-friend-cipher-9',
    senderId: 'friend-cipher-9',
    senderName: 'CIPHER-9',
    content: 'Cipher-9 mobile validator node on standby in Medical District. Ed25519 signing keys primed.',
    channel: 'direct',
    recipientId: 'user_operator_me',
    recipientName: 'Operator Joshua',
    timestamp: '19:24',
  },
];

const INITIAL_NOTIFICATIONS: NotificationItem[] = [
  {
    id: 'notif-1',
    title: 'New Bid Received',
    message: 'Titan Crew submitted a $170 counteroffer on "Clear Brush & Debris".',
    type: 'bid',
    timestamp: '10m ago',
    read: false,
  },
  {
    id: 'notif-2',
    title: 'Guild War Update',
    message: 'Water Clan scored +16 points in Sector 7 contest against Fire Tribe.',
    type: 'war',
    timestamp: '1h ago',
    read: false,
  },
  {
    id: 'notif-3',
    title: 'Fluoridian Relay Synced',
    message: 'Ed25519 event envelope verified on P2P gossip cluster.',
    type: 'network',
    timestamp: '3h ago',
    read: true,
  },
];

const INITIAL_EVENTS: GuildEvent[] = [
  {
    id: 'event-maritime-rally',
    title: 'Lady Bird Lake Maritime Patrol & Float Rally',
    description: 'Fleet watercraft inspection, environmental sonar sweeping, and river cleanout operation with the Water Clan.',
    category: 'Field Operation',
    hostTeamId: 'water',
    hostName: 'Water Clan',
    date: '2026-10-14',
    time: '10:00',
    locationLabel: 'Lady Bird Harbor & Boardwalk (111 Cesar Chavez St)',
    lat: 30.2585,
    lng: -97.7490,
    attendeesCount: 42,
    maxCapacity: 100,
    rewardFlr: 50,
    rewardExp: 150,
    isRsvp: true,
    status: 'upcoming',
    createdAt: '2026-10-01T08:00:00Z',
  },
  {
    id: 'event-forge-meetup',
    title: 'East Side Cyberpunk Tactical Meetup & Gear Swap',
    description: 'Hardware modding, thermal diagnostics, and welder showcase at the Vulcan Industrial Forge.',
    category: 'Community Meetup',
    hostTeamId: 'fire',
    hostName: 'Fire Tribe',
    date: '2026-10-18',
    time: '18:30',
    locationLabel: 'Vulcan Industrial Forge Depot (901 E 5th St)',
    lat: 30.2640,
    lng: -97.7340,
    attendeesCount: 28,
    maxCapacity: 60,
    rewardFlr: 35,
    rewardExp: 100,
    isRsvp: false,
    status: 'upcoming',
    createdAt: '2026-10-01T09:30:00Z',
  },
  {
    id: 'event-solar-workshop',
    title: 'Capitol District Solar Node Deployment Workshop',
    description: 'Hands-on micro-inverter installation, battery bank wiring, and off-grid emergency power grid setup.',
    category: 'Tech Workshop',
    hostTeamId: 'earth',
    hostName: 'Earth Guild',
    date: '2026-10-22',
    time: '13:00',
    locationLabel: 'State Capitol Grounds & Foundry (1200 Lavaca St)',
    lat: 30.2740,
    lng: -97.7410,
    attendeesCount: 36,
    maxCapacity: 50,
    rewardFlr: 60,
    rewardExp: 200,
    isRsvp: false,
    status: 'upcoming',
    createdAt: '2026-10-02T11:00:00Z',
  },
  {
    id: 'event-drone-recon',
    title: 'Frost Tower Aerial Drone Navigation Trial',
    description: 'FPV drone obstacle course, RF range telemetry checks, and sky-mesh packet relay trials.',
    category: 'Guild Raid',
    hostTeamId: 'wind',
    hostName: 'Wind Order',
    date: '2026-10-25',
    time: '16:00',
    locationLabel: 'Frost Bank Sky Spire Observation (401 Congress Ave)',
    lat: 30.2688,
    lng: -97.7420,
    attendeesCount: 19,
    maxCapacity: 30,
    rewardFlr: 45,
    rewardExp: 120,
    isRsvp: false,
    status: 'upcoming',
    createdAt: '2026-10-02T14:15:00Z',
  },
];

export const AppProvider: React.FC<{ children: React.ReactNode }> = ({ children }) => {
  const [currentUser, setCurrentUser] = useState<UserProfile>(() => {
    const saved = localStorage.getItem('hb_user');
    if (saved) {
      try { return JSON.parse(saved); } catch (e) { /* ignore */ }
    }
    return {
      id: 'user_operator_me',
      displayName: 'Operator Joshua',
      email: 'joshua.henry@heavenlybond.org',
      photoURL: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200&auto=format&fit=crop&q=80',
      bio: 'Tactical field operative, certified automotive technician, and decentralized compute node host.',
      skills: ['Automotive & OBD', 'General Labor', 'Tech & Hardware', 'Escrow Verification'],
      rating: 4.95,
      completedJobsCount: 28,
      totalEarnings: 4250,
      joinedTeamId: 'water',
      credentials: [
        {
          id: 'c1',
          userId: 'user_operator_me',
          type: 'driversLicense',
          status: 'verified',
          issuer: 'Texas Dept of Public Safety',
          expirationDate: '2028-05-14',
        },
        {
          id: 'c2',
          userId: 'user_operator_me',
          type: 'insurance',
          status: 'verified',
          issuer: 'Liberty Commercial Mutual',
          expirationDate: '2027-01-01',
        },
        {
          id: 'c3',
          userId: 'user_operator_me',
          type: 'electricalLicense',
          status: 'underReview',
          issuer: 'State Licensing Board',
          expirationDate: '2026-12-31',
        },
      ],
    };
  });

  const [selectedTeamId, setSelectedTeamId] = useState<string | null>(currentUser.joinedTeamId || 'water');
  const [tasks, setTasks] = useState<Task[]>(() => {
    const saved = localStorage.getItem('hb_tasks');
    if (saved) {
      try { return JSON.parse(saved); } catch (e) { /* ignore */ }
    }
    return INITIAL_TASKS;
  });

  const [events, setEvents] = useState<GuildEvent[]>(() => {
    const saved = localStorage.getItem('hb_events');
    if (saved) {
      try { return JSON.parse(saved); } catch (e) { /* ignore */ }
    }
    return INITIAL_EVENTS;
  });

  useEffect(() => {
    localStorage.setItem('hb_events', JSON.stringify(events));
  }, [events]);

  const [offers, setOffers] = useState<Offer[]>(() => {
    const saved = localStorage.getItem('hb_offers');
    if (saved) {
      try { return JSON.parse(saved); } catch (e) { /* ignore */ }
    }
    return INITIAL_OFFERS;
  });

  const [teams] = useState<Team[]>(INITIAL_TEAMS);
  const [friends] = useState<SquadFriend[]>(INITIAL_FRIENDS);
  const [wars, setWars] = useState<TeamWar[]>(() => {
    const saved = localStorage.getItem('hb_wars');
    if (saved) {
      try { return JSON.parse(saved); } catch (e) { /* ignore */ }
    }
    return INITIAL_WARS;
  });

  const [messages, setMessages] = useState<CommsMessage[]>(() => {
    const saved = localStorage.getItem('hb_comms');
    if (saved) {
      try { return JSON.parse(saved); } catch (e) { /* ignore */ }
    }
    return INITIAL_MESSAGES;
  });

  const [notifications, setNotifications] = useState<NotificationItem[]>(INITIAL_NOTIFICATIONS);
  const [isOnWaitlist, setIsOnWaitlist] = useState<boolean>(() => {
    return localStorage.getItem('hb_nexus_waitlist') === 'true';
  });

  const [obdState, setObdState] = useState<ObdState>({
    isConnected: false,
    deviceMac: '',
    rpm: 0,
    speed: 0,
    coolantTemp: 195,
    fuelLevel: 78,
    throttlePos: 0,
    voltage: 13.8,
  });

  const [isDarkMode, setIsDarkMode] = useState<boolean>(() => {
    const saved = localStorage.getItem('hb_dark_mode');
    return saved !== null ? saved === 'true' : true;
  });

  useEffect(() => {
    if (isDarkMode) {
      document.documentElement.classList.add('dark');
      document.body.style.backgroundColor = '#0C0F1D';
      document.body.style.color = '#E9EDF2';
    } else {
      document.documentElement.classList.remove('dark');
      document.body.style.backgroundColor = '#F4F6FB';
      document.body.style.color = '#0F172A';
    }
  }, [isDarkMode]);
  const [searchQuery, setSearchQuery] = useState('');

  // Comms Drawer Target State
  const [isCommsOpen, setIsCommsOpen] = useState(false);
  const [commsTargetChannel, setCommsTargetChannel] = useState<CommsChannel>('radio');
  const [commsTargetRecipient, setCommsTargetRecipient] = useState<CommsRecipient | null>(null);

  const openComms = (
    channel: CommsChannel = 'radio',
    recipient: CommsRecipient | null = null
  ) => {
    setCommsTargetChannel(channel);
    setCommsTargetRecipient(recipient);
    setIsCommsOpen(true);
  };

  const closeComms = () => {
    setIsCommsOpen(false);
  };

  // Protocol Services Singletons
  const vault = MobileVaultSdk.getInstance();
  const fluoridian = FluoridianService.getInstance();
  const escrowLedger = TitheXEscrowLedger.getInstance();
  const pohDaemon = ProofOfHealthDaemon.getInstance();

  const [pohTelemetry, setPohTelemetry] = useState<ProofOfHealthTelemetry>(pohDaemon.getTelemetry());
  const [isPohDaemonActive, setIsPohDaemonActive] = useState<boolean>(pohDaemon.isDaemonActive());
  const [peerCount, setPeerCount] = useState<number>(fluoridian.getPeerCount());
  const [escrowTransactions, setEscrowTransactions] = useState<EscrowTransaction[]>(escrowLedger.getTransactions());
  const [inspectedEnvelope, setInspectedEnvelope] = useState<{ event?: NetworkEvent; escrowTx?: EscrowTransaction } | null>(null);

  // Subscribe to PoH Daemon updates
  useEffect(() => {
    const unsub = pohDaemon.subscribe(telem => {
      setPohTelemetry(telem);
    });
    return unsub;
  }, []);

  const togglePohDaemon = () => {
    if (isPohDaemonActive) {
      pohDaemon.stopDaemon();
      setIsPohDaemonActive(false);
    } else {
      pohDaemon.startDaemon();
      setIsPohDaemonActive(true);
    }
  };

  const inspectEnvelope = (event?: NetworkEvent, escrowTx?: EscrowTransaction) => {
    setInspectedEnvelope({ event, escrowTx });
  };

  const closeEnvelopeInspector = () => {
    setInspectedEnvelope(null);
  };

  // Persist state changes
  useEffect(() => {
    localStorage.setItem('hb_user', JSON.stringify(currentUser));
  }, [currentUser]);

  useEffect(() => {
    localStorage.setItem('hb_tasks', JSON.stringify(tasks));
  }, [tasks]);

  useEffect(() => {
    localStorage.setItem('hb_offers', JSON.stringify(offers));
  }, [offers]);

  useEffect(() => {
    localStorage.setItem('hb_wars', JSON.stringify(wars));
  }, [wars]);

  useEffect(() => {
    localStorage.setItem('hb_comms', JSON.stringify(messages));
  }, [messages]);

  // Simulated OBD live data ticker when connected
  useEffect(() => {
    if (!obdState.isConnected) return;
    const interval = setInterval(() => {
      setObdState(prev => {
        if (!prev.isConnected) return prev;
        const deltaRpm = Math.floor(Math.sin(Date.now() / 2000) * 400);
        const rpm = Math.max(750, Math.min(4500, 1850 + deltaRpm));
        const speed = Math.round(rpm / 45);
        const throttlePos = Math.round((rpm - 750) / 37.5);
        return {
          ...prev,
          rpm,
          speed,
          throttlePos,
          coolantTemp: 195 + Math.floor(Math.random() * 3),
        };
      });
    }, 500);

    return () => clearInterval(interval);
  }, [obdState.isConnected]);

  const selectTeam = (teamId: string) => {
    setSelectedTeamId(teamId);
    setCurrentUser(prev => ({ ...prev, joinedTeamId: teamId }));
  };

  const updateUserProfile = (updates: Partial<UserProfile>) => {
    setCurrentUser(prev => ({ ...prev, ...updates }));
  };

  const createTask = (taskData: Omit<Task, 'id' | 'createdAt' | 'updatedAt' | 'bidCount'>): Task => {
    const id = 'task-' + Date.now();
    const newTask: Task = {
      ...taskData,
      id,
      bidCount: 0,
      createdAt: new Date().toISOString(),
      updatedAt: new Date().toISOString(),
    };
    setTasks(prev => [newTask, ...prev]);

    // Sign and broadcast Event Envelope over TitheX P2P rail & lock escrow
    fluoridian.signAndBroadcast('TASK_CREATED', newTask, 'topic:tasks').then(() => {
      setEscrowTransactions(escrowLedger.getTransactions());
    });

    // Add notification
    setNotifications(prev => [
      {
        id: 'notif-' + Date.now(),
        title: 'Task Created & Escrow Locked',
        message: `Task "${newTask.title}" broadcast to network with TitheX Escrow.`,
        type: 'task',
        timestamp: 'Just now',
        read: false,
      },
      ...prev,
    ]);

    return newTask;
  };

  const updateTask = (id: string, updates: Partial<Task>) => {
    setTasks(prev =>
      prev.map(t => (t.id === id ? { ...t, ...updates, updatedAt: new Date().toISOString() } : t))
    );

    // If verification action
    if (updates.status === 'approved') {
      fluoridian.signAndBroadcast('TASK_VERIFIED', { taskId: id, action: 'APPROVED' }, 'topic:tasks').then(() => {
        setEscrowTransactions(escrowLedger.getTransactions());
      });
    } else if (updates.status === 'disputed') {
      fluoridian.signAndBroadcast('TASK_DISPUTED', { taskId: id, action: 'DISPUTED' }, 'topic:tasks').then(() => {
        setEscrowTransactions(escrowLedger.getTransactions());
      });
    }
  };

  const createEvent = (eventData: Omit<GuildEvent, 'id' | 'createdAt' | 'attendeesCount' | 'isRsvp'>): GuildEvent => {
    const id = 'event-' + Date.now();
    const newEvent: GuildEvent = {
      ...eventData,
      id,
      attendeesCount: 1,
      isRsvp: true,
      createdAt: new Date().toISOString(),
    };
    setEvents(prev => [newEvent, ...prev]);

    // Broadcast Fluoridian network event
    fluoridian.signAndBroadcast('TASK_CREATED' as any, {
      eventId: id,
      title: newEvent.title,
      category: newEvent.category,
      hostTeamId: newEvent.hostTeamId,
      lat: newEvent.lat,
      lng: newEvent.lng,
    }, 'topic:events');

    setNotifications(prev => [
      {
        id: 'notif-' + Date.now(),
        title: 'New Guild Event Scheduled',
        message: `${newEvent.title} scheduled for ${newEvent.date} at ${newEvent.time}.`,
        type: 'task',
        timestamp: 'Just now',
        read: false,
      },
      ...prev,
    ]);

    return newEvent;
  };

  const toggleRsvp = (eventId: string) => {
    setEvents(prev =>
      prev.map(ev => {
        if (ev.id === eventId) {
          const nextRsvp = !ev.isRsvp;
          return {
            ...ev,
            isRsvp: nextRsvp,
            attendeesCount: nextRsvp ? ev.attendeesCount + 1 : Math.max(0, ev.attendeesCount - 1),
          };
        }
        return ev;
      })
    );
  };

  const getTaskById = (id: string) => {
    return tasks.find(t => t.id === id);
  };

  const createOffer = (taskId: string, amount: number, message?: string) => {
    const targetTask = tasks.find(t => t.id === taskId);
    const newOffer: Offer = {
      id: 'bid-' + Date.now(),
      taskId,
      taskTitle: targetTask?.title || 'Community Task',
      providerId: currentUser.id,
      providerName: currentUser.displayName,
      providerRating: currentUser.rating,
      amount,
      message,
      proposedDate: new Date(Date.now() + 86400000 * 3).toISOString().split('T')[0],
      status: 'pending',
      createdAt: new Date().toISOString(),
    };
    setOffers(prev => [newOffer, ...prev]);
    // Increment bidCount on task
    updateTask(taskId, { bidCount: (targetTask?.bidCount || 0) + 1 });

    // Sign and broadcast over Fluoridian relay
    fluoridian.signAndBroadcast('MARKETPLACE_BID', newOffer, 'topic:bids');
  };

  const updateOfferStatus = (offerId: string, status: Offer['status']) => {
    setOffers(prev => prev.map(o => (o.id === offerId ? { ...o, status } : o)));
  };

  const declareWar = (defenderTeamId: string, message?: string) => {
    if (!selectedTeamId) return;
    const newWar: TeamWar = {
      id: 'war-' + Date.now(),
      challengerTeamId: selectedTeamId,
      defenderTeamId,
      challengerScore: 0,
      defenderScore: 0,
      status: 'active',
      declaredAt: Date.now(),
      message,
    };
    setWars(prev => [newWar, ...prev]);

    // Sign and broadcast over Fluoridian relay
    fluoridian.signAndBroadcast('WAR_DECLARED', newWar, 'topic:wars');

    const challenger = teams.find(t => t.id === selectedTeamId)?.name || 'Guild';
    const defender = teams.find(t => t.id === defenderTeamId)?.name || 'Enemy';

    setNotifications(prev => [
      {
        id: 'notif-' + Date.now(),
        title: 'War Declared!',
        message: `${challenger} challenged ${defender} to territorial war!`,
        type: 'war',
        timestamp: 'Just now',
        read: false,
      },
      ...prev,
    ]);
  };

  const recordWarVictory = (warId: string, winnerTeamId: string) => {
    setWars(prev =>
      prev.map(w => {
        if (w.id !== warId) return w;
        return {
          ...w,
          status: 'victory',
          challengerScore: w.challengerTeamId === winnerTeamId ? w.challengerScore + 50 : w.challengerScore,
          defenderScore: w.defenderTeamId === winnerTeamId ? w.defenderScore + 50 : w.defenderScore,
        };
      })
    );
  };

  const sendMessage = (
    content: string, 
    channel: CommsChannel, 
    isRadioPtt = false,
    recipientId?: string,
    recipientName?: string
  ) => {
    const targetRecipientId = recipientId || commsTargetRecipient?.id;
    const targetRecipientName = recipientName || commsTargetRecipient?.name;

    const newMsg: CommsMessage = {
      id: 'msg-' + Date.now(),
      senderId: 'me',
      senderName: currentUser.displayName,
      content,
      channel,
      timestamp: new Date().toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' }),
      isRadioPtt,
      recipientId: targetRecipientId,
      recipientName: targetRecipientName,
    };
    setMessages(prev => [...prev, newMsg]);

    // If direct message or team message, simulate an automated tactical reply after a short delay
    if (channel === 'direct' && targetRecipientName) {
      setTimeout(() => {
        const foundFriend = INITIAL_FRIENDS.find(
          f => f.id === targetRecipientId || f.callsign.toLowerCase() === targetRecipientName.toLowerCase()
        );
        const prefix = foundFriend ? `[${foundFriend.callsign} // ${foundFriend.freq}]` : `[${targetRecipientName}]`;
        const replyMsg: CommsMessage = {
          id: 'msg-' + (Date.now() + 1),
          senderId: targetRecipientId || 'friend_auto',
          senderName: targetRecipientName,
          content: `${prefix} Copy that, ${currentUser.displayName}. Transceiver signal verified on mesh channel. Standing by for tactical mission deployment.`,
          channel: 'direct',
          timestamp: new Date().toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' }),
          recipientId: currentUser.id,
          recipientName: currentUser.displayName,
        };
        setMessages(m => [...m, replyMsg]);
      }, 1200);
    } else if (channel === 'team' && targetRecipientName) {
      setTimeout(() => {
        const replyMsg: CommsMessage = {
          id: 'msg-' + (Date.now() + 1),
          senderId: targetRecipientId || 'team_dispatcher',
          senderName: `${targetRecipientName} Dispatch`,
          content: `Guild relay acknowledging dispatch from ${currentUser.displayName}. Standing by on tactical frequency.`,
          channel: 'team',
          timestamp: new Date().toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' }),
          recipientId: targetRecipientId,
          recipientName: targetRecipientName,
        };
        setMessages(m => [...m, replyMsg]);
      }, 1400);
    }
  };

  const markNotificationAsRead = (id: string) => {
    setNotifications(prev => prev.map(n => (n.id === id ? { ...n, read: true } : n)));
  };

  const clearNotifications = () => {
    setNotifications([]);
  };

  const joinWaitlist = async (name: string, email: string) => {
    await new Promise(r => setTimeout(r, 600));
    setIsOnWaitlist(true);
    localStorage.setItem('hb_nexus_waitlist', 'true');
    setNotifications(prev => [
      {
        id: 'notif-' + Date.now(),
        title: 'Nexus Waitlist Joined',
        message: `Welcome, ${name}! Your edge node slot is reserved.`,
        type: 'network',
        timestamp: 'Just now',
        read: false,
      },
      ...prev,
    ]);
  };

  const connectObd = (macAddress: string) => {
    setObdState({
      isConnected: true,
      deviceMac: macAddress || '00:1D:A5:68:9B:4C',
      rpm: 1250,
      speed: 28,
      coolantTemp: 195,
      fuelLevel: 78,
      throttlePos: 14,
      voltage: 14.1,
    });
  };

  const disconnectObd = () => {
    setObdState(prev => ({
      ...prev,
      isConnected: false,
      rpm: 0,
      speed: 0,
      throttlePos: 0,
    }));
  };

  const toggleTheme = () => {
    setIsDarkMode(prev => {
      const next = !prev;
      localStorage.setItem('hb_dark_mode', String(next));
      return next;
    });
  };

  return (
    <AppContext.Provider
      value={{
        currentUser,
        userDid: vault.getDid(),
        updateUserProfile,
        selectedTeamId,
        selectTeam,
        tasks,
        createTask,
        updateTask,
        getTaskById,
        events,
        createEvent,
        toggleRsvp,
        offers,
        createOffer,
        updateOfferStatus,
        teams,
        friends,
        wars,
        declareWar,
        recordWarVictory,
        messages,
        sendMessage,
        isCommsOpen,
        commsTargetChannel,
        commsTargetRecipient,
        openComms,
        closeComms,
        notifications,
        markNotificationAsRead,
        clearNotifications,
        isOnWaitlist,
        joinWaitlist,
        pohTelemetry,
        isPohDaemonActive,
        togglePohDaemon,
        peerCount,
        escrowTransactions,
        inspectedEnvelope,
        inspectEnvelope,
        closeEnvelopeInspector,
        obdState,
        connectObd,
        disconnectObd,
        isDarkMode,
        toggleTheme,
        searchQuery,
        setSearchQuery,
      }}
    >
      {children}
    </AppContext.Provider>
  );
};

export const useApp = () => {
  const context = useContext(AppContext);
  if (!context) {
    throw new Error('useApp must be used within an AppProvider');
  }
  return context;
};
