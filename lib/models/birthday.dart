class Birthday {
  final int? id;
  final String name;
  final String date;
  final String relationship;

  Birthday({
    this.id,
    required this.name,
    required this.date,
    required this.relationship,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'date': date,
      'relationship': relationship,
    };
  }

  factory Birthday.fromMap(Map<String, dynamic> map) {
    return Birthday(
      id: map['id'] as int?,
      name: map['name'] as String? ?? '',
      date: map['date'] as String? ?? '',
      relationship: map['relationship'] as String? ?? 'Friend',
    );
  }

  Birthday copyWith({
    int? id,
    String? name,
    String? date,
    String? relationship,
  }) {
    return Birthday(
      id: id ?? this.id,
      name: name ?? this.name,
      date: date ?? this.date,
      relationship: relationship ?? this.relationship,
    );
  }
}
