import 'package:flutter/material.dart';

class QuickAddBottomAppBar extends StatelessWidget {
  final VoidCallback onAddBirthday;
  final VoidCallback onAddGratitude;
  final VoidCallback onAddReminder;

  const QuickAddBottomAppBar({
    Key? key,
    required this.onAddBirthday,
    required this.onAddGratitude,
    required this.onAddReminder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 8.0,
      elevation: 10,
      child: SizedBox(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.help_outline),
              tooltip: 'Help / FAQ',
              onPressed: () {
                Navigator.pushNamed(context, '/help');
              },
            ),
            const SizedBox(width: 48), // Space for centered FAB
            IconButton(
              icon: const Icon(Icons.info_outline),
              tooltip: 'About App',
              onPressed: () {
                Navigator.pushNamed(context, '/about');
              },
            ),
          ],
        ),
      ),
    );
  }
}
