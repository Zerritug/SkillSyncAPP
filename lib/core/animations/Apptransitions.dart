import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Esta clase define una transición de página reutilizable

class AppPageTransition extends CustomTransitionPage {
  AppPageTransition({
    required Widget child, // El widget de la pantalla a mostrar
    bool isForward =
        true, // Ddfine navegacion hacia adelante o atras dependiendo el bool
  }) : super(
         // Duración de la animación al abrir la pantalla
         transitionDuration: const Duration(milliseconds: 400),
         // Duración al cerrar (normalmente un poco más rápida)
         reverseTransitionDuration: const Duration(milliseconds: 300),
         child: child,
         //definicion de la animacion
         transitionsBuilder: (context, animation, secondaryAnimation, child) {
           // Hace que la pantalla aparezca o desaparezca gradualmente
           final fadeTween = Tween(begin: 0.0, end: 1.0);

           // Si es hacia adelante, entra desde la derecha.
           // Si es hacia atrás, entra desde la izquierda.
           final slideTween = Tween(
             begin: Offset(isForward ? 0.1 : -0.1, 0),
             end: Offset.zero,
           ).chain(
             // curve.ease pára que la animación se sienta natural
             CurveTween(curve: Curves.easeOutCubic),
           );

           return FadeTransition(
             opacity: animation.drive(fadeTween), // Aplica el fade
             child: SlideTransition(
               position: animation.drive(slideTween), // Aplica el movimiento
               child: child, // El contenido de la pantalla
             ),
           );
         },
       );
}
