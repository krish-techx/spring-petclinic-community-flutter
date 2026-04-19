class PetType {
  const PetType({
    this.id,
    required this.name,
  });

  final int? id;
  final String name;

  factory PetType.fromJson(Map<String, dynamic> json) {
    return PetType(
      id: json['id'] as int?,
      name: json['name'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
    };
  }

  Map<String, dynamic> toWriteJson() {
    return {
      'name': name,
    };
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is PetType &&
            runtimeType == other.runtimeType &&
            id == other.id &&
            name == other.name;
  }

  @override
  int get hashCode => Object.hash(id, name);
}
