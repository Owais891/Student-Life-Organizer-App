import '../models/birthday.dart';
import '../models/gratitude.dart';
import '../models/reminder.dart';
import '../models/student.dart';

class AppDataStore {
  static final AppDataStore instance = AppDataStore._init();

  AppDataStore._init();

  static final List<Birthday> _birthdays = [
    Birthday(id: 1, name: 'Sarah Connor', date: '2026-11-15', relationship: 'Best Friend'),
    Birthday(id: 2, name: 'Professor Davis', date: '2026-11-20', relationship: 'Academic Advisor'),
  ];
  static final List<Gratitude> _gratitudes = [
    Gratitude(
      id: 1,
      title: 'Passed Algorithms Exam',
      description: 'Grateful for study group members who helped me review dynamic programming.',
      createdAt: '2026-11-04',
    ),
    Gratitude(
      id: 2,
      title: 'Morning Coffee & Sun',
      description: 'Enjoyed a peaceful morning walk before morning lectures started.',
      createdAt: '2026-11-05',
    ),
  ];
  static final List<Reminder> _reminders = [
    Reminder(
      id: 1,
      title: 'Submit Mobile App Assignment',
      description: 'Complete Flutter database and navigation integration.',
      date: '2026-11-08',
      time: '23:59',
      priority: 'High',
    ),
    Reminder(
      id: 2,
      title: 'Group Study Session',
      description: 'Meet at the campus library study room.',
      date: '2026-11-07',
      time: '14:00',
      priority: 'Medium',
    ),
  ];
  static StudentProfile _profile = StudentProfile(
    id: 1,
    name: 'Alex Johnson',
    email: 'alex.johnson@university.edu',
    university: 'State University',
    degree: 'Computer Science',
    semester: 'Semester 5',
  );

  static int _birthdayId = 3;
  static int _gratitudeId = 3;
  static int _reminderId = 3;

  Future<int> insertBirthday(Birthday birthday) async {
    final saved = birthday.copyWith(id: _birthdayId++);
    _birthdays.add(saved);
    return saved.id!;
  }

  Future<List<Birthday>> getBirthdays() async =>
      List<Birthday>.from(_birthdays)..sort((a, b) => a.date.compareTo(b.date));

  Future<int> updateBirthday(Birthday birthday) async {
    final index = _birthdays.indexWhere((item) => item.id == birthday.id);
    if (index == -1) return 0;
    _birthdays[index] = birthday;
    return 1;
  }

  Future<int> deleteBirthday(int id) async {
    final before = _birthdays.length;
    _birthdays.removeWhere((item) => item.id == id);
    return before - _birthdays.length;
  }

  Future<int> insertGratitude(Gratitude gratitude) async {
    final saved = gratitude.copyWith(id: _gratitudeId++);
    _gratitudes.add(saved);
    return saved.id!;
  }

  Future<List<Gratitude>> getGratitudes() async =>
      List<Gratitude>.from(_gratitudes.reversed);

  Future<int> updateGratitude(Gratitude gratitude) async {
    final index = _gratitudes.indexWhere((item) => item.id == gratitude.id);
    if (index == -1) return 0;
    _gratitudes[index] = gratitude;
    return 1;
  }

  Future<int> deleteGratitude(int id) async {
    final before = _gratitudes.length;
    _gratitudes.removeWhere((item) => item.id == id);
    return before - _gratitudes.length;
  }

  Future<int> insertReminder(Reminder reminder) async {
    final saved = reminder.copyWith(id: _reminderId++);
    _reminders.add(saved);
    return saved.id!;
  }

  Future<List<Reminder>> getReminders() async {
    final sorted = List<Reminder>.from(_reminders);
    sorted.sort((a, b) {
      final completion = a.isCompleted ? 1 : 0;
      final otherCompletion = b.isCompleted ? 1 : 0;
      final comparison = completion.compareTo(otherCompletion);
      return comparison != 0 ? comparison : a.date.compareTo(b.date);
    });
    return sorted;
  }

  Future<int> updateReminder(Reminder reminder) async {
    final index = _reminders.indexWhere((item) => item.id == reminder.id);
    if (index == -1) return 0;
    _reminders[index] = reminder;
    return 1;
  }

  Future<int> toggleReminderCompletion(int id, bool currentStatus) async {
    final index = _reminders.indexWhere((item) => item.id == id);
    if (index == -1) return 0;
    _reminders[index] =
        _reminders[index].copyWith(isCompleted: !currentStatus);
    return 1;
  }

  Future<int> deleteReminder(int id) async {
    final before = _reminders.length;
    _reminders.removeWhere((item) => item.id == id);
    return before - _reminders.length;
  }

  Future<StudentProfile> getStudentProfile() async => _profile;

  Future<int> updateStudentProfile(StudentProfile profile) async {
    _profile = profile.copyWith(id: profile.id ?? 1);
    return 1;
  }

  Future<void> resetAllData() async {
    _birthdays.clear();
    _gratitudes.clear();
    _reminders.clear();
    _profile = StudentProfile(
      id: 1,
      name: 'Alex Johnson',
      email: 'alex.johnson@university.edu',
      university: 'State University',
      degree: 'Computer Science',
      semester: 'Semester 5',
    );
    _birthdayId = 1;
    _gratitudeId = 1;
    _reminderId = 1;
  }
}
