import 'dart:convert';
import 'package:flutter_application_1/Variable.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Appartement.dart';
import 'dart:developer';

class Accueil extends StatefulWidget {
  @override
  State<Accueil> createState() => _AccueilState();
}

class _AccueilState extends State<Accueil> {
  late Future<Appartement> futureAlbum;

  Future<Appartement> fetchAppartement() async {
  final response = await http
      .get(Uri.parse(Variable.url));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Appartement.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}
  @override
   void initState() {
    super.initState();
    futureAlbum = fetchAppartement();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('First Screen'),
      ),
      body: Center(
        child: Column(
          children: [
            FutureBuilder<Appartement>(
              future: futureAlbum,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: [
                      Text(snapshot.data!.fonctionnement.toString()),
                      Text(snapshot.data!.temperature.toString()),
                      Text(snapshot.data!.temperatureVoulu.toString()),
                      Text(snapshot.data!.mode.toString()),
                      Text(snapshot.data!.heure.toString()),
                    ],
                  );
                } else if (snapshot.hasError) {
                  log("Error: ${snapshot.error}");
                  return Text('${snapshot.error}');
                }

                // By default, show a loading spinner.
                return const CircularProgressIndicator();
              },
            ),
            ElevatedButton(
              onPressed: () {
              },
              child:  Text("Hello World"),
            ),
          ],
        ),
      ),
    );
  }
}
