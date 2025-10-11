import 'package:flutter/material.dart';

class ThemeManager extends ChangeNotifier {
  bool _isDark = false;

  bool get isDark => _isDark;

  void toggleTheme(bool isDark) {
    _isDark = isDark;
    notifyListeners(); //actualizar el tema de la aplicacion
  }
}

final themeManager = ThemeManager();
