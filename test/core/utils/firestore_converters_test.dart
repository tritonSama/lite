import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hblite/core/utils/firestore_converters.dart';

void main() {
  group('TimestampConverter', () {
    const converter = TimestampConverter();

    test('toJson converts DateTime to Timestamp correctly', () {
      final dateTime = DateTime.utc(2023, 10, 15, 12, 30, 45, 123, 456);
      final timestamp = converter.toJson(dateTime);

      expect(timestamp.seconds, 1697373045);
      expect(timestamp.nanoseconds, 123456000); // 123ms + 456µs
    });

    test('fromJson converts Timestamp to DateTime correctly', () {
      final timestamp = Timestamp(1697373045, 123456000);
      final dateTime = converter.fromJson(timestamp);

      expect(dateTime.isUtc, false);
      expect(dateTime.toUtc(), DateTime.utc(2023, 10, 15, 12, 30, 45, 123, 456));
    });

    test('maintains microsecond precision (Dart DateTime limit)', () {
      // DateTime has microsecond precision, Timestamp has nanosecond precision
      final dt = DateTime.utc(2024, 1, 1, 0, 0, 0, 123, 456);
      final ts = converter.toJson(dt);
      final convertedBackDt = converter.fromJson(ts);

      expect(convertedBackDt.toUtc(), dt);
      expect(ts.nanoseconds, 123456000); // 123 ms, 456 us -> 123456000 ns
    });

    test('handles extreme early dates correctly', () {
      final earlyDate = DateTime.utc(1900, 1, 1);
      final timestamp = converter.toJson(earlyDate);
      final convertedBack = converter.fromJson(timestamp);

      expect(convertedBack.toUtc(), earlyDate);
    });

    test('handles extreme late dates correctly', () {
      final lateDate = DateTime.utc(2100, 12, 31, 23, 59, 59);
      final timestamp = converter.toJson(lateDate);
      final convertedBack = converter.fromJson(timestamp);

      expect(convertedBack.toUtc(), lateDate);
    });
  });

  group('GeoPointConverter', () {
    const converter = GeoPointConverter();

    test('toJson converts GeoPoint to Map correctly', () {
      const geoPoint = GeoPoint(37.7749, -122.4194);
      final jsonMap = converter.toJson(geoPoint);

      expect(jsonMap['lat'], 37.7749);
      expect(jsonMap['lng'], -122.4194);
    });

    test('fromJson converts Map to GeoPoint correctly', () {
      final jsonMap = {'lat': 37.7749, 'lng': -122.4194};
      final geoPoint = converter.fromJson(jsonMap);

      expect(geoPoint.latitude, 37.7749);
      expect(geoPoint.longitude, -122.4194);
    });

    test('fromJson handles integer inputs properly (API edge case)', () {
      final jsonMap = {'lat': 37, 'lng': -122};
      final geoPoint = converter.fromJson(jsonMap);

      expect(geoPoint.latitude, 37.0);
      expect(geoPoint.longitude, -122.0);
    });

    test('handles extreme coordinates correctly', () {
      // Valid GeoPoint latitudes are [-90, 90] and longitudes are [-180, 180]
      final extremeMap = {'lat': -90.0, 'lng': 180.0};
      final geoPoint = converter.fromJson(extremeMap);
      final convertedBack = converter.toJson(geoPoint);

      expect(convertedBack['lat'], -90.0);
      expect(convertedBack['lng'], 180.0);
    });
  });
}
