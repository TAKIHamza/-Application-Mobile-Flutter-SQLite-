class Facture {
  final int id;
  final double montant;
  final String dateEmission;
  final String dateLimitePaiement;
  final String? datePaiement;
  final int estPayee;
  final int idConsommation;

  Facture({
    required this.id,
    required this.montant,
    required this.dateEmission,
    required this.dateLimitePaiement,
    this.datePaiement,
    required this.estPayee,
    required this.idConsommation,
  });

  factory Facture.fromJson(Map<String, dynamic> json) {
    return Facture(
      id: json['id'] as int,
      montant: json['montant'] as double,
      dateEmission: json['date_emission'] as String,
      dateLimitePaiement: json['date_limite_paiement'] as String,
      datePaiement: json['date_paiement'] as String?,
      estPayee: json['est_payee'] as int,
      idConsommation: json['id_consommation'] as int,
    );
  }
    Map<String, dynamic> toJson() {
    return {
      'montant': montant,
      'date_emission': dateEmission,
      'date_limite_paiement': dateLimitePaiement,
      'date_paiement': datePaiement,
      'est_payee': estPayee,
      'id_consommation': idConsommation,
    };
  }
}
