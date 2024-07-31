import 'package:go_router/go_router.dart';
import 'package:hello_world_final/pages/login/login_page.dart';
import 'package:hello_world_final/pages/main_page.dart';
import 'package:hello_world_final/pages/profile/chatbot_history.dart';
import 'package:hello_world_final/pages/profile/profile_page.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/profile',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/main',
      builder: (context, state) => const MainPage(),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfilePage(),
    ),
    GoRoute(
      path: '/chatbot_history',
      builder: (context, state) => const ChatbotHistory(),
    ),
  ],
);
