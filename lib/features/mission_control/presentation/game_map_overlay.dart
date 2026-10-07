import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluoderpod/fluoderpod.dart';

import '../../../app/theme.dart';
import 'mission_control_providers.dart';

class GameMapOverlay extends ConsumerStatefulWidget {
  const GameMapOverlay({super.key});

  @override
  ConsumerState<GameMapOverlay> createState() => _GameMapOverlayState();
}

class _GameMapOverlayState extends ConsumerState<GameMapOverlay> {
  String currentMode = 'CYBERPUNK RADAR';
  final List<String> modes = ['CYBERPUNK RADAR', 'TACTICAL GRID', 'SATELLITE'];
  Position? _lastPosition;
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
        distanceFilter: 5,
      ),
    ).listen((position) {
      if (mounted) {
        setState(() => _lastPosition = position);
      }
    });
  }

  void _switchMode(String mode) {
    setState(() {
      currentMode = mode;
    });
  }

  @override
  Widget build(BuildContext context) {
    final friendsAsync = ref.watch(friendLocationsProvider);

    return Stack(
      children: [
        // High-Performance Interactive Holographic Globe / Radar View via Fluoderpod
        Positioned.fill(
          child: CyanDashboard(
            globeWidget: const CyanGlobeOverview(),
            immersiveAppWidget: const CyanImmersiveView(),
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
