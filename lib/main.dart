import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/ui/search_page.dart';

void main() {
  runApp(
    const WeatherApp(),
  );
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData.dark(),
      home: SearchPage(),
    );
  }
}
