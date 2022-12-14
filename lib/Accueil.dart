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
      temperature: '',
      swith: true);
  double _value = 20;
  String _status = 'idle';
  Color _statusColor = Colors.amber;

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
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () async {
              await appartement.refresh();
              setState(() {
                appartement;
              });
            },
          ),
          Switch(
              value: appartement.swith,
              onChanged: ((value) async {
                if (value) {
                  await appartement.fetchAppartementFonctionnementGeneralON();
                } else {
                  appartement.fetchAppartementFonctionnementGeneralOFF();
                }
                setState(() {
                  appartement;
                });
              }))
        ],
      ),
      body: Stack(
        children: [
          Column(
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
              Slider(
                min: 12.0,
                max: 22.0,
                value: _value,
                divisions: 20,
                onChanged: (value) {
                  setState(() {
                    _value = value;
                    _status = value.toString();
                    if (value < 10) {
                      _statusColor = Colors.green;
                    } else if (value < 15) {
                      _statusColor = Colors.orange;
                    } else {
                      _statusColor = Colors.red;
                    }
                  });
                },
                onChangeEnd: (value) async {
                  await appartement
                      .fetchAppartementReglageTemperature(value.toString());
                  setState(() {
                    appartement;
                  });
                },
              ),
              Text(
                'Température: $_status',
                style: TextStyle(color: _statusColor),
              ),
              Center(
                child: MaterialButton(
                  height: 40.0,
                  minWidth: MediaQuery.of(context).size.width / 2,
                  color: Theme.of(context).primaryColor,
                  textColor: Colors.white,
                  child: new Text("FORCE"),
                  onPressed: () async {
                    await appartement
                        .fetchAppartementFonctionnementGeneralFORCE();
                    setState(() {
                      appartement;
                    });
                  },
                  splashColor: Colors.redAccent,
                ),
              ),
            ],
          ),
          appartement.swith
              ? Container()
              : Container(
                  decoration: appartement.swith
                      ? new BoxDecoration(
                          color: Colors.grey.shade200.withOpacity(0.8))
                      : new BoxDecoration(),
                ),
        ],
      ),
      persistentFooterButtons: <Widget>[
        Text(appartement.actualisation.toString())
      ],
    );
  }
}
