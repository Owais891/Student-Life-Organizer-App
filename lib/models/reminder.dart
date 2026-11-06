class Reminder {
  final int? id;
  final String title;
  final String description;
  final String date;
  final String time;
  final String priority; // 'High', 'Medium', 'Low'
  final bool isCompleted;

  Reminder({
    this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.time,
    required this.priority,
    this.isCompleted = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': date,
      'time': time,
      'priority': priority,
      'is_completed': isCompleted ? 1 : 0,
    };
  }

  factory Reminder.fromMap(Map<String, dynamic> map) {
    return Reminder(
      id: map['id'] as int?,
      title: map['title'] as String? ?? '',
      description: map['description'] as String? ?? '',
      date: map['date'] as String? ?? '',
      time: map['time'] as String? ?? '',
      priority: map['priority'] as String? ?? 'Medium',
      isCompleted: (map['is_completed'] as int? ?? 0) == 1,
    );
  }

  Reminder copyWith({
    int? id,
    String? title,
    String? description,
    String? date,
    String? time,
    String? priority,
    bool? isCompleted,
  }) {
    return Reminder(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      time: time ?? this.time,
      priority: priority ?? this.priority,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
