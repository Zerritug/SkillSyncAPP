import 'package:go_router/go_router.dart';
import 'package:skillsync/features/ViewTopics/ViewTopics.dart';
import 'package:skillsync/features/AddLesson/Addlesson.dart';
import 'package:skillsync/features/AddTopic/AddTopics.dart';
import 'package:skillsync/features/stats/stats.dart';
import 'package:skillsync/features/viewLessons/ViewLessons.dart';

import '../welcomescreen/screens/welcomescreen.dart';
import '../mainmenu/screens/mainmenu.dart';
import '../features/mindmap/screens/mindmap.dart';
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
    GoRoute(
      name: RouteNames.mindmap,
      path: '/mindmap',
      builder: (context, state) => const MindMap(),
    ),
    GoRoute(
      name: RouteNames.addLessons,
      path: '/addLessons',
      builder: (context, state) => LessonScreen(),
    ),
    GoRoute(
      name: RouteNames.viewLessons,
      path: '/viewLessons',
      builder: (context, state) => LessonListScreen(),
    ),
    GoRoute(
      name: RouteNames.addtopic,
      path: '/addTopics',
      builder: (context, state) => TopicScreen(),
    ),
    GoRoute(
      name: RouteNames.viewtopics,
      path: '/viewTopics',
      builder: (context, state) => TopicListScreen(),
    ),
    GoRoute(
      name: RouteNames.stats,
      path: '/stats',
      builder: (context, state) => Estadisticas(),
    ),
  ],
);
