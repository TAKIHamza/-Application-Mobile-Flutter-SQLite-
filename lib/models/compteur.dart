class Compteur {
  final int id;
  final String numeroSerie;
  final String dateInstallation;
  final String dernierReleve;
  final String zone;
  final int localisationID;
  final int consommateurID;

  Compteur({
    required this.id,
    required this.numeroSerie,
    required this.dateInstallation,
    required this.dernierReleve,
    required this.zone,
    required this.localisationID,
    required this.consommateurID,
  });

  factory Compteur.fromJson(Map<String, dynamic> json) {
    return Compteur(
      id: json['id'] as int,
      numeroSerie: json['numero_serie'] as String,
      dateInstallation: json['date_installation'] as String,
      dernierReleve: json['dernierReleve'] as String,
      zone: json['zone'] as String,
      localisationID: json['localisationID'] as int,
      consommateurID: json['consommateurID'] as int,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'numero_serie': numeroSerie,
      'date_installation': dateInstallation,
      'dernierReleve': dernierReleve,
      'zone': zone,
      'localisationID': localisationID,
      'consommateurID': consommateurID,
    };
  }
}
