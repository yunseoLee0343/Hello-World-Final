import 'package:go_router/go_router.dart';
import 'package:hello_world_final/pages/chat/tts_page.dart';
import 'package:hello_world_final/pages/login/login_page.dart';
import 'package:hello_world_final/pages/main_page.dart';
import 'package:hello_world_final/pages/profile/chatbot_history.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/main',
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
      path: '/chatbot_history',
      builder: (context, state) => const ChatbotHistory(),
    ),
    GoRoute(
      path: '/tts',
      builder: (context, state) => const TTSPage(),
    ),
  ],
);
