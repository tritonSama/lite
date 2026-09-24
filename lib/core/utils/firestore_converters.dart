import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

/// Converts Firestore [GeoPoint] ↔ `{lat, lng}` JSON map.
class GeoPointConverter
    implements JsonConverter<GeoPoint, Map<String, dynamic>> {
  const GeoPointConverter();

  @override
  GeoPoint fromJson(Map<String, dynamic> json) {
    if (!json.containsKey('lat') ||
        json['lat'] == null ||
        !json.containsKey('lng') ||
        json['lng'] == null) {
      throw const FormatException("Missing 'lat' or 'lng'");
    }
    if (json['lat'] is! num) {
      throw const FormatException("Invalid type for 'lat', expected num");
    }
    if (json['lng'] is! num) {
      throw const FormatException("Invalid type for 'lng', expected num");
    }
    return GeoPoint(
      (json['lat'] as num).toDouble(),
      (json['lng'] as num).toDouble(),
    );
  }

  @override
  Map<String, dynamic> toJson(GeoPoint g) => {
    'lat': g.latitude,
    'lng': g.longitude,
  };
}

/// Converts Firestore [Timestamp] ↔ [DateTime].
class TimestampConverter implements JsonConverter<DateTime, Timestamp> {
  const TimestampConverter();

  @override
  DateTime fromJson(Timestamp ts) => ts.toDate();

  @override
  Timestamp toJson(DateTime dt) => Timestamp.fromDate(dt);
}
