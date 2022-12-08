import 'dart:developer';

class Appartement {
  final bool fonctionnement;
  final bool fonctionnementGeneral;
  final String mode;
  final String temperature;
  final String temperatureVoulu;
  final String heure;

  const Appartement({
    required this.fonctionnementGeneral,
    required this.fonctionnement,
    required this.mode,
    required this.temperature,
    required this.temperatureVoulu,
    required this.heure,
  });

  factory Appartement.fromJson(Map<String, dynamic> json) {
    return Appartement(
      fonctionnementGeneral: json["FonctionnementGeneral"] as bool,
      fonctionnement: json["Fonctionnement"] as bool,
      mode: json["Mode"],
      temperature: json["Temperature"].toString(),
      temperatureVoulu: json["TemperatureVoulu"].toString(),
      heure: json["Heure"],
    );
  }
}
