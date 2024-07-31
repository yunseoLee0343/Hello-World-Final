import 'package:go_router/go_router.dart';
import 'package:hello_world_final/pages/login/first_login_page.dart';
import 'package:hello_world_final/pages/login/login_page.dart';
import 'package:hello_world_final/pages/main_page.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/first-login',
      builder: (context, state) => const ChatIntroPage(),
    ),
    GoRoute(
      path: '/main',
      builder: (context, state) => const MainPage(),
    ),
  ],
);
