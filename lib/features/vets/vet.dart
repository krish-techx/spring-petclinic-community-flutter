import '../specialties/specialty.dart';

class Vet {
  const Vet({
    this.id,
    required this.firstName,
    required this.lastName,
    this.specialties = const [],
  });

  final int? id;
  final String firstName;
  final String lastName;
  final List<Specialty> specialties;

  String get fullName => '$firstName $lastName';

  factory Vet.fromJson(Map<String, dynamic> json) {
    return Vet(
      id: json['id'] as int?,
      firstName: json['firstName'] as String? ?? '',
      lastName: json['lastName'] as String? ?? '',
      specialties: ((json['specialties'] as List<dynamic>?) ?? [])
          .map((item) => Specialty.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toWriteJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'specialties': specialties.map((specialty) => specialty.toJson()).toList(),
    };
  }
}
