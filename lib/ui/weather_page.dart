
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/config.dart';
import 'package:weather_app/models/weather.dart';
import 'package:weather_app/services/openweathermap_api.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({
    required this.locationName,
    required this.latitude,
    required this.longitude,
    Key? key,
  }) : super(key: key);

  final String locationName;
  final double latitude;
  final double longitude;

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  @override
  Widget build(BuildContext context) {
    var openWeatherMapApi = context.read<OpenWeatherMapApi>();
    return Scaffold(
      appBar: AppBar(
        title: Text('Météo à ${widget.locationName}'),
      ),
      body: FutureBuilder(
        future: openWeatherMapApi.getWeather(widget.latitude, widget.longitude),
        builder: (context, AsyncSnapshot<Weather> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Erreur: ${snapshot.error}',
                style: TextStyle(color: Colors.red),
              ),
            );
          }

          if (!snapshot.hasData) {
            return Center(
              child: Text(
                'Aucune donnée disponible.',
                style: TextStyle(color: Colors.grey),
              ),
            );
          }

          final weather = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${weather.desc}',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${weather.temp.toStringAsFixed(1)}°C',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Center(
                  child: Image.network(
                    openWeatherMapApi.getIconUrl(weather.icon),
                    width: 200, // Augmentez la largeur de l'image
                    height: 200, // Augmentez la hauteur de l'image
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
