class Parametre {
  final String name;
  final String value;

  Parametre({
    required this.name,
    required this.value,
  });

  factory Parametre.fromJson(Map<String, dynamic> json) {
    return Parametre(
      name: json['name'] as String,
      value: json['value'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'value': value,
    };
  }
}
