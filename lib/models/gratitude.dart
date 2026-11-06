class Gratitude {
  final int? id;
  final String title;
  final String description;
  final String createdAt;

  Gratitude({
    this.id,
    required this.title,
    required this.description,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'created_at': createdAt,
    };
  }

  factory Gratitude.fromMap(Map<String, dynamic> map) {
    return Gratitude(
      id: map['id'] as int?,
      title: map['title'] as String? ?? '',
      description: map['description'] as String? ?? '',
      createdAt: map['created_at'] as String? ?? '',
    );
  }

  Gratitude copyWith({
    int? id,
    String? title,
    String? description,
    String? createdAt,
  }) {
    return Gratitude(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
