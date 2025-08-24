class Consommation {
  final int id;
  final int trimestre;
  final int annee;
  final int quantite;
  final int valeurCompteur;
  final int idCompteur;
  final String? imagePath; 

  Consommation({
    required this.id,
    required this.trimestre,
    required this.annee,
    required this.quantite,
    required this.valeurCompteur,
    required this.idCompteur,
    this.imagePath, // Chemin d'accès à l'image
  });

  factory Consommation.fromJson(Map<String, dynamic> json) {
    return Consommation(
      id: json['id'] as int,
      trimestre: json['trimestre'] as int,
      annee: json['annee'] as int,
      quantite: json['quantite'] as int,
      valeurCompteur: json['valeur_compteur'] as int,
      idCompteur: json['id_compteur'] as int,
      imagePath: json['imagePath'] as String?, // Chemin d'accès à l'image
    );
  }
   Map<String, dynamic> toJson() {
    return {
      'id': id,
      'trimestre': trimestre,
      'annee': annee,
      'quantite': quantite,
      'valeur_compteur': valeurCompteur,
      'id_compteur': idCompteur,
      'imagePath': imagePath, 
    };
  }
  Map<String, dynamic> toBackendJson() {
    return {
      'trimestre': trimestre,
      'annee': annee,
      'quantite': quantite,
      'valeurCompteur': valeurCompteur,
      'compteur': {'id': idCompteur},
      
    };
  }
}
