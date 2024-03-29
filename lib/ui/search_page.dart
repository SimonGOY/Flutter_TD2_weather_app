import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/models/location.dart';
import 'package:weather_app/services/openweathermap_api.dart';
import 'package:weather_app/ui/weather_page.dart';

class SearchPage extends StatefulWidget {
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String query = '';
  Future<Iterable<Location>>? locationsSearchResults;
  

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var openWeatherMapApi = context.read<OpenWeatherMapApi>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recherche'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
        child: Column(
          children: [
            TextField(onChanged: (value) {
              setState(() {
                query = value;
              });
            }),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    locationsSearchResults = openWeatherMapApi.searchLocations(query);
                  });
                },
                child: const Text("Rechercher"),
              ),
            ),

            if (query.isEmpty)
              const Text('Saisissez une ville dans la barre de recherche.')
            else
            
            FutureBuilder(
              future: locationsSearchResults ,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Text('Une erreur est survenue.\n${snapshot.error}');
                }

                if (!snapshot.hasData || (snapshot.data as List<Location>).isEmpty) {
                  return const Text('Aucun résultat pour cette recherche.');
                }

                // Afficher les résultats dans des ListTiles
                return Expanded(
                  child: ListView.builder(
                    itemCount: (snapshot.data as List<Location>).length,
                    itemBuilder: (context, index) {
                      var location = (snapshot.data as List<Location>)[index];
                      return ListTile(
                        title: Text(location.name),
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
                      );
                    },
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
