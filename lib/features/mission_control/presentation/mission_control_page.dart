import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../../../app/theme.dart';
import '../data/weather_service.dart';
import '../domain/weather_data.dart';

class MissionControlPage extends StatefulWidget {
  const MissionControlPage({super.key});

  @override
  State<MissionControlPage> createState() => _MissionControlPageState();
}

class _MissionControlPageState extends State<MissionControlPage> {
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
          const Expanded(
            flex: 2,
            child: _GlobeVisualization(),
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
                  onTap: () {},
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

  const _QuickActionTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
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

class _GlobeVisualization extends StatefulWidget {
  const _GlobeVisualization();

  @override
  State<_GlobeVisualization> createState() => _GlobeVisualizationState();
}

class _GlobeVisualizationState extends State<_GlobeVisualization>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: _GlobePainter(_controller.value * 2 * math.pi),
          size: Size.infinite,
        );
      },
    );
  }
}

class _GlobePainter extends CustomPainter {
  final double rotation;

  _GlobePainter(this.rotation);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) * 0.4;

    // Draw neon glow
    final glowPaint = Paint()
      ..color = HBColors.primary.withValues(alpha: 0.2)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 30);
    canvas.drawCircle(center, radius, glowPaint);

    // Draw globe base
    final paint = Paint()
      ..color = const Color(0xFF0C0F1D)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius, paint);

    // Draw grid lines (longitude)
    final linePaint = Paint()
      ..color = HBColors.primary.withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    for (int i = 0; i < 12; i++) {
      final t = (i / 12) * math.pi + rotation;
      final dx = math.cos(t) * radius;

      final path = Path();
      path.moveTo(center.dx, center.dy - radius);
      path.quadraticBezierTo(
        center.dx + dx * 2, center.dy,
        center.dx, center.dy + radius,
      );
      canvas.drawPath(path, linePaint);
    }

    // Draw grid lines (latitude)
    for (int i = 1; i < 6; i++) {
      final yOffset = radius * math.cos(i * math.pi / 6);
      final xRadius = radius * math.sin(i * math.pi / 6);
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(center.dx, center.dy + yOffset),
          width: xRadius * 2,
          height: xRadius * 0.4,
        ),
        linePaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _GlobePainter oldDelegate) {
    return oldDelegate.rotation != rotation;
  }
}
