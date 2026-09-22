import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../app/theme.dart';
import '../../board/presentation/local_offerings_provider.dart';

class GamePage extends ConsumerStatefulWidget {
  const GamePage({super.key});

  @override
  ConsumerState<GamePage> createState() => _GamePageState();
}

class _GamePageState extends ConsumerState<GamePage> {
  final LatLng _initialPosition = const LatLng(37.7749, -122.4194); // SF for demo

  Map<String, dynamic>? _selectedQuest;

  void _onMapCreated(GoogleMapController controller) {
    // Controller can be used for animations later
  }

  final String _mapStyle = '''
      [
        {
          "elementType": "geometry",
          "stylers": [
            {
              "color": "#212121"
            }
          ]
        },
        {
          "elementType": "labels.icon",
          "stylers": [
            {
              "visibility": "off"
            }
          ]
        },
        {
          "elementType": "labels.text.fill",
          "stylers": [
            {
              "color": "#757575"
            }
          ]
        },
        {
          "elementType": "labels.text.stroke",
          "stylers": [
            {
              "color": "#212121"
            }
          ]
        },
        {
          "featureType": "administrative",
          "elementType": "geometry",
          "stylers": [
            {
              "color": "#757575"
            }
          ]
        },
        {
          "featureType": "administrative.country",
          "elementType": "labels.text.fill",
          "stylers": [
            {
              "color": "#9e9e9e"
            }
          ]
        },
        {
          "featureType": "administrative.land_parcel",
          "stylers": [
            {
              "visibility": "off"
            }
          ]
        },
        {
          "featureType": "administrative.locality",
          "elementType": "labels.text.fill",
          "stylers": [
            {
              "color": "#bdbdbd"
            }
          ]
        },
        {
          "featureType": "poi",
          "elementType": "labels.text.fill",
          "stylers": [
            {
              "color": "#757575"
            }
          ]
        },
        {
          "featureType": "poi.park",
          "elementType": "geometry",
          "stylers": [
            {
              "color": "#181818"
            }
          ]
        },
        {
          "featureType": "poi.park",
          "elementType": "labels.text.fill",
          "stylers": [
            {
              "color": "#616161"
            }
          ]
        },
        {
          "featureType": "poi.park",
          "elementType": "labels.text.stroke",
          "stylers": [
            {
              "color": "#1b1b1b"
            }
          ]
        },
        {
          "featureType": "road",
          "elementType": "geometry.fill",
          "stylers": [
            {
              "color": "#2c2c2c"
            }
          ]
        },
        {
          "featureType": "road",
          "elementType": "labels.text.fill",
          "stylers": [
            {
              "color": "#8a8a8a"
            }
          ]
        },
        {
          "featureType": "road.arterial",
          "elementType": "geometry",
          "stylers": [
            {
              "color": "#373737"
            }
          ]
        },
        {
          "featureType": "road.highway",
          "elementType": "geometry",
          "stylers": [
            {
              "color": "#3c3c3c"
            }
          ]
        },
        {
          "featureType": "road.highway.controlled_access",
          "elementType": "geometry",
          "stylers": [
            {
              "color": "#4e4e4e"
            }
          ]
        },
        {
          "featureType": "road.local",
          "elementType": "labels.text.fill",
          "stylers": [
            {
              "color": "#616161"
            }
          ]
        },
        {
          "featureType": "transit",
          "elementType": "labels.text.fill",
          "stylers": [
            {
              "color": "#757575"
            }
          ]
        },
        {
          "featureType": "water",
          "elementType": "geometry",
          "stylers": [
            {
              "color": "#000000"
            }
          ]
        },
        {
          "featureType": "water",
          "elementType": "labels.text.fill",
          "stylers": [
            {
              "color": "#3d3d3d"
            }
          ]
        }
      ]
    ''';

  @override
  Widget build(BuildContext context) {
    final offeringsAsync = ref.watch(localOfferingsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Reality RPG Map')),
      body: Stack(
        children: [
          offeringsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Map Error: $e')),
            data: (offerings) {
              final Set<Marker> markers = {};

              // Generate some random offsets for demo purposes based on initial position
              double latOffset = 0.0;
              double lngOffset = 0.0;

              for (int i = 0; i < offerings.length; i++) {
                final o = offerings[i];
                // Demo positions
                latOffset += 0.005;
                if (i % 2 == 0) {
                  lngOffset -= 0.005;
                } else {
                  lngOffset += 0.01;
                }

                final pos = LatLng(_initialPosition.latitude + latOffset, _initialPosition.longitude + lngOffset);

                markers.add(
                  Marker(
                    markerId: MarkerId(o['id'].toString()),
                    position: pos,
                    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan),
                    onTap: () {
                      setState(() {
                        _selectedQuest = o;
                      });
                    },
                  )
                );
              }

              return GoogleMap(
                onMapCreated: _onMapCreated,
                style: _mapStyle,
                initialCameraPosition: CameraPosition(
                  target: _initialPosition,
                  zoom: 13,
                ),
                markers: markers,
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                onTap: (_) {
                  setState(() => _selectedQuest = null);
                },
              );
            }
          ),

          if (_selectedQuest != null)
            Positioned(
              bottom: 24,
              left: 16,
              right: 16,
              child: _QuestCard(offering: _selectedQuest!),
            ),

          // AR HUD overlay mock
          Positioned(
            top: 16,
            left: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: HBColors.primary.withValues(alpha: 0.5)),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.gps_fixed, color: HBColors.primary, size: 16),
                  SizedBox(width: 8),
                  Text('SCANNING LOCAL AREA...', style: TextStyle(color: HBColors.primary, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuestCard extends StatelessWidget {
  final Map<String, dynamic> offering;

  const _QuestCard({required this.offering});

  @override
  Widget build(BuildContext context) {
    final dataStr = offering['data'] as String;
    String title = "Unknown";
    String description = "No description";
    String bounty = "0";

    try {
      final decoded = jsonDecode(dataStr) as Map<String, dynamic>;
      title = decoded['title']?.toString() ?? "Unknown";
      description = decoded['description']?.toString() ?? "No description";
      bounty = decoded['bounty']?.toString() ?? "0";
    } catch (_) {}

    return Card(
      color: const Color(0xFF0C0F1D).withValues(alpha: 0.95),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: HBColors.primary, width: 1.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'NEW QUEST AVAILABLE',
                    style: TextStyle(
                      color: Colors.amber,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                Text('Lvl 3', style: TextStyle(color: Colors.grey[400])),
              ],
            ),
            const Divider(color: HBColors.primary),
            Text(title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(description, maxLines: 2, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.attach_money, color: Colors.green, size: 18),
                    Text(bounty, style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 16)),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: HBColors.primary,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('ACCEPT QUEST'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
