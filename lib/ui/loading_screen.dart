import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/services/openweathermap_api.dart';

import '../services/geolocation_service.dart';
import 'search_page.dart';
import 'weather_page.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    getLocationData();
  }

  void getLocationData() async {
    final geolocationService = context.read<GeolocationService>();

    final geolocationStatus = await geolocationService.checkStatus();

    if (geolocationStatus == GeolocationStatus.available) {
      final position = await geolocationService.getCurrentPosition();

      if (position != null && mounted) {
        final locationName = await context
            .read<OpenWeatherMapApi>()
            .getLocationName(position.latitude, position.longitude);

        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => WeatherPage(
                locationName: locationName ?? 'À votre position',
                latitude: position.latitude,
                longitude: position.longitude,
              ),
            ),
          );
        }

        return;
      }
    }

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => SearchPage(
            lastGeolocationStatus: geolocationStatus,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: const CircularProgressIndicator(),
    );
  }
}
