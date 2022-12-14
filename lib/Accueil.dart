import 'dart:convert';
import 'package:flutter_application_1/Variable.dart';
import 'package:flutter_application_1/fonction.dart';
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
      fonctionnement: '',
      temperatureVoulu: '',
      fonctionnementGeneral: '',
      heure: '',
      mode: '',
      temperature: '');
  List<bool> _selections = List.generate(7, (_) => false);
  List<String> listTemperature = <String>[
    '18',
    '18.5',
    '19',
    '19.5',
    '20',
    '20.5',
    '21'
  ];

  @override
  Future _init() async {
    await appartement.refresh();
    setState(() {
      appartement;
    });
    init = true;
  }

  Widget build(BuildContext context) {
    if (!init) _init();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chauffage villeurbanne'),
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
          ElevatedButton(
            child: Text(
              'Mise a jours',
            ),
            style: ElevatedButton.styleFrom(
              onPrimary: Colors.white,
            ),
            onPressed: () async {
              await appartement.refresh();
              setState(() {
                appartement;
              });
            },
          ),
          ToggleButtons(
            children: <Widget>[
              Text('18'),
              Text('18.5'),
              Text('19'),
              Text('19.5'),
              Text('20'),
              Text('20.5'),
              Text('21'),
            ],
            isSelected: _selections,
            onPressed: (int index) async {
              await appartement
                  .fetchAppartementReglageTemperature(listTemperature[index]);
              setState(() {
                for (int buttonIndex = 0;
                    buttonIndex < _selections.length;
                    buttonIndex++) {
                  if (buttonIndex == index) {
                    _selections[buttonIndex] = true;
                  } else {
                    _selections[buttonIndex] = false;
                  }
                }
              });
            },
          ),
          Row(
            children: [
              ElevatedButton(
                child: Text(
                  'ON',
                ),
                style: ElevatedButton.styleFrom(
                  onPrimary: Colors.white,
                ),
                onPressed: () async {
                  await appartement.fetchAppartementFonctionnementGeneralON();
                  setState(() {
                    appartement;
                  });
                },
              ),
              ElevatedButton(
                child: Text(
                  'OFF',
                ),
                style: ElevatedButton.styleFrom(
                  onPrimary: Colors.white,
                ),
                onPressed: () async {
                  await appartement.fetchAppartementFonctionnementGeneralOFF();
                  setState(() {
                    appartement;
                  });
                },
              ),
              ElevatedButton(
                child: Text(
                  'FORCE',
                ),
                style: ElevatedButton.styleFrom(
                  onPrimary: Colors.white,
                ),
                onPressed: () async {
                  await appartement
                      .fetchAppartementFonctionnementGeneralFORCE();
                  setState(() {
                    appartement;
                  });
                },
              ),
            ],
          )
        ],
      ),
      persistentFooterButtons: <Widget>[
        Text(appartement.actualisation.toString())
      ],
    );
  }
}
