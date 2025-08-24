class Consommateur {
  final int id;
  final String cni;
  final String nom;
  final String prenom;
  final String adresse;
  final String telephone;
  

  Consommateur({
    required this.id,
    required this.cni,
    required this.nom,
    required this.prenom,
    required this.adresse,
    required this.telephone,
   
  });

  factory Consommateur.fromJson(Map<String, dynamic> json) {
    return Consommateur(
      id: json['id'] as int,
      cni: json['cni'] as String,
      nom: json['nom'] as String,
      prenom: json['prenom'] as String,
      adresse: json['adresse'] as String,
      telephone: json['telephone'] as String,

    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cni': cni,
      'nom': nom,
      'prenom': prenom,
      'adresse': adresse,
      'telephone': telephone,
   
    };
  }
}
