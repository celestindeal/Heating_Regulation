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
  bool isSwitched = false;

  Future<Appartement> fetchAppartement() async {
    final response = await http.get(Uri.parse(Variable.url));
    bool fonctionnement = false;

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

  Future<Appartement> fetchAppartementFonctionnementGeneralON() async {
    final response =
        await http.get(Uri.parse(Variable.urlFonctionnementGeneralON));
    if (response.statusCode == 200) {
      return Appartement.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load album');
    }
  }

  Future<Appartement> fetchAppartementFonctionnementGeneralOFF() async {
    final response =
        await http.get(Uri.parse(Variable.urlFonctionnementGeneralOFF));
    if (response.statusCode == 200) {
      return Appartement.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load album');
    }
  }

  @override
  void initState() {
    super.initState();
    futureAlbum = fetchAppartement();
  }

  void refreshList() {
    // reload
    log("message");
    setState(() {
      futureAlbum = fetchAppartement();
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Chauffage villeurbanne'),
          actions: [
            Switch(
              value: isSwitched,
              onChanged: (value) {
                if (value) {
                  fetchAppartementFonctionnementGeneralON();
                } else {
                  fetchAppartementFonctionnementGeneralOFF();
                }
                setState(() {
                  isSwitched = value;
                });
              },
              activeColor: Colors.white,
            ),
          ],
        ),
        body: isSwitched
            ? FutureBuilder<Appartement>(
                future: futureAlbum,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Fonctionnement Général : "),
                        Text(
                          snapshot.data!.fonctionnementGeneral.toString(),
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        Text("Le radiateur fonctionne : "),
                        Text(
                          snapshot.data!.fonctionnement.toString(),
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        Text("La températur actuel : "),
                        Text(
                          snapshot.data!.temperature.toString(),
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        Text("La temperature voulu : "),
                        Text(
                          snapshot.data!.temperatureVoulu.toString(),
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        Text("Le mode de fonctionnement : "),
                        Text(
                          snapshot.data!.mode.toString(),
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        Text("L'heure de fonctionnement : "),
                        Text(
                          snapshot.data!.heure.toString(),
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      ],
                    );
                  } else if (snapshot.hasError) {
                    log("Error: ${snapshot.error}");
                    return Text('${snapshot.error}');
                  }

                  // By default, show a loading spinner.
                  return const CircularProgressIndicator();
                },
              )
            : Container());
  }
}
