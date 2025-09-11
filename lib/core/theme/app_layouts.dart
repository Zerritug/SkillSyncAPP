import 'package:flutter/material.dart';

class LayoutStyles {
  // Espaciado estándar
  static const EdgeInsets screenPadding = EdgeInsets.symmetric(
    horizontal: 24,
    vertical: 20,
  );
  static const EdgeInsets cardPadding = EdgeInsets.all(12);

  // Alineaciones comunes
  static const MainAxisAlignment mainCenter = MainAxisAlignment.center; //center
  static const CrossAxisAlignment crossStart =
      CrossAxisAlignment.start; //initial

  // Espaciadores
  static const SizedBox verticalSpaceSmall = SizedBox(height: 8); //short
  static const SizedBox verticalSpaceMedium = SizedBox(height: 16); //medium
  static const SizedBox verticalSpaceLarge = SizedBox(height: 32); //long
}
