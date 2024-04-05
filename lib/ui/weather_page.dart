import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/ui/weather_item.dart';

import '../services/openweathermap_api.dart';
import 'search_page.dart';

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
  final _horizontalScrollController = ScrollController();

  FutureBuilder weatherFutureBuilder<T>({
    required Future<T> future,
    required ValueWidgetBuilder<T> builder,
  }) {
    return FutureBuilder(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        final theme = Theme.of(context);

        if (snapshot.hasError) {
          return Text(
            'Une erreur est survenue.\n${snapshot.error?.toString()}',
            style: theme.textTheme.bodyMedium!.copyWith(
              color: theme.colorScheme.error,
              fontStyle: FontStyle.italic,
            ),
          );
        }

        if (!snapshot.hasData) {
          return Text(
            'Aucune donnée disponible à cet emplacement.',
            style: theme.textTheme.bodyMedium!.copyWith(
              fontStyle: FontStyle.italic,
            ),
          );
        }

        return builder(context, snapshot.data!, null);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final openWeatherMapApi = context.read<OpenWeatherMapApi>();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Météo à ${widget.locationName}'),
        actions: [
          TextButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchPage()),
              );
            },
            icon: const Icon(Icons.search),
            label: const Text('Rechercher'),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(8),
        alignment: Alignment.center,
        child: Column(
          children: [
            weatherFutureBuilder(
              future: openWeatherMapApi.getWeather(
                widget.latitude,
                widget.longitude,
              ),
              builder: (context, data, _) {
                return WeatherBlock(data);
              },
            ),
            const SizedBox(height: 16),
            weatherFutureBuilder(
              future: openWeatherMapApi.get5DaysWeather(
                widget.latitude,
                widget.longitude,
              ),
              builder: (context, data, _) {
                return CustomScrollbarWithSingleChildScrollView(
                  controller: _horizontalScrollController,
                  scrollDirection: Axis.horizontal,
                  child: IntrinsicHeight(
                    child: Row(
                      children: [
                        for (var weather in data) WeatherTile(weather),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class CustomScrollbarWithSingleChildScrollView extends StatelessWidget {
  const CustomScrollbarWithSingleChildScrollView({
    required this.controller,
    required this.child,
    required this.scrollDirection,
    super.key,
  });

  final ScrollController controller;
  final Widget child;
  final Axis scrollDirection;

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: const CustomScrollBehavior(),
      child: Scrollbar(
        controller: controller,
        child: SingleChildScrollView(
          controller: controller,
          scrollDirection: scrollDirection,
          child: child,
        ),
      ),
    );
  }
}

class CustomScrollBehavior extends MaterialScrollBehavior {
  const CustomScrollBehavior();

  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.stylus,
        PointerDeviceKind.unknown,
      };
}
