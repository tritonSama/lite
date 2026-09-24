import 'dart:convert';
import 'dart:io';

import '../domain/weather_data.dart';

class WeatherService {
  static const _apiKey = '6c02013dcee8fb5ebb3c0f8ad799a0d4';
  static const _cacheDuration = Duration(minutes: 10);

  WeatherData? _cachedData;
  DateTime? _lastFetch;

  Future<WeatherData?> fetchWeather(double lat, double lng) async {
    if (_cachedData != null && _lastFetch != null) {
      if (DateTime.now().difference(_lastFetch!) < _cacheDuration) {
        return _cachedData;
      }
    }

    try {
      final url = Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lng&appid=$_apiKey&units=imperial',
      );
      final client = HttpClient();
      final request = await client.getUrl(url);
      final response = await request.close();

      if (response.statusCode == 200) {
        final responseBody = await response.transform(utf8.decoder).join();
        final json = jsonDecode(responseBody) as Map<String, dynamic>;

        final weather = json['weather'][0];
        final main = json['main'];
        final wind = json['wind'];

        final data = WeatherData(
          temperature: (main['temp'] as num).toDouble(),
          description: weather['description'] as String,
          icon: weather['icon'] as String,
          humidity: (main['humidity'] as num).toInt(),
          windSpeed: (wind['speed'] as num).toDouble(),
          cityName: json['name'] as String,
        );

        _cachedData = data;
        _lastFetch = DateTime.now();

        return data;
      }
    } catch (e) {
      // Return null on failure
    }

    return null;
  }
}
