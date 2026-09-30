import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:geolocator/geolocator.dart';

part 'mission_control_providers.g.dart';

class FriendLocation {
  final String id;
  final String name;
  final double latitude;
  final double longitude;

  FriendLocation({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
  });
}

@riverpod
Stream<Position> userLocation(Ref ref) async* {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Fallback default position if services are disabled (approx user location)
    yield Position(
      latitude: 37.7749,
      longitude: -122.4194,
      timestamp: DateTime.now(),
      accuracy: 100,
      altitude: 0,
      altitudeAccuracy: 1,
      heading: 0,
      headingAccuracy: 1,
      speed: 0,
      speedAccuracy: 1,
    );
    return;
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      yield Position(
        latitude: 37.7749,
        longitude: -122.4194,
        timestamp: DateTime.now(),
        accuracy: 100,
        altitude: 0,
        altitudeAccuracy: 1,
        heading: 0,
        headingAccuracy: 1,
        speed: 0,
        speedAccuracy: 1,
      );
      return;
    }
  }

  if (permission == LocationPermission.deniedForever) {
    yield Position(
      latitude: 37.7749,
      longitude: -122.4194,
      timestamp: DateTime.now(),
      accuracy: 100,
      altitude: 0,
      altitudeAccuracy: 1,
      heading: 0,
      headingAccuracy: 1,
      speed: 0,
      speedAccuracy: 1,
    );
    return;
  }

  yield* Geolocator.getPositionStream(
    locationSettings: const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 5,
    ),
  );
}

@riverpod
Future<List<FriendLocation>> friendLocations(Ref ref) async {
  // Get current user location if available, otherwise default
  Position? currentPos;
  try {
    currentPos = await Geolocator.getLastKnownPosition();
    currentPos ??= await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.medium),
    ).timeout(const Duration(seconds: 2), onTimeout: () => Position(
      latitude: 37.7749,
      longitude: -122.4194,
      timestamp: DateTime.now(),
      accuracy: 100,
      altitude: 0,
      altitudeAccuracy: 1,
      heading: 0,
      headingAccuracy: 1,
      speed: 0,
      speedAccuracy: 1,
    ));
  } catch (e) {
    // Default fallback center
  }

  final lat = currentPos?.latitude ?? 37.7749;
  final lng = currentPos?.longitude ?? -122.4194;

  // Generate realistic nearby agents relative to the user's actual GPS coordinates
  return [
    FriendLocation(
      id: '1',
      name: 'Agent Alpha (Nearby)',
      latitude: lat + 0.015,
      longitude: lng + 0.02,
    ),
    FriendLocation(
      id: '2',
      name: 'Agent Bravo (Sector 7)',
      latitude: lat - 0.02,
      longitude: lng + 0.01,
    ),
    FriendLocation(
      id: '3',
      name: 'Agent Delta (Outpost)',
      latitude: lat + 0.01,
      longitude: lng - 0.025,
    ),
    FriendLocation(
      id: '4',
      name: 'Operator 04 (Hub)',
      latitude: lat - 0.012,
      longitude: lng - 0.015,
    ),
  ];
}
