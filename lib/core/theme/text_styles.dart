// text_styles.dart
import 'package:flutter/material.dart';
import 'package:skillsync/core/theme/app_colors.dart';

class AppTextStyles {
  // --- General ---
  static const greeting = TextStyle(
    color: Colors.white,
    fontSize: 22,
    letterSpacing: 1.2,
  );

  static const greeting2 = TextStyle(
    color: Color.fromARGB(255, 12, 12, 12),
    fontSize: 18,
    letterSpacing: 1.2,
  );

  // --- Modo claro ---
  static const titles = TextStyle(
    color: Colors.black,
    fontSize: 16,
    letterSpacing: 1.2,
  );

  static const usualtextLight = TextStyle(
    color: Colors.black87,
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );

  // --- Modo oscuro ---
  static const titlesW = TextStyle(
    color: Colors.white,
    fontSize: 25,
    letterSpacing: 1.2,
  );

  static const usualtextDark = TextStyle(
    color: AppColors.darkText,
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );

  // --- Botones ---
  static const button1 = TextStyle(
    color: Colors.white,
    fontSize: 10,
    fontWeight: FontWeight.w200,
  );

  static const button2 = TextStyle(
    color: Colors.black,
    fontSize: 10,
    fontWeight: FontWeight.w200,
  );

  static const button3 = TextStyle(
    color: Colors.white,
    fontSize: 10,
    fontWeight: FontWeight.w200,
  );
}
