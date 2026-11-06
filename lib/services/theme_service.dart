import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class ThemeService {
  static final ThemeService instance = ThemeService._init();
  ThemeService._init();

  final ValueNotifier<ThemeMode> themeModeNotifier = ValueNotifier(ThemeMode.light);

  bool get isDarkMode => themeModeNotifier.value == ThemeMode.dark;

  void toggleTheme(bool isDark) {
    themeModeNotifier.value = isDark ? ThemeMode.dark : ThemeMode.light;
  }

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: AppColors.primaryPurple,
      scaffoldBackgroundColor: AppColors.lightBackground,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryPurple,
        brightness: Brightness.light,
        primary: AppColors.primaryPurple,
        secondary: AppColors.primaryBlue,
        surface: Colors.white,
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.08),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primaryPurple,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primaryPurple,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: AppColors.primaryPurple,
      scaffoldBackgroundColor: AppColors.darkBackground,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryPurple,
        brightness: Brightness.dark,
        primary: AppColors.secondaryPurple,
        secondary: AppColors.accentCyan,
        surface: AppColors.darkCard,
      ),
      cardTheme: CardThemeData(
        color: AppColors.darkCard,
        elevation: 3,
        shadowColor: Colors.black.withOpacity(0.3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.darkCard,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.secondaryPurple,
        foregroundColor: Colors.black,
        elevation: 4,
      ),
    );
  }
}
