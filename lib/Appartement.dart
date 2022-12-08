import 'dart:developer';

class Appartement {
  final bool fonctionnement;
  final String mode;
  final double temperature;
  final double temperatureVoulu;
  final String  heure;

  const Appartement({
    required this.fonctionnement,
    required this.mode,
    required this.temperature,
    required this.temperatureVoulu,
    required this.heure,
  });

  factory Appartement.fromJson(Map<String, dynamic> json) {
    return Appartement(  
      fonctionnement: json["Fonctionnement"] as bool,
      mode: json["Mode"] ,
      temperature: json["Temperature"] as double,
      temperatureVoulu: json["TemperatureVoulu"] as double,
      heure: json["Heure"] ,
    );
  }
}