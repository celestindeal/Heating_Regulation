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
  bool init = false;
  Appartement appartement = Appartement(
      fonctionnement: true,
      temperatureVoulu: '',
      fonctionnementGeneral: 0,
      heure: '',
      mode: '',
      temperature: '');

  @override
  Future _init() async {
    await appartement.refresh();
    setState(() {
      appartement;
    });
    Duration(seconds: 3);
  }

  Widget build(BuildContext context) {
    if (!init) _init();

    return Scaffold(
        appBar: AppBar(
          title: const Text('Chauffage villeurbanne'),
          actions: [
            // Switch(
            //   value: isSwitched,
            //   onChanged: (value) {
            //     if (value) {
            //       fetchAppartementFonctionnementGeneralON();
            //     } else {
            //       fetchAppartementFonctionnementGeneralOFF();
            //     }
            //     setState(() {
            //       isSwitched = value;
            //     });
            //   },
            //   activeColor: Colors.white,
            // ),
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Fonctionnement Général : "),
            Text(
              appartement.fonctionnementGeneral.toString(),
              style: Theme.of(context).textTheme.headline6,
            ),
            Text("Le radiateur fonctionne : "),
            Text(
              appartement.fonctionnement.toString(),
              style: Theme.of(context).textTheme.headline6,
            ),
            Text("La températur actuel : "),
            Text(
              appartement.temperature.toString(),
              style: Theme.of(context).textTheme.headline6,
            ),
            Text("La temperature voulu : "),
            Text(
              appartement.temperatureVoulu.toString(),
              style: Theme.of(context).textTheme.headline6,
            ),
            Text("Le mode de fonctionnement : "),
            Text(
              appartement.mode.toString(),
              style: Theme.of(context).textTheme.headline6,
            ),
            Text("L'heure de fonctionnement : "),
            Text(
              appartement.heure.toString(),
              style: Theme.of(context).textTheme.headline6,
            ),
          ],
        ));
  }
}
