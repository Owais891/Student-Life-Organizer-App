import 'package:flutter/material.dart';
import '../models/student.dart';
import '../services/theme_service.dart';
import '../utils/app_colors.dart';
import '../utils/app_routes.dart';

class AppDrawer extends StatelessWidget {
  final StudentProfile? profile;
  final Function(int)? onSelectTab;

  const AppDrawer({
    Key? key,
    this.profile,
    this.onSelectTab,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final studentName = profile?.name ?? 'Alex Johnson';
    final studentEmail = profile?.email ?? 'alex.johnson@university.edu';

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              gradient: AppColors.primaryGradient,
            ),
            accountName: Text(
              studentName,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            accountEmail: Text(studentEmail),
            currentAccountPicture: Hero(
              tag: 'profile-avatar',
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text(
                  studentName.isNotEmpty ? studentName[0].toUpperCase() : 'S',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryPurple,
                  ),
                ),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard_outlined, color: AppColors.primaryPurple),
            title: const Text('Home Dashboard'),
            onTap: () {
              Navigator.pop(context);
              if (onSelectTab != null) onSelectTab!(0);
            },
          ),
          ListTile(
            leading: const Icon(Icons.cake_outlined, color: AppColors.secondaryPurple),
            title: const Text('Birthdays'),
            onTap: () {
              Navigator.pop(context);
              if (onSelectTab != null) onSelectTab!(1);
            },
          ),
          ListTile(
            leading: const Icon(Icons.auto_awesome_outlined, color: AppColors.accentCyan),
            title: const Text('Gratitude Journal'),
            onTap: () {
              Navigator.pop(context);
              if (onSelectTab != null) onSelectTab!(2);
            },
          ),
          ListTile(
            leading: const Icon(Icons.alarm_outlined, color: AppColors.primaryBlue),
            title: const Text('Reminders'),
            onTap: () {
              Navigator.pop(context);
              if (onSelectTab != null) onSelectTab!(3);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: const Text('Student Profile'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, AppRoutes.profile);
            },
          ),
          ListTile(
            leading: const Icon(Icons.contact_support_outlined),
            title: const Text('Contact Us'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, AppRoutes.contact);
            },
          ),
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: const Text('Help & FAQ'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, AppRoutes.help);
            },
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('About App'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, AppRoutes.about);
            },
          ),
          const Divider(),
          ValueListenableBuilder<ThemeMode>(
            valueListenable: ThemeService.instance.themeModeNotifier,
            builder: (context, mode, child) {
              final isDark = mode == ThemeMode.dark;
              return SwitchListTile(
                secondary: Icon(isDark ? Icons.dark_mode : Icons.light_mode),
                title: const Text('Dark Mode'),
                value: isDark,
                onChanged: (val) {
                  ThemeService.instance.toggleTheme(val);
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
