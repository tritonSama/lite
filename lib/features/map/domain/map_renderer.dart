import 'package:flutter/widgets.dart';

/// The abstract MapRenderer allows the app to swap between Google Maps,
/// OpenStreetMaps, or the future Fluorescent 3D Engine without changing
/// the UI layer consuming the map.
abstract class MapRenderer {
  Widget buildMap();
}
