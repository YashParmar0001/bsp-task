import 'package:go_router/go_router.dart';
import 'package:quiz_app/ui/home_screen.dart';
import 'package:quiz_app/ui/quiz/screens/quiz_complete_screen.dart';
import 'package:quiz_app/ui/quiz/screens/quiz_screen.dart';

final router = GoRouter(
  initialLocation: '/home',
  routes: [
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/quiz',
      builder: (context, state) => const QuizScreen(),
    ),
    GoRoute(
      path: '/complete',
      builder: (context, state) => const QuizCompleteScreen(),
    ),
  ],
);