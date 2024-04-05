import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../models/location.dart';
import '../models/weather.dart';

class OpenWeatherMapApi {
  OpenWeatherMapApi({
    required this.apiKey,
    this.units = 'metric',
    this.lang = 'fr',
  });

  static const String baseUrl = 'https://api.openweathermap.org';

  final String apiKey;
  final String units;
  final String lang;

  Future<Weather> getWeather(double lat, double lon) async {
    final response = await http.get(
      Uri.parse(
        '$baseUrl/data/2.5/weather?appid=$apiKey&lat=$lat&lon=$lon&units=$units&lang=$lang',
      ),
    );

    if (response.statusCode == HttpStatus.ok) {
      return Weather.fromJson(json.decode(response.body));
    }

    throw Exception(
        'Impossible de récupérer les données météo (HTTP ${response.statusCode})');
  }

  Future<Iterable<Weather>> get5DaysWeather(double lat, double lon,
      {int limit = 8}) async {
    final response = await http.get(
      Uri.parse(
        '$baseUrl/data/2.5/forecast?appid=$apiKey&lat=$lat&lon=$lon&cnt=$limit&units=$units&lang=$lang',
      ),
    );

    if (response.statusCode == HttpStatus.ok) {
      final data = json.decode(response.body) as Map<String, dynamic>;
      return (data['list'] as List<dynamic>).map((e) => Weather.fromJson(e));
    }

    throw Exception(
        'Impossible de récupérer les données météo (HTTP ${response.statusCode})');
  }

  Future<Iterable<Location>> searchLocations(
    String query, {
    int limit = 5,
  }) async {
    final response = await http.get(
      Uri.parse('$baseUrl/geo/1.0/direct?appid=$apiKey&q=$query&limit=$limit'),
    );

    if (response.statusCode == HttpStatus.ok) {
      return (json.decode(response.body) as List<dynamic>)
          .map((e) => Location.fromJson(e));
    }

    throw Exception(
        'Impossible de récupérer les données de localisation (HTTP ${response.statusCode})');
  }

  Future<String?> getLocationName(double lat, double lon) async {
    final response = await http.get(
      Uri.parse(
          '$baseUrl/geo/1.0/reverse?appid=$apiKey&lat=$lat&lon=$lon&limit=1'),
    );

    if (response.statusCode == HttpStatus.ok) {
      return (json.decode(response.body) as List<dynamic>).firstOrNull?["name"];
    }

    throw Exception(
        'Impossible de récupérer les données de localisation (HTTP ${response.statusCode})');
  }

  String getIconUrl(String icon, OpenWeatherMapIconSize size) {
    return 'https://openweathermap.org/img/wn/$icon$size.png';
  }
}

class OpenWeatherMapIconSize {
  static const small = OpenWeatherMapIconSize._("");
  static const medium = OpenWeatherMapIconSize._("@2x");
  static const large = OpenWeatherMapIconSize._("@4x");

  const OpenWeatherMapIconSize._(this._size);

  final String _size;

  @override
  String toString() {
    return _size;
  }
}
