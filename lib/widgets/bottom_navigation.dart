import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavigationBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: AppColors.primaryPurple,
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
      elevation: 8,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard_outlined),
          activeIcon: Icon(Icons.dashboard),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.cake_outlined),
          activeIcon: Icon(Icons.cake),
          label: 'Birthdays',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.auto_awesome_outlined),
          activeIcon: Icon(Icons.auto_awesome),
          label: 'Gratitude',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.alarm_outlined),
          activeIcon: Icon(Icons.alarm),
          label: 'Reminders',
        ),
      ],
    );
  }
}
