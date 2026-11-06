import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/about_screen.dart';
import 'screens/birthday_screen.dart';
import 'screens/contact_screen.dart';
import 'screens/gratitude_screen.dart';
import 'screens/help_screen.dart';
import 'screens/home_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/reminder_screen.dart';
import 'screens/select_name_screen.dart';
import 'screens/splash_screen.dart';
import 'services/theme_service.dart';
import 'utils/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarDividerColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarIconBrightness: Brightness.dark,
  ));
  runApp(const StudentLifeOrganizerApp());
}

class StudentLifeOrganizerApp extends StatelessWidget {
  const StudentLifeOrganizerApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeService.instance.themeModeNotifier,
      builder: (context, themeMode, child) {
        return MaterialApp(
          title: 'Student Life Organizer',
          debugShowCheckedModeBanner: false,
          theme: ThemeService.lightTheme,
          darkTheme: ThemeService.darkTheme,
          themeMode: themeMode,
          // Program 2: Named Navigator Routes
          initialRoute: AppRoutes.splash,
          routes: {
            AppRoutes.splash: (context) => const SplashScreen(),
            AppRoutes.home: (context) => const HomeScreen(),
            AppRoutes.birthdays: (context) => const BirthdayScreen(),
            AppRoutes.gratitude: (context) => const GratitudeScreen(),
            AppRoutes.reminders: (context) => const ReminderScreen(),
            AppRoutes.profile: (context) => const ProfileScreen(),
            AppRoutes.contact: (context) => const ContactScreen(),
            AppRoutes.help: (context) => const HelpScreen(),
            AppRoutes.about: (context) => const AboutScreen(),
            AppRoutes.selectName: (context) => const SelectNameScreen(),
          },
        );
      },
    );
  }
}
