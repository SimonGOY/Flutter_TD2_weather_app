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
    super.key,
  });

  final String locationName;
  final double latitude;
  final double longitude;

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var openWeatherMapApi = context.read<OpenWeatherMapApi>();
    return Scaffold(
      body: FutureBuilder(
        future: openWeatherMapApi.getWeather(widget.latitude, widget.longitude),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Text('Une erreur est survenue.\n${snapshot.error}');
          }

          if (!snapshot.hasData) {
            return const Text('Aucun résultat pour cette recherche.');
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(openWeatherMapApi.getIconUrl(snapshot.data!.icon)),
              Text('${snapshot.data!.desc}'),
              Text('${snapshot.data!.icon}'),
              Text('${snapshot.data!.temp.toStringAsFixed(2)}'),
            ],
          );
        },
      ),
    );
  }
}