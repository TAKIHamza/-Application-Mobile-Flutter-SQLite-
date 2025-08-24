
import 'package:ifsan/models/consommateur.dart';
import 'package:ifsan/models/zone.dart';

class Tcompteur {
  final int id;
  final String numeroSerie;
  final String dateInstallation;
  final String dernierReleve;
  final Zone zone;
  final int localisationID;
  final Consommateur personne;

  Tcompteur({
    required this.id,
    required this.numeroSerie,
    required this.dateInstallation,
    required this.dernierReleve,
    required this.zone,
    required this.localisationID,
    required this.personne,
  });

  factory Tcompteur.fromJson(Map<String, dynamic> json) {
    return Tcompteur(
      id: json['id'] as int,
      numeroSerie: json['numeroSerie'] as String,
      dateInstallation: json['dateInstallation'] as String,
      dernierReleve: json['dernierReleve'] as String,
      zone: Zone.fromJson(json['zone']),
      localisationID: 1,
      personne: Consommateur.fromJson(json['personne']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'numero_serie': numeroSerie,
      'date_installation': dateInstallation,
      'dernierReleve': dernierReleve,
      'zone': zone,
      'localisationID': 1,
      'personne': personne.toJson(),
    };
  }
}