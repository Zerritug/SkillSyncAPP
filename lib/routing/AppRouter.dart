import 'package:go_router/go_router.dart';
import 'package:skillsync/features/ViewTopics/ViewTopics.dart';
import 'package:skillsync/features/AddLesson/Addlesson.dart';
import 'package:skillsync/features/AddTopic/AddTopics.dart';
import 'package:skillsync/features/phrases/Phrases.dart';
import 'package:skillsync/features/viewLessons/ViewLessons.dart';
import 'package:skillsync/features/Reminders/Reminders.dart';
import '../welcomescreen/screens/welcomescreen.dart';
import '../mainmenu/screens/mainmenu.dart';
import '../features/mindmap/screens/mindmap.dart';
import 'route_names.dart';
import 'package:skillsync/core/animations/Apptransitions.dart';

//go router se implemento para la navegacion de la aplicacion, name para el nombre de la pantalla el path
// que se declara en route_names.dart para tener un tipo de url al que dirigirse y el builder es la pantalla

final GoRouter appRouter = GoRouter(
  initialLocation: '/welcome',
  routes: [
    GoRoute(
      name: RouteNames.welcome,
      path: '/welcome',
      pageBuilder: (context, state) {
        final isforward = state.extra == 'forward';
        return AppPageTransition(
          child: const WelcomeScreen(),
          isForward: isforward ?? true,
        );
      },
    ),
    GoRoute(
      name: RouteNames.mainMenu,
      path: '/mainmenu',
      pageBuilder: (context, state) {
        final isforward = state.extra == 'forward';
        return AppPageTransition(
          child: const MainMenuScreen(),
          isForward: isforward ?? true,
        );
      },
    ),
    GoRoute(
      name: RouteNames.mindmap,
      path: '/mindmap',
      pageBuilder: (context, state) {
        final isforward = state.extra == 'forward';
        return AppPageTransition(
          child: const MindMap(),
          isForward: isforward ?? true,
        );
      },
    ),
    GoRoute(
      name: RouteNames.addLessons,
      path: '/addLessons',
      pageBuilder: (context, state) {
        final isforward = state.extra == 'forward';
        return AppPageTransition(
          child: const LessonScreen(),
          isForward: isforward ?? true,
        );
      },
    ),
    GoRoute(
      name: RouteNames.viewLessons,
      path: '/viewLessons',
      pageBuilder: (context, state) {
        final isforward = state.extra == 'forward';
        return AppPageTransition(
          child: const LessonListScreen(),
          isForward: isforward ?? true,
        );
      },
    ),
    GoRoute(
      name: RouteNames.addtopic,
      path: '/addTopics',
      pageBuilder: (context, state) {
        final isforward = state.extra == 'forward';
        return AppPageTransition(
          child: const TopicScreen(),
          isForward: isforward ?? true,
        );
      },
    ),
    GoRoute(
      name: RouteNames.viewtopics,
      path: '/viewTopics',
      pageBuilder: (context, state) {
        final isforward = state.extra == 'forward';
        return AppPageTransition(
          child: const TopicListScreen(),
          isForward: isforward ?? true,
        );
      },
    ),
    GoRoute(
      name: RouteNames.phrases,
      path: '/phrases',
      pageBuilder: (context, state) {
        final isforward = state.extra == 'forward';
        return AppPageTransition(
          child: const FrasesMotivacionales(),
          isForward: isforward ?? true,
        );
      },
    ),
    GoRoute(
      name: RouteNames.reminders,
      path: '/reminders',
      pageBuilder: (context, state) {
        final isforward = state.extra == 'forward';
        return AppPageTransition(
          child: const ReminderScreen(),
          isForward: isforward ?? true,
        );
      },
    ),
  ],
);
