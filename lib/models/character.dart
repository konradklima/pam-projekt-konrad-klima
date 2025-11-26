import 'package:hive/hive.dart';

part 'character.g.dart';

@HiveType(typeId: 0)
class Character extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String race;

  @HiveField(3)
  final String gender;

  @HiveField(4)
  final String birth;

  @HiveField(5)
  final String death;

  @HiveField(6)
  final String spouse;

  @HiveField(7)
  final String wikiUrl;

  Character({
    required this.id,
    required this.name,
    required this.race,
    required this.gender,
    required this.birth,
    required this.death,
    required this.spouse,
    required this.wikiUrl,
  });

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      id: json['_id'] ?? '',
      name: json['name'] ?? 'Nieznane',
      race: json['race'] ?? 'Nieznane',
      gender: json['gender'] ?? 'Nieznane',
      birth: json['birth'] ?? 'Nieznane',
      death: json['death'] ?? 'Nieznane',
      spouse: json['spouse'] ?? 'Brak',
      wikiUrl: json['wikiUrl'] ?? '',
    );
  }
}
