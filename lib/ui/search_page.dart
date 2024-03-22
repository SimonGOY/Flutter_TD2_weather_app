import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  @override
  State<SearchPage> createState() => _SearchPage();
}

class _SearchPage extends State<SearchPage> {
  String query = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recherche'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
        child: Column(children: [
          TextField(onChanged: (value) {
            query = value;
          }),
          ElevatedButton(
              onPressed: () {
                print(query);
              },
              child: const Text("Rechercher")),
        ]),
      ),
    );
  }
}
