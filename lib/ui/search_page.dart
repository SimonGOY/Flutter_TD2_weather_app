import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/location.dart';
import '../services/geolocation_service.dart';
import '../services/openweathermap_api.dart';
import 'weather_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({
    this.lastGeolocationStatus,
    super.key,
  });

  final GeolocationStatus? lastGeolocationStatus;

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String query = '';

  Future<Iterable<Location>>? locationsSearchResults;

  @override
  Widget build(BuildContext context) {
    final openWeatherMapApi = context.read<OpenWeatherMapApi>();
    final mq = MediaQuery.of(context);
    final theme = Theme.of(context);

    final padding = EdgeInsets.symmetric(
      horizontal: max(mq.size.width * 0.1, 24),
    );

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Recherche'),
        ),
        body: SingleChildScrollView(
            child: Column(children: [
          Padding(
            padding: padding,
            child: TextField(
              onChanged: (value) {
                query = value.trim();
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  locationsSearchResults =
                      openWeatherMapApi.searchLocations(query);
                });
              },
              child: const Text('Rechercher'),
            ),
          ),
          if (query.isEmpty)
            Text(
              'Saisissez une ville dans la barre de recherche.',
              style: theme.textTheme.bodyMedium!.copyWith(
                fontStyle: FontStyle.italic,
              ),
            )
          else
            FutureBuilder(
              future: locationsSearchResults,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }

                if (snapshot.hasError) {
                  return Text(
                    'Une erreur est survenue.\n${snapshot.error}',
                    style: theme.textTheme.bodyMedium!.copyWith(
                      color: theme.colorScheme.error,
                      fontStyle: FontStyle.italic,
                    ),
                  );
                }

                if (!snapshot.hasData) {
                  return Text(
                    'Aucun résultat pour cette recherche.',
                    style: theme.textTheme.bodyMedium!.copyWith(
                      fontStyle: FontStyle.italic,
                    ),
                  );
                }

                return Column(
                  children: [
                    for (final location in snapshot.data!)
                      ListTile(
                        contentPadding: padding,
                        title: Text('${location.name} (${location.country})'),
                        subtitle: Text('${location.lat}, ${location.lon}'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                              builder: (BuildContext context) => WeatherPage(
                                locationName: location.name,
                                latitude: location.lat,
                                longitude: location.lon,
                              ),
                            ),
                          );
                        },
                      ),
                  ],
                );
              },
            ),
        ])));
  }
}
