import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'Variable.dart';
import 'package:date_format/date_format.dart';

class Appartement {
  String fonctionnement;
  String fonctionnementGeneral;
  String mode;
  String temperature;
  String temperatureVoulu;
  String heure;
  var actualisation = formatDate(DateTime.now(), [HH, ':', nn, ':', ss]);

  Appartement({
    required this.fonctionnement,
    required this.fonctionnementGeneral,
    required this.mode,
    required this.temperature,
    required this.temperatureVoulu,
    required this.heure,
  });

  void newvalue(Map<String, dynamic> json) {
    switch (json['FonctionnementGeneral'].toString()) {
      case "0":
        fonctionnementGeneral = "OFF";
        break;
      case "1":
        fonctionnementGeneral = "ON";
        break;
      case "2":
        fonctionnementGeneral = "FORCE";
        break;
      default:
    }
    if (json['Fonctionnement'].toString() == "false")
      fonctionnement = "OFF";
    else
      fonctionnement = "ON";
    mode = json['Mode'];
    temperature = json['Temperature'].toString();
    temperatureVoulu = json['TemperatureVoulu'].toString();
    heure = json['Heure'];
    actualisation = formatDate(DateTime.now(), [HH, ':', nn, ':', ss]);
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

  Future fetchAppartementFonctionnementGeneralON() async {
    final response =
        await http.get(Uri.parse(Variable.urlFonctionnementGeneralON));
    if (response.statusCode == 200) {
      newvalue(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load album');
    }
  }

  Future fetchAppartementFonctionnementGeneralOFF() async {
    final response =
        await http.get(Uri.parse(Variable.urlFonctionnementGeneralOFF));
    if (response.statusCode == 200) {
      newvalue(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load album');
    }
  }

  Future fetchAppartementFonctionnementGeneralFORCE() async {
    final response =
        await http.get(Uri.parse(Variable.urlFonctionnementGeneralFORCE));
    if (response.statusCode == 200) {
      newvalue(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load album');
    }
  }

  Future fetchAppartementReglageTemperature(String temperature) async {
    final response = await http
        .get(Uri.parse(Variable.urlregelargetemperature + temperature));
    if (response.statusCode == 200) {
      newvalue(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load album');
    }
  }
}
