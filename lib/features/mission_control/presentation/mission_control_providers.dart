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
    throw Exception('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      throw Exception('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    throw Exception('Location permissions are permanently denied, we cannot request permissions.');
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
  // Simulate network delay
  await Future.delayed(const Duration(milliseconds: 500));

  // Return mock friend locations
  return [
    FriendLocation(
      id: '1',
      name: 'Alice (Tokyo)',
      latitude: 35.6762,
      longitude: 139.6503,
    ),
    FriendLocation(
      id: '2',
      name: 'Bob (London)',
      latitude: 51.5074,
      longitude: -0.1278,
    ),
    FriendLocation(
      id: '3',
      name: 'Charlie (NY)',
      latitude: 40.7128,
      longitude: -74.0060,
    ),
    FriendLocation(
      id: '4',
      name: 'Diana (Sydney)',
      latitude: -33.8688,
      longitude: 151.2093,
    ),
  ];
}
