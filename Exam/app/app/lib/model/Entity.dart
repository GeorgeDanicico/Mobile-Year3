import 'dart:convert';

class Entity {
  int? id;
  String name;
  String description;
  String genre;
  String director;
  int year;

  Entity(this.name, this.description, this.genre, this.director, this.year);

  Entity.withoutLocation(int this.id, this.name, this.description, this.genre,
      this.director, this.year);

  @override
  int get hashCode => id.hashCode;

  factory Entity.fromMap(Map<String, dynamic> json) => Entity.withoutLocation(
      json["id"],
      json["name"],
      json["description"],
      json["genre"],
      json["director"],
      json["year"]);

  factory Entity.fromJson(Map<String, dynamic> json) => Entity.withoutLocation(
      json["id"],
      json["name"],
      json["description"],
      json["genre"],
      json["director"],
      json["year"]);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'description': description,
      'name': name,
      'genre': genre,
      'director': director,
      'year': year
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'name': name,
      'genre': genre,
      'director': director,
      'year': year
    };
  }

  @override
  String toString() {
    return 'Entity $name, $description, $genre, $director, $year';
  }
}

Entity entityFromJson(String str) {
  final jsonData = json.decode(str);
  return Entity.fromMap(jsonData);
}

String entityToJson(Entity data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}
