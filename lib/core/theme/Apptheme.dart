// app_theme.dart
import 'package:flutter/material.dart';
import 'package:skillsync/core/theme/app_colors.dart';
import 'package:skillsync/core/theme/text_styles.dart';
import 'package:skillsync/core/theme/app_layouts.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.white,
    primaryColor: AppColors.primary,
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.secundary,
      surface: Colors.white,
      background: AppColors.tertiary,
      onPrimary: Colors.white,
      onSecondary: Colors.black,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.primary,
      titleTextStyle: AppTextStyles.titlesW,
      iconTheme: IconThemeData(color: Colors.white),
    ),
    textTheme: TextTheme(
      bodyMedium: AppTextStyles.usualtextLight,
      titleMedium: AppTextStyles.titles,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyles.elevatedbutton1,
    ),
  );

  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF121212),
    primaryColor: AppColors.primary,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primary,
      secondary: AppColors.secundary,

      surface: Color.fromARGB(255, 30, 30, 30),

      onPrimary: Colors.white,
      onSecondary: Color.fromARGB(255, 39, 39, 39),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1F1F1F),
      titleTextStyle: AppTextStyles.titlesW,
      iconTheme: IconThemeData(color: Colors.white),
    ),
    textTheme: const TextTheme(
      bodyMedium: AppTextStyles.usualtextDark,
      titleMedium: AppTextStyles.titlesW,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyles.elevatedbuttonDark,
    ),
  );
}
