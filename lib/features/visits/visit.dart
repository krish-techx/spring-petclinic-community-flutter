class Visit {
  const Visit({
    this.id,
    this.petId,
    required this.date,
    required this.description,
  });

  final int? id;
  final int? petId;
  final String date;
  final String description;

  factory Visit.fromJson(Map<String, dynamic> json) {
    return Visit(
      id: json['id'] as int?,
      petId: json['petId'] as int?,
      date: json['date'] as String? ?? '',
      description: json['description'] as String? ?? '',
    );
  }

  Map<String, dynamic> toWriteJson() {
    return {
      'date': date,
      'description': description,
    };
  }
}
