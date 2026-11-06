import 'package:flutter_test/flutter_test.dart';
import 'package:student_life_organizer_app/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const StudentLifeOrganizerApp());
    expect(find.text('Student Life Organizer'), findsWidgets);
  });
}
