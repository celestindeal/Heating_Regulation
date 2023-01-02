import 'package:flutter/material.dart';
import 'package:flutter_application_1/Appartement.dart';

class Fonction {
  ElevatedButton bouton(String texte, Appartement appartement) {
    return ElevatedButton(
        child: Text(
          texte,
        ),
        style: ElevatedButton.styleFrom(
          onPrimary: Colors.white,
        ),
        onPressed: () async {
          return await appartement.fetchAppartementReglageTemperature(texte);
        });
  }
}
