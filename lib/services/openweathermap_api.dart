import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:weather_app/models/weather.dart';

import '../models/location.dart';

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

  String getIconUrl(String icon) {
    return 'https://openweathermap.org/img/wn/$icon@4x.png';
  }

  Future<Iterable<Location>> searchLocations(
    String query, {
    int limit = 5,
  }) async {
    final response = await http.get(
      Uri.parse('$baseUrl/geo/1.0/direct?appid=$apiKey&q=$query&limit=$limit'),
    );

    if (response.statusCode == HttpStatus.ok) {
      var jsonList = jsonDecode(response.body);
      List<Location> locations = [];

      for (var jsonLocation in jsonList) {
        locations.add(Location.fromJson(jsonLocation));
      }

      return locations;
    }

    throw Exception('Impossible de récupérer les données de localisation (HTTP ${response.statusCode})');
  }

  Future<Weather> getWeather(double lat, double lon) async {
  final response = await http.get(
    Uri.parse(
      '$baseUrl/data/2.5/weather?appid=$apiKey&lat=$lat&lon=$lon&units=$units&lang=$lang',
    ),
  );

  if (response.statusCode == HttpStatus.ok) {
    var jsonMap = jsonDecode(response.body);
    Weather weather = Weather.fromJson(jsonMap);
    return weather;
  }

  throw Exception(
      'Impossible de récupérer les données météo (HTTP ${response.statusCode})');
}

  
}
