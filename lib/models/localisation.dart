class Localisation {
  final int id;
  final double latitude;
  final double longitude;

  Localisation({
    required this.id,
    required this.latitude,
    required this.longitude,
  });

  factory Localisation.fromJson(Map<String, dynamic> json) {
    return Localisation(
      id: json['id'] as int,
      latitude: json['latitude'] as double,
      longitude: json['longitude'] as double,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
