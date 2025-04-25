class Character {
  final int id;
  final String name;
  final String status;
  final String species;
  final String gender;
  final String originName;
  final String currentLocationName;
  final String image;

  const Character({
    required this.id,
    required this.name,
    required this.status,
    required this.species,
    required this.gender,
    required this.originName,
    required this.currentLocationName,
    required this.image,
  });

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      status: json['status'] ?? '',
      species: json['species'] ?? '',
      gender: json['gender'] ?? '',
      originName: json['origin_name'] ?? '',
      currentLocationName: json['current_location_name'] ?? '',
      image: json['image'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'status': status,
      'species': species,
      'gender': gender,
      'origin_name': originName,
      'current_location_name': currentLocationName,
      'image': image,
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'status': status,
      'species': species,
      'gender': gender,
      'origin': {'name': originName},
      'location': {'name': currentLocationName},
      'image': image,
    };
  }
}
