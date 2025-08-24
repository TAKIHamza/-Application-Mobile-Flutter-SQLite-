class Zone {
  final String name;
  final String description;

  Zone({
    required this.name,
    required this.description,
  });

  factory Zone.fromJson(Map<String, dynamic> json) {
    return Zone(
      name: json['name'] as String,
      description: json['description'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
    };
  }
}
