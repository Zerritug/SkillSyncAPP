import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../welcomescreen/screens/welcomescreen.dart';
import '../mainmenu/screens/mainmenu.dart';
import 'route_names.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/welcome',
  routes: [
    GoRoute(
      name: RouteNames.welcome,
      path: '/welcome',
      builder: (context, state) => const WelcomeScreen(),
    ),
    GoRoute(
      name: RouteNames.mainMenu,
      path: '/mainmenu',
      builder: (context, state) => const MainMenuScreen(),
    ),
  ],
);