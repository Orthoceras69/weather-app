final String tableNotes = 'notes';

class CityFields {
  static final List<String> values = [
    /// Add all fields
    id, name, latitude, longitude
  ];

  static final String id = '_id';
  static final String name = 'name';
  static final String latitude = 'latitude';
  static final String longitude = 'longitude';
}

class City {
  final int? id;
  final String name;
  final String latitude;
  final String longitude;

  const City({
    this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
  });

  City copy({
    int? id,
    String? name,
    String? latitude,
    String? longitude,
    String? description,
  }) =>
      City(
        id: id ?? this.id,
        name: name ?? this.name,
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
      );

  static City fromJson(Map<String, Object?> json) => City(
        id: json[CityFields.id] as int?,
        name: json[CityFields.name] as String,
        latitude: json[CityFields.latitude] as String,
        longitude: json[CityFields.longitude] as String,
      );

  Map<String, Object?> toJson() => {
        CityFields.id: id,
        CityFields.longitude: longitude,
        CityFields.name: name,
        CityFields.latitude: latitude,
      };
  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'City{id: $id, name: $name, latitude: $latitude ,longitude :$longitude }';
  }
}
