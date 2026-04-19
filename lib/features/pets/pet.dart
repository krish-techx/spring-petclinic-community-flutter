import '../pettypes/pet_type.dart';
import '../visits/visit.dart';

class Pet {
  const Pet({
    this.id,
    this.ownerId,
    required this.name,
    required this.birthDate,
    required this.type,
    this.visits = const [],
  });

  final int? id;
  final int? ownerId;
  final String name;
  final String birthDate;
  final PetType type;
  final List<Visit> visits;

  factory Pet.fromJson(Map<String, dynamic> json) {
    return Pet(
      id: json['id'] as int?,
      ownerId: json['ownerId'] as int?,
      name: json['name'] as String? ?? '',
      birthDate: json['birthDate'] as String? ?? '',
      type: PetType.fromJson(json['type'] as Map<String, dynamic>),
      visits: ((json['visits'] as List<dynamic>?) ?? [])
          .map((item) => Visit.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toWriteJson() {
    return {
      'name': name,
      'birthDate': birthDate,
      'type': type.toJson(),
    };
  }
}
