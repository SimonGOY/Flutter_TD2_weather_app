import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/services/openweathermap_api.dart';

class SearchPage extends StatefulWidget {
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String query = '';
  

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
                  print(query);
                },
                child: const Text("Rechercher"),
              ),
            ),
           Expanded(
              child: FutureBuilder(
                future: openWeatherMapApi.searchLocations(query),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Text('Une erreur est survenue.\n${snapshot.error}');
                  }

                  if (!snapshot.hasData || (snapshot.data as Iterable).isEmpty) {
                    return const Text('Aucun résultat pour cette recherche.');
                  }

                  // Afficher les résultats dans un ListView
                  return ListView.builder(
                    itemCount: (snapshot.data as Iterable).length,
                    itemBuilder: (context, index) {
                      // Récupérer chaque objet Location à partir de snapshot.data
                      var location = (snapshot.data as Iterable).elementAt(index);

                      // Afficher les informations de la location dans un ListTile, par exemple
                      return ListTile(
                        title: Text(location.name),
                        subtitle: Text('${location.lat}, ${location.lon}'),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
