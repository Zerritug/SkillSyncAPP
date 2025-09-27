import 'package:flutter/material.dart';
import 'package:skillsync/core/theme/app_colors.dart';
import 'package:skillsync/core/theme/text_styles.dart';

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

class ButtonStyles {
  static final elevatedbutton1 = ElevatedButton.styleFrom(
    //boton 1
    backgroundColor: AppColors.primary,
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    textStyle: TextStyle(color: AppColors.tertiary),
    minimumSize: Size(100, 40), //tamaño minimo
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ), //borde
  );

  static final elevatedbutton2 = ElevatedButton.styleFrom(
    //boton 2
    backgroundColor: AppColors.tertiary,
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    textStyle: AppTextStyles.button2,
    minimumSize: Size(70, 40), //tamaño minimo
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ), //borde
  );

  static final elevatedbutton3 = ElevatedButton.styleFrom(
    backgroundColor: AppColors.seventiary,
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    textStyle: AppTextStyles.button2,
    minimumSize: Size(50, 40), //tamaño minimo
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ), //borde
  );

  static final elevatedbutton4 = ElevatedButton.styleFrom(
    backgroundColor: Color.fromARGB(255, 141, 20, 255),
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    textStyle: AppTextStyles.button2,
    minimumSize: Size(50, 40), //tamaño minimo
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ), //borde
  );
}
