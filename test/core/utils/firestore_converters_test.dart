import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hblite/core/utils/firestore_converters.dart';

void main() {
  group('GeoPointConverter', () {
    const converter = GeoPointConverter();

    test('fromJson returns GeoPoint for valid double data', () {
      final json = {'lat': 37.7749, 'lng': -122.4194};
      final result = converter.fromJson(json);

      expect(result.latitude, 37.7749);
      expect(result.longitude, -122.4194);
    });

    test('fromJson returns GeoPoint for valid int data', () {
      final json = {'lat': 37, 'lng': -122};
      final result = converter.fromJson(json);

      expect(result.latitude, 37.0);
      expect(result.longitude, -122.0);
    });

    test('fromJson throws FormatException for missing lat', () {
      final json = {'lng': -122.4194};
      expect(
        () => converter.fromJson(json),
        throwsA(isA<FormatException>().having((e) => e.message, 'message', "Missing 'lat' or 'lng'")),
      );
    });

    test('fromJson throws FormatException for missing lng', () {
      final json = {'lat': 37.7749};
      expect(
        () => converter.fromJson(json),
        throwsA(isA<FormatException>().having((e) => e.message, 'message', "Missing 'lat' or 'lng'")),
      );
    });

    test('fromJson throws FormatException for null lat', () {
      final json = {'lat': null, 'lng': -122.4194};
      expect(
        () => converter.fromJson(json),
        throwsA(isA<FormatException>().having((e) => e.message, 'message', "Missing 'lat' or 'lng'")),
      );
    });

    test('fromJson throws FormatException for null lng', () {
      final json = {'lat': 37.7749, 'lng': null};
      expect(
        () => converter.fromJson(json),
        throwsA(isA<FormatException>().having((e) => e.message, 'message', "Missing 'lat' or 'lng'")),
      );
    });

    test('fromJson throws FormatException for invalid lat type', () {
      final json = {'lat': '37.7749', 'lng': -122.4194};
      expect(
        () => converter.fromJson(json),
        throwsA(isA<FormatException>().having((e) => e.message, 'message', "Invalid type for 'lat', expected num")),
      );
    });

    test('fromJson throws FormatException for invalid lng type', () {
      final json = {'lat': 37.7749, 'lng': '-122.4194'};
      expect(
        () => converter.fromJson(json),
        throwsA(isA<FormatException>().having((e) => e.message, 'message', "Invalid type for 'lng', expected num")),
      );
    });

    test('toJson returns correct Map for GeoPoint', () {
      const geoPoint = GeoPoint(37.7749, -122.4194);
      final result = converter.toJson(geoPoint);

      expect(result, {'lat': 37.7749, 'lng': -122.4194});
    });
  });

  group('TimestampConverter', () {
    const converter = TimestampConverter();

    test('fromJson converts Timestamp to DateTime (local timezone by default in Timestamp)', () {
      // Use local datetime to match how Timestamp.toDate() typically returns local time
      final date = DateTime(2023, 10, 1, 12, 0, 0);
      final timestamp = Timestamp.fromDate(date);

      final result = converter.fromJson(timestamp);

      expect(result, date);
    });

    test('toJson converts DateTime to Timestamp', () {
      final date = DateTime(2023, 10, 1, 12, 0, 0);
      final expectedTimestamp = Timestamp.fromDate(date);

      final result = converter.toJson(date);

      expect(result.seconds, expectedTimestamp.seconds);
      expect(result.nanoseconds, expectedTimestamp.nanoseconds);
    });
  });
}
