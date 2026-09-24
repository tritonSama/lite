import 'dart:async';
import 'package:flutter/material.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme.dart';
import 'mission_control_providers.dart';

class GameMapOverlay extends ConsumerStatefulWidget {
  const GameMapOverlay({super.key});

  @override
  ConsumerState<GameMapOverlay> createState() => _GameMapOverlayState();
}

class _GameMapOverlayState extends ConsumerState<GameMapOverlay> {
  String currentStyle = 'assets/styles/night_city.json';
  final List<String> themes = [
    'assets/styles/night_city.json', // Cyberpunk
    'assets/styles/los_santos.json', // GTA V
    'assets/styles/pixel_world.json', // Minecraft
  ];
  MapLibreMapController? _mapController;
  Position? _lastPosition;
  bool _styleLoaded = false;
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
    _positionStreamSub =
        Geolocator.getPositionStream(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
            distanceFilter: 5,
          ),
        ).listen((position) {
          if (mounted) {
            setState(() => _lastPosition = position);
            if (_styleLoaded) {
              _updateLocationLayer();
            }
          }
        });
  }

  void _switchTheme(String stylePath) {
    if (currentStyle == stylePath) return;
    setState(() {
      currentStyle = stylePath;
    });
  }

  void _onMapCreated(MapLibreMapController controller) {
    _mapController = controller;
  }

  void _onStyleLoaded() {
    setState(() {
      _styleLoaded = true;
    });
    _addLocationLayer();
    _addFriendsLayer();
  }

  @override
  Widget build(BuildContext context) {
    // Listen for friends location changes
    ref.listen(friendLocationsProvider, (previous, next) {
      if (_styleLoaded) {
        _updateFriendsLayer(next.whenOrNull(data: (d) => d) ?? []);
      }
    });

    return Stack(
      children: [
        MapLibreMap(
          onMapCreated: _onMapCreated,
          onStyleLoadedCallback: _onStyleLoaded,
          initialCameraPosition: CameraPosition(
            target: _lastPosition != null
                ? LatLng(_lastPosition!.latitude, _lastPosition!.longitude)
                : const LatLng(
                    34.05,
                    -118.24,
                  ), // Default to LA if no position yet
            zoom: 14,
          ),
          styleString: currentStyle,
          myLocationEnabled: false, // We use custom puck
          trackCameraPosition: true,
        ),
        // Custom UI overlays (like Cyberpunk/Game HUDs) can go here

        // Theme picker overlay
        Positioned(
          bottom: 24,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: themes.map((t) {
              final name = t.split('/').last;
              final isSelected = currentStyle == t;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isSelected
                        ? HBColors.primary
                        : HBColors.neutral,
                    foregroundColor: isSelected ? Colors.black : Colors.white,
                    side: const BorderSide(color: HBColors.primary),
                  ),
                  onPressed: () => _switchTheme(t),
                  child: Text(
                    name
                        .replaceAll('.json', '')
                        .replaceAll('_', ' ')
                        .toUpperCase(),
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
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

  Future<void> _updateLocationLayer() async {
    if (_mapController == null || _lastPosition == null || !_styleLoaded)
      return;

    final geoJsonData = {
      "type": "Feature",
      "geometry": {
        "type": "Point",
        "coordinates": [_lastPosition!.longitude, _lastPosition!.latitude],
      },
    };

    try {
      await _mapController!.setGeoJsonSource('user-location', geoJsonData);
    } catch (e) {
      // Source might not exist yet
    }
  }

  Future<void> _addLocationLayer() async {
    if (_mapController == null) return;

    final geoJsonData = _lastPosition != null
        ? {
            "type": "Feature",
            "geometry": {
              "type": "Point",
              "coordinates": [
                _lastPosition!.longitude,
                _lastPosition!.latitude,
              ],
            },
          }
        : {"type": "FeatureCollection", "features": []};

    try {
      await _mapController!.addGeoJsonSource('user-location', geoJsonData);
      await _mapController!.addCircleLayer(
        'user-location',
        'user-dot',
        const CircleLayerProperties(
          circleRadius: 8,
          circleColor: '#00FFFF', // Cyan glow
          circleStrokeWidth: 2,
          circleStrokeColor: '#FFFFFF',
        ),
      );
    } catch (e) {
      debugPrint("Error adding location layer: $e");
    }
  }

  Future<void> _updateFriendsLayer(List<FriendLocation> friends) async {
    if (_mapController == null || !_styleLoaded) return;

    final features = friends
        .map(
          (f) => {
            "type": "Feature",
            "properties": {"name": f.name, "id": f.id},
            "geometry": {
              "type": "Point",
              "coordinates": [f.longitude, f.latitude],
            },
          },
        )
        .toList();

    final geoJsonData = {"type": "FeatureCollection", "features": features};

    try {
      await _mapController!.setGeoJsonSource('friends-locations', geoJsonData);
    } catch (e) {
      // Source might not exist yet
    }
  }

  Future<void> _addFriendsLayer() async {
    if (_mapController == null) return;

    final friendsAsyncValue = ref.read(friendLocationsProvider);
    final friends = friendsAsyncValue.whenOrNull(data: (d) => d) ?? [];

    final features = friends
        .map(
          (f) => {
            "type": "Feature",
            "properties": {"name": f.name, "id": f.id},
            "geometry": {
              "type": "Point",
              "coordinates": [f.longitude, f.latitude],
            },
          },
        )
        .toList();

    final geoJsonData = {"type": "FeatureCollection", "features": features};

    try {
      await _mapController!.addGeoJsonSource('friends-locations', geoJsonData);
      await _mapController!.addCircleLayer(
        'friends-locations',
        'friends-dots',
        const CircleLayerProperties(
          circleRadius: 6,
          circleColor: '#D4AF37', // Gold/secondary color
          circleStrokeWidth: 1,
          circleStrokeColor: '#FFFFFF',
        ),
      );

      await _mapController!.addSymbolLayer(
        'friends-locations',
        'friends-labels',
        const SymbolLayerProperties(
          textField: ['get', 'name'],
          textSize: 12,
          textColor: '#FFFFFF',
          textHaloColor: '#D4AF37',
          textHaloWidth: 1,
          textOffset: [0, 1.5],
        ),
      );
    } catch (e) {
      debugPrint("Error adding friends layer: $e");
    }
  }
}
