// Task and Marketplace Enums
export type TaskStatus =
  | 'draft'
  | 'published'
  | 'fundingOpen'
  | 'bidding'
  | 'providerSelected'
  | 'teamForming'
  | 'scheduled'
  | 'inProgress'
  | 'submittedForVerification'
  | 'approved'
  | 'paymentReleased'
  | 'completed'
  | 'cancelled'
  | 'disputed'
  | 'expired';

export type OfferStatus =
  | 'pending'
  | 'accepted'
  | 'rejected'
  | 'countered'
  | 'withdrawn'
  | 'expired';

export type TaskCategory =
  | 'Home Improvement'
  | 'Logistics & Delivery'
  | 'Automotive & OBD'
  | 'Event Support'
  | 'Field Cleanup'
  | 'Tech & Hardware'
  | 'Service'
  | 'Other';

export type ListingType = 'forSale' | 'wantedToBuy' | 'forRent';
export type RentalDuration = 'hourly' | 'daily' | 'weekly' | 'monthly';

export type WarStatus = 'pending' | 'active' | 'ceasefire' | 'victory' | 'defeat';

export type CredentialType =
  | 'driversLicense'
  | 'cdl'
  | 'electricalLicense'
  | 'contractorLicense'
  | 'insurance'
  | 'foodHandler'
  | 'backgroundCheck'
  | 'other';

export type CredentialStatus =
  | 'uploaded'
  | 'underReview'
  | 'verified'
  | 'rejected'
  | 'expired';

export interface RequiredCredential {
  credentialType: CredentialType;
  isRequired: boolean;
}

export interface Task {
  id: string;
  creatorId: string;
  creatorName?: string;
  creatorTeamId?: string;
  title: string;
  description: string;
  photoUrls: string[];
  locationLabel: string;
  lat: number;
  lng: number;
  desiredCompletionDate: string;
  budgetAmount: number;
  currencyCode: string;
  requiredSkills: string[];
  requiredEquipment?: string[];
  requiredCredentials?: RequiredCredential[];
  requireId?: boolean;
  requireInsurance?: boolean;
  workerCount: number;
  specialRequirements?: string;
  platformFee?: number;
  status: TaskStatus;
  selectedProviderId?: string;
  selectedProviderName?: string;
  bidCount: number;
  category: TaskCategory;
  listingType?: ListingType;
  rentalDuration?: RentalDuration;
  createdAt: string;
  updatedAt: string;
  proofPhotos?: string[];
  verificationNotes?: string;
}

export interface Offer {
  id: string;
  taskId: string;
  taskTitle?: string;
  providerId: string;
  providerName: string;
  providerRating: number;
  amount: number;
  message?: string;
  proposedDate?: string;
  status: OfferStatus;
  createdAt: string;
}

export interface Team {
  id: string;
  name: string;
  description?: string;
  ownerId: string;
  memberCount: number;
  membersOnline: number;
  icon: string;
  color: string;
  credentialIds: string[];
  parentIds: string[];
  sisterClubIds: string[];
  treatyIds: string[];
  rating: number;
  completedJobCount: number;
  createdAt: string;
}

export interface TeamWar {
  id: string;
  challengerTeamId: string;
  defenderTeamId: string;
  challengerScore: number;
  defenderScore: number;
  status: WarStatus;
  declaredAt: number;
  message?: string;
}

export interface Credential {
  id: string;
  userId: string;
  type: CredentialType;
  documentUrl?: string;
  status: CredentialStatus;
  issuer?: string;
  issueDate?: string;
  expirationDate?: string;
}

export interface UserProfile {
  id: string;
  displayName: string;
  email: string;
  photoURL?: string;
  bio?: string;
  skills: string[];
  rating: number;
  completedJobsCount: number;
  totalEarnings: number;
  joinedTeamId?: string;
  credentials: Credential[];
}

export type CommsChannel = 'direct' | 'team' | 'global' | 'radio';

export interface CommsMessage {
  id: string;
  senderId: string;
  senderName: string;
  content: string;
  channel: CommsChannel;
  timestamp: string;
  isRadioPtt?: boolean;
  recipientId?: string;
  recipientName?: string;
}

export interface SquadFriend {
  id: string;
  name: string;
  callsign: string;
  status: 'online' | 'recon' | 'patrol' | 'standby';
  lat: number;
  lng: number;
  street: string;
  freq: string;
  battery: number;
  health: number;
  color: string;
  assignedTeamId: string;
  assignedTeamName: string;
  avatarUrl?: string;
  role?: string;
}

export interface WeatherData {
  cityName: string;
  temperature: number;
  humidity: number;
  windSpeed: number;
  description: string;
}

// 9x9 Board Game Types
export type PlayerId = 'p1' | 'p2';
export type GamePhase = 'setup' | 'playing' | 'gameOver';
export type TurnPhase = 'rollForMovement' | 'move' | 'resolveTrap' | 'resolveCombat';
export type SetupItemType = 'piece' | 'trap' | 'flag';

export interface Point {
  x: number;
  y: number;
}

export interface TrapCard {
  id: string;
  value: number; // 1 to 12
}

export interface PlayerGameState {
  id: PlayerId;
  name: string;
  hp: number;
  unplacedTraps: TrapCard[];
  piecesToPlace: number;
  flagPlaced: boolean;
  setupComplete: boolean;
}

export interface NotificationItem {
  id: string;
  title: string;
  message: string;
  type: 'task' | 'war' | 'bid' | 'network';
  timestamp: string;
  read: boolean;
}

export interface ObdState {
  isConnected: boolean;
  deviceMac: string;
  rpm: number;
  speed: number;
  coolantTemp: number;
  fuelLevel: number;
  throttlePos: number;
  voltage: number;
}

export type GlobeMarkerType =
  | 'my_club'
  | 'other_club'
  | 'friend'
  | 'satellite'
  | 'task'
  | 'event'
  | 'obd_vehicle'
  | 'street_poi';

export interface GlobeMarker {
  id: string;
  name: string;
  type: GlobeMarkerType;
  lat: number;
  lng: number;
  altitudeKm: number;
  color: string;
  streetAddress?: string;
  sectorId?: string;
  clubId?: string;
  memberCount?: number;
  stakedFlr?: number;
  statusText?: string;
  friendCallsign?: string;
  velocityMph?: number;
  batteryPercent?: number;
  healthPercent?: number;
  radioFrequency?: string;
  orbitPeriodMin?: number;
  orbitInclinationDeg?: number;
  sensorPayload?: string;
  downlinkBandwidth?: string;
  bountyUsd?: number;
  bountyFlr?: number;
  taskCategory?: string;
  eventDate?: string;
  eventTime?: string;
  eventAttendees?: number;
  obdRpm?: number;
  obdSpeedMph?: number;
  did?: string;
  ed25519Key?: string;
}

export type EventCategory =
  | 'Guild Raid'
  | 'Community Meetup'
  | 'Tech Workshop'
  | 'Field Operation'
  | 'Sector Cleanup'
  | 'Tournament & War';

export interface GuildEvent {
  id: string;
  title: string;
  description: string;
  category: EventCategory;
  hostTeamId: string;
  hostName: string;
  date: string;
  time: string;
  locationLabel: string;
  lat: number;
  lng: number;
  attendeesCount: number;
  maxCapacity?: number;
  rewardFlr: number;
  rewardExp: number;
  isRsvp: boolean;
  status: 'upcoming' | 'in-progress' | 'completed';
  createdAt: string;
}

