import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flame/game.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme.dart';
import '../data/weather_service.dart';
import '../domain/weather_data.dart';
import 'globe_game.dart';
import 'mission_control_providers.dart';
import '../../comms/presentation/comms_overlay.dart';

class MissionControlPage extends ConsumerStatefulWidget {
  const MissionControlPage({super.key});

  @override
  ConsumerState<MissionControlPage> createState() => _MissionControlPageState();
}

class _MissionControlPageState extends ConsumerState<MissionControlPage> {
  final WeatherService _weatherService = WeatherService();
  late Future<WeatherData?> _weatherFuture;
  
  // Default to San Francisco
  final double lat = 37.7749;
  final double lng = -122.4194;

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }
  
  void _fetchWeather() {
    setState(() {
      _weatherFuture = _weatherService.fetchWeather(lat, lng);
    });
  }
  
  IconData _getWeatherIcon(String description) {
    final lower = description.toLowerCase();
    if (lower.contains('rain')) return Icons.water_drop;
    if (lower.contains('snow')) return Icons.ac_unit;
    if (lower.contains('cloud')) return Icons.cloud;
    if (lower.contains('storm')) return Icons.thunderstorm;
    return Icons.wb_sunny;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mission Control'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(HBSpacing.md),
            child: FutureBuilder<WeatherData?>(
              future: _weatherFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(HBRadius.md),
                      side: BorderSide(color: HBColors.primary.withValues(alpha: 0.5)),
                    ),
                    color: HBColors.neutral,
                    child: const Padding(
                      padding: EdgeInsets.all(HBSpacing.lg),
                      child: Center(
                        child: CircularProgressIndicator(color: HBColors.primary),
                      ),
                    ),
                  );
                }

                final data = snapshot.data;
                if (snapshot.hasError || data == null) {
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(HBRadius.md),
                      side: BorderSide(color: HBColors.primary.withValues(alpha: 0.5)),
                    ),
                    color: HBColors.neutral,
                    child: Padding(
                      padding: const EdgeInsets.all(HBSpacing.lg),
                      child: Center(
                        child: Column(
                          children: [
                            const Text('Weather Unavailable', style: TextStyle(color: Colors.redAccent)),
                            const SizedBox(height: HBSpacing.sm),
                            ElevatedButton(
                              onPressed: _fetchWeather,
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }

                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(HBRadius.md),
                    side: const BorderSide(color: HBColors.primary),
                  ),
                  color: HBColors.neutral,
                  child: Padding(
                    padding: const EdgeInsets.all(HBSpacing.md),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(_getWeatherIcon(data.description), size: 48, color: HBColors.secondary),
                            Text('${data.temperature.toStringAsFixed(1)}°F', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
                            Text(data.cityName, style: const TextStyle(fontSize: 18, color: HBColors.primary)),
                          ],
                        ),
                        const SizedBox(height: HBSpacing.sm),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text('Humidity: ${data.humidity}%', style: const TextStyle(color: Colors.white70)),
                            Text('Wind: ${data.windSpeed} mph', style: const TextStyle(color: Colors.white70)),
                            Text(data.description.toUpperCase(), style: const TextStyle(color: HBColors.secondary, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            flex: 2,
            child: ref.watch(friendLocationsProvider).when(
                  data: (friends) {
                    return GameWidget(
                      game: GlobeGame(friends: friends),
                    );
                  },
                  loading: () => const Center(
                    child: CircularProgressIndicator(color: HBColors.primary),
                  ),
                  error: (error, stack) => Center(
                    child: Text('Error loading friends: $error',
                        style: const TextStyle(color: Colors.redAccent)),
                  ),
                ),
          ),
          Expanded(
            flex: 1,
            child: GridView.count(
              crossAxisCount: 2,
              childAspectRatio: 2.5,
              padding: const EdgeInsets.all(HBSpacing.md),
              mainAxisSpacing: HBSpacing.md,
              crossAxisSpacing: HBSpacing.md,
              children: [
                _QuickActionTile(
                  icon: Icons.gps_fixed,
                  label: 'GPS',
                  onTap: () {},
                ),
                _QuickActionTile(
                  icon: Icons.satellite_alt,
                  label: 'Comms',
                  onTap: () {
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
                  onLongPress: () {
                    context.push('/mission-control/comms-config');
                  },
                ),
                _QuickActionTile(
                  icon: Icons.groups,
                  label: 'Teams',
                  onTap: () {},
                ),
                _QuickActionTile(
                  icon: Icons.military_tech,
                  label: 'Wars',
                  onTap: () {},
                ),
                _QuickActionTile(
                  icon: Icons.speed,
                  label: 'OBD2 Data',
                  onTap: () {
                    context.push('/mission-control/obd');
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  const _QuickActionTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        decoration: BoxDecoration(
          color: HBColors.neutral,
          border: Border.all(color: HBColors.primary),
          borderRadius: BorderRadius.circular(HBRadius.sm),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: HBColors.primary),
            const SizedBox(width: HBSpacing.sm),
            Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

