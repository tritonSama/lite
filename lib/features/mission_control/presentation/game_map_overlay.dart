import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluoderpod/fluoderpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../app/theme.dart';
import 'mission_control_providers.dart';
import '../../comms/presentation/comms_overlay.dart';
import '../../teams/presentation/declare_war_dialog.dart';

class GameMapOverlay extends ConsumerStatefulWidget {
  const GameMapOverlay({super.key});

  @override
  ConsumerState<GameMapOverlay> createState() => _GameMapOverlayState();
}

class _GameMapOverlayState extends ConsumerState<GameMapOverlay> {
  String currentMode = 'CYBERPUNK RADAR';
  final List<String> modes = ['CYBERPUNK RADAR', 'TACTICAL GRID', 'SATELLITE 3D', 'STREET VIEW'];
  Position? _currentPosition;
  StreamSubscription<Position>? _positionStreamSub;

  @override
  void initState() {
    super.initState();
    _startLocationTracking();
  }

  @override
  void dispose() {
    _positionStreamSub?.cancel();
    super.dispose();
  }

  void _startLocationTracking() {
    _positionStreamSub = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 2,
      ),
    ).listen((position) {
      if (mounted) {
        setState(() => _currentPosition = position);
      }
    });
  }

  void _switchMode(String mode) {
    if (mode == 'STREET VIEW') {
      final lat = _currentPosition?.latitude ?? 30.2672;
      final lng = _currentPosition?.longitude ?? -97.7431;
      _launchStreetView(lat, lng);
    } else {
      setState(() {
        currentMode = mode;
      });
    }
  }

  Future<void> _launchStreetView(double lat, double lng) async {
    final url = Uri.parse('https://www.google.com/maps/@?api=1&map_action=pano&viewpoint=$lat,$lng');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Opening Street View at $lat, $lng...')),
        );
      }
    }
  }

  Future<void> _launchNavigation(double lat, double lng) async {
    final url = Uri.parse('https://www.google.com/maps/dir/?api=1&destination=$lat,$lng');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Opening Google Maps route to $lat, $lng...')),
        );
      }
    }
  }

  void _onNodeSelectedOnGlobe(CyanNode node) {
    if (node.id.startsWith('person-')) {
      // Person / Operator Selected on Fluonder Globe -> Option to Open Comms & Navigation
      _showPersonCommsSheet(node.name, 'CALLSIGN-${node.id.toUpperCase().replaceAll('PERSON-', '')}', '462.5625 MHz', node.latitude, node.longitude);
    } else if (node.id.startsWith('sat-')) {
      // Satellite Selected -> Show Orbital Telemetry
      _showSatelliteTelemetrySheet(node.name, node.latencyMs);
    } else {
      // Guild Outpost / Faction Node Selected -> Option to Declare War & Street View
      _showFactionWarSheet(node.name, node.id, node.latitude, node.longitude);
    }
  }

  void _showFlightSheet(EntityPacket flight) {
    final label = flight.callsign ?? flight.id;
    final isSatellite = flight.z > 30000 || flight.id.contains('SAT');

    showModalBottomSheet(
      context: context,
      backgroundColor: HBColors.neutral,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(HBRadius.xl)),
        side: BorderSide(color: HBColors.primary, width: 1.5),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(HBSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    isSatellite ? Icons.satellite_alt : Icons.flight_takeoff,
                    color: isSatellite ? Colors.amberAccent : HBColors.primary,
                    size: 28,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      label,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'Altitude: ${flight.z.toInt()}m • Speed: Mach 1.2 • Vector: En Route',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  fontFamily: 'monospace',
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: HBColors.primaryLight,
                        side: const BorderSide(color: HBColors.primaryLight),
                      ),
                      icon: const Icon(Icons.streetview, size: 16),
                      label: const Text('360° Ground View'),
                      onPressed: () {
                        Navigator.pop(context);
                        _launchStreetView(flight.y, flight.x);
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: HBColors.primary,
                      ),
                      icon: const Icon(Icons.cell_tower, size: 16),
                      label: const Text('Radio Link'),
                      onPressed: () {
                        Navigator.pop(context);
                        showModalBottomSheet(
                          context: context,
                          backgroundColor: Colors.transparent,
                          isScrollControlled: true,
                          builder: (context) => Padding(
                            padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * 0.3,
                            ),
                            child: const CommsOverlay(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _showPersonCommsSheet(String name, String callsign, String frequency, double lat, double lng) {
    showModalBottomSheet(
      context: context,
      backgroundColor: HBColors.neutral,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(HBRadius.xl)),
        side: BorderSide(color: HBColors.primary, width: 1.5),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(HBSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: HBColors.primary,
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                      Text('Callsign: $callsign • Radio: $frequency', style: const TextStyle(color: HBColors.primaryLight, fontSize: 12, fontFamily: 'monospace')),
                      Text('GPS: ${lat.toStringAsFixed(4)}°, ${lng.toStringAsFixed(4)}°', style: const TextStyle(color: Colors.white54, fontSize: 11)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: HBColors.primaryLight,
                        side: const BorderSide(color: HBColors.primaryLight),
                      ),
                      icon: const Icon(Icons.streetview, size: 16),
                      label: const Text('360° Street View'),
                      onPressed: () {
                        Navigator.pop(context);
                        _launchStreetView(lat, lng);
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: HBColors.secondary,
                        side: const BorderSide(color: HBColors.secondary),
                      ),
                      icon: const Icon(Icons.navigation, size: 16),
                      label: const Text('Navigate (Maps)'),
                      onPressed: () {
                        Navigator.pop(context);
                        _launchNavigation(lat, lng);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: HBColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  icon: const Icon(Icons.cell_tower),
                  label: const Text('📡 OPEN COMMS WITH OPERATOR'),
                  onPressed: () {
                    Navigator.pop(context);
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.transparent,
                      isScrollControlled: true,
                      builder: (context) => Padding(
                        padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.3,
                        ),
                        child: const CommsOverlay(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showFactionWarSheet(String factionName, String factionId, double lat, double lng) {
    showModalBottomSheet(
      context: context,
      backgroundColor: HBColors.neutral,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(HBRadius.xl)),
        side: BorderSide(color: HBColors.error, width: 1.5),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(HBSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.shield, color: HBColors.error, size: 28),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'RIVAL FACTION: ${factionName.toUpperCase()}',
                      style: const TextStyle(color: HBColors.error, fontWeight: FontWeight.bold, fontSize: 15, letterSpacing: 1.1),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text('Outpost GPS: ${lat.toStringAsFixed(4)}°, ${lng.toStringAsFixed(4)}°', style: const TextStyle(color: Colors.white70, fontSize: 12, fontFamily: 'monospace')),
              const Text('Territory: Active Outpost • Staked FLR: 24,500 • Rating: 4.8★', style: TextStyle(color: Colors.white54, fontSize: 11)),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: HBColors.primaryLight,
                        side: const BorderSide(color: HBColors.primaryLight),
                      ),
                      icon: const Icon(Icons.streetview, size: 16),
                      label: const Text('360° Street View'),
                      onPressed: () {
                        Navigator.pop(context);
                        _launchStreetView(lat, lng);
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: HBColors.secondary,
                        side: const BorderSide(color: HBColors.secondary),
                      ),
                      icon: const Icon(Icons.navigation, size: 16),
                      label: const Text('Route (Maps)'),
                      onPressed: () {
                        Navigator.pop(context);
                        _launchNavigation(lat, lng);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: HBColors.error,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  icon: const Icon(Icons.military_tech),
                  label: const Text('⚔️ INITIATE WAR FROM GLOBE'),
                  onPressed: () {
                    Navigator.pop(context);
                    showDialog(
                      context: context,
                      builder: (context) => DeclareWarDialog(
                        myTeamName: 'Water Clan',
                        enemyTeamName: factionName,
                        enemyTeamId: factionId,
                        onDeclare: (message) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('War declared against $factionName! Message: $message'),
                              backgroundColor: Colors.redAccent,
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showSatelliteTelemetrySheet(String satName, int latency) {
    showModalBottomSheet(
      context: context,
      backgroundColor: HBColors.neutral,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(HBRadius.xl)),
        side: BorderSide(color: HBColors.primary, width: 1.5),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(HBSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.satellite_alt, color: HBColors.primary, size: 28),
                  const SizedBox(width: 10),
                  Text(satName, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                ],
              ),
              const SizedBox(height: 12),
              Text('Orbital Latency: ${latency}ms • Downlink: 10.5 Gbps Laser Crosslink', style: const TextStyle(color: Colors.white70, fontSize: 12, fontFamily: 'monospace')),
              const SizedBox(height: 8),
              const Text('Payload: Multispectral Optical + SAR Radar Transponder.', style: TextStyle(color: Colors.white54, fontSize: 12)),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final friendsAsync = ref.watch(friendLocationsProvider);

    final userLat = _currentPosition?.latitude ?? 30.2672;
    final userLng = _currentPosition?.longitude ?? -97.7431;

    // Rich Fluonder Globe Node Roster centered over live GPS camera view
    final cyanNodes = [
      // Factions / Outposts
      CyanNode(id: 'node-water-hq', name: 'Water Clan HQ', latitude: userLat - 0.008, longitude: userLng - 0.005, latencyMs: 12, isHomebase: true),
      CyanNode(id: 'node-fire-depot', name: 'Fire Tribe Depot', latitude: userLat + 0.006, longitude: userLng + 0.008, latencyMs: 18),
      CyanNode(id: 'node-earth-citadel', name: 'Earth Guild Citadel', latitude: userLat + 0.012, longitude: userLng - 0.002, latencyMs: 22),
      CyanNode(id: 'node-wind-spire', name: 'Wind Order Sky Spire', latitude: userLat - 0.004, longitude: userLng + 0.010, latencyMs: 15),

      // Persons / Squad Operators
      CyanNode(id: 'person-titan-1', name: 'Operator Titan-1', latitude: userLat + 0.002, longitude: userLng + 0.003, latencyMs: 14),
      CyanNode(id: 'person-ghost-2', name: 'Operator Ghost-2', latitude: userLat - 0.005, longitude: userLng - 0.002, latencyMs: 28),
      CyanNode(id: 'person-viper-3', name: 'Operator Viper-3', latitude: userLat + 0.008, longitude: userLng - 0.006, latencyMs: 19),

      // Satellites directly in local camera field
      CyanNode(id: 'sat-nexus-1', name: 'NEXUS-RECON-1 (Orbital)', latitude: userLat + 0.025, longitude: userLng + 0.015, latencyMs: 45),
      CyanNode(id: 'sat-relay-alpha', name: 'FLUORIDIAN-RELAY (P2P Mesh)', latitude: userLat - 0.020, longitude: userLng - 0.018, latencyMs: 52),
    ];

    // Live Flights / Aerial Drones / Plane Trackers directly in local camera field
    final flightPackets = [
      EntityPacket(id: 'FLIGHT-AZ-402', x: userLng + 0.012, y: userLat - 0.010, z: 12000, type: FluoderpodEntityType.player, callsign: 'FLIGHT-AZ-402 (Aerial Recon)'),
      EntityPacket(id: 'FLIGHT-CYAN-88', x: userLng - 0.015, y: userLat + 0.012, z: 8500, type: FluoderpodEntityType.player, callsign: 'FLIGHT-CYAN-88 (P2P Transport)'),
      EntityPacket(id: 'SAT-STARLINK-88', x: userLng + 0.022, y: userLat + 0.018, z: 55000, type: FluoderpodEntityType.player, callsign: 'STARLINK-FLR-88 (Broadband)'),
    ];

    return Stack(
      children: [
        // High-Performance Interactive Fluonder Globe via Fluoderpod
        Positioned.fill(
          child: CyanDashboard(
            globeWidget: CyanGlobeOverview(
              nodes: cyanNodes,
              flights: flightPackets,
              onNodeSelected: _onNodeSelectedOnGlobe,
              onFlightSelected: _showFlightSheet,
            ),
            immersiveAppWidget: const CyanImmersiveView(),
          ),
        ),

        // Live GPS Status Header Overlay
        Positioned(
          top: 10,
          left: 10,
          right: 10,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.75),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: HBColors.primary.withValues(alpha: 0.5)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.gps_fixed, color: HBColors.primary, size: 14),
                    const SizedBox(width: 6),
                    Text(
                      'GPS: ${userLat.toStringAsFixed(4)}°, ${userLng.toStringAsFixed(4)}°',
                      style: const TextStyle(color: Colors.white, fontSize: 11, fontFamily: 'monospace', fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Text(
                  _currentPosition != null ? 'LIVE GPS LOCK (${_currentPosition!.accuracy.toInt()}m)' : 'GPS SEARCHING...',
                  style: const TextStyle(color: HBColors.secondary, fontSize: 10, fontWeight: FontWeight.bold, fontFamily: 'monospace'),
                ),
              ],
            ),
          ),
        ),

        // Mode Switcher Overlay Bar
        Positioned(
          bottom: 16,
          left: 16,
          right: 16,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: modes.map((m) {
              final isSelected = currentMode == m;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isSelected ? HBColors.primary : HBColors.neutral,
                      foregroundColor: isSelected ? Colors.black : Colors.white,
                      side: const BorderSide(color: HBColors.primary),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                    onPressed: () => _switchMode(m),
                    child: Text(
                      m,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.black : Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
