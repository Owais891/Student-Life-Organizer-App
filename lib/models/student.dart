import 'dart:typed_data';

class StudentProfile {
  final int? id;
  final String name;
  final String email;
  final String university;
  final String degree;
  final String semester;
  final Uint8List? profileImageBytes;

  StudentProfile({
    this.id,
    required this.name,
    required this.email,
    required this.university,
    required this.degree,
    required this.semester,
    this.profileImageBytes,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'university': university,
      'degree': degree,
      'semester': semester,
    };
  }

  factory StudentProfile.fromMap(Map<String, dynamic> map) {
    return StudentProfile(
      id: map['id'] as int?,
      name: map['name'] as String? ?? 'Alex Johnson',
      email: map['email'] as String? ?? 'alex.johnson@university.edu',
      university: map['university'] as String? ?? 'State University',
      degree: map['degree'] as String? ?? 'Computer Science',
      semester: map['semester'] as String? ?? 'Semester 5',
    );
  }

  StudentProfile copyWith({
    int? id,
    String? name,
    String? email,
    String? university,
    String? degree,
    String? semester,
    Uint8List? profileImageBytes,
  }) {
    return StudentProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      university: university ?? this.university,
      degree: degree ?? this.degree,
      semester: semester ?? this.semester,
      profileImageBytes: profileImageBytes ?? this.profileImageBytes,
    );
  }
}
