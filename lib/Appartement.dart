import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'Variable.dart';

class Appartement {
  bool fonctionnement;
  int fonctionnementGeneral;
  String mode;
  String temperature;
  String temperatureVoulu;
  String heure;

  Appartement({
    required this.fonctionnement,
    required this.fonctionnementGeneral,
    required this.mode,
    required this.temperature,
    required this.temperatureVoulu,
    required this.heure,
  });

  void newvalue(Map<String, dynamic> json) {
    fonctionnementGeneral = json['FonctionnementGeneral'];
    fonctionnement = json['Fonctionnement'];
    mode = json['Mode'];
    temperature = json['Temperature'].toString();
    temperatureVoulu = json['TemperatureVoulu'].toString();
    heure = json['Heure'];
    log("newvalue");
  }

  Future refresh() async {
    final response = await http.get(Uri.parse(Variable.url));
    bool fonctionnement = false;

    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body);
      newvalue(json);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
    return;
  }

  void fetchAppartementFonctionnementGeneralON() async {
    final response =
        await http.get(Uri.parse(Variable.urlFonctionnementGeneralON));
    if (response.statusCode == 200) {
      newvalue(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load album');
    }
  }

  void fetchAppartementFonctionnementGeneralOFF() async {
    final response =
        await http.get(Uri.parse(Variable.urlFonctionnementGeneralOFF));
    if (response.statusCode == 200) {
      newvalue(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load album');
    }
  }
}
