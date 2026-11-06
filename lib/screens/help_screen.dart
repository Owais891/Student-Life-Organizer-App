import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & FAQ'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
            child: Text(
              'Frequently Asked Questions',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 8),
          Card(
            child: ExpansionTile(
              leading: Icon(Icons.cake, color: AppColors.secondaryPurple),
              title: Text('How do I add a new birthday?'),
              children: [
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Navigate to the Birthdays tab or tap the "+" Quick Add floating button on the bottom bar. Enter the person\'s name, select their birth date using the date picker, and specify your relationship with them.',
                  ),
                ),
              ],
            ),
          ),
          Card(
            child: ExpansionTile(
              leading: Icon(Icons.alarm, color: AppColors.primaryBlue),
              title: Text('How do I create academic reminders?'),
              children: [
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Open the Reminders screen. Click the Add Reminder button or FAB. Provide a title, description, date, time, and assign a priority (High, Medium, or Low). You can mark reminders complete when finished.',
                  ),
                ),
              ],
            ),
          ),
          Card(
            child: ExpansionTile(
              leading: Icon(Icons.auto_awesome, color: AppColors.accentCyan),
              title: Text('How do I use the Gratitude Journal?'),
              children: [
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'The Gratitude Journal allows you to reflect on positive daily moments. Tap "Add Gratitude Entry", enter a title and description, and the app will automatically timestamp your note.',
                  ),
                ),
              ],
            ),
          ),
          Card(
            child: ExpansionTile(
              leading: Icon(Icons.person, color: AppColors.primaryPurple),
              title: Text('How do I edit my student profile?'),
              children: [
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Open your Profile from the side drawer or bottom navigation. Tap the "Edit Profile" button to update your name, email, university, degree program, or semester.',
                  ),
                ),
              ],
            ),
          ),
          Card(
            child: ExpansionTile(
              leading: Icon(Icons.dark_mode, color: Colors.orange),
              title: Text('How do I switch between Light and Dark mode?'),
              children: [
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'You can toggle Dark Mode anytime using the sun/moon icon on the top right app bar, or via the switch in the side Navigation Drawer or Profile Settings tab.',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
