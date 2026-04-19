import '../pets/pet.dart';

class Owner {
  const Owner({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.address,
    required this.city,
    required this.telephone,
    this.pets = const [],
  });

  final int? id;
  final String firstName;
  final String lastName;
  final String address;
  final String city;
  final String telephone;
  final List<Pet> pets;

  String get fullName => '$firstName $lastName';

  factory Owner.fromJson(Map<String, dynamic> json) {
    return Owner(
      id: json['id'] as int?,
      firstName: json['firstName'] as String? ?? '',
      lastName: json['lastName'] as String? ?? '',
      address: json['address'] as String? ?? '',
      city: json['city'] as String? ?? '',
      telephone: json['telephone'] as String? ?? '',
      pets: ((json['pets'] as List<dynamic>?) ?? [])
          .map((item) => Pet.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toWriteJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'address': address,
      'city': city,
      'telephone': telephone,
    };
  }
}
