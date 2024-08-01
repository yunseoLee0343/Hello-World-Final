import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hello_world_final/main.dart';
import 'package:hello_world_final/pages/chat/chat_intro_page.dart';
import 'package:hello_world_final/pages/chat/chat_page.dart';
import 'package:hello_world_final/pages/chat/tts_page.dart';
import 'package:hello_world_final/pages/login/login_page.dart';
import 'package:hello_world_final/pages/main_page.dart';
import 'package:hello_world_final/pages/map/map_page.dart';
import 'package:hello_world_final/pages/map/reservation_page.dart';
import 'package:hello_world_final/pages/profile/chatbot_history.dart';
import 'package:hello_world_final/pages/profile/profile_page.dart';

int selectedIndex = 0;
final List<Widget> widgetOptions = <Widget>[
  const ChatPage(),
  const MapPage(),
  const ProfilePage(),
];

final List<String> widgetNames = [
  '/chat',
  '/map',
  '/profile',
];

final GoRouter appRouter = GoRouter(
  initialLocation:
      // isAuthenticated ? (isFirstLaunch ? '/chat' : '/main') : '/login',
      true ? (isFirstLaunch ? '/chat_intro' : '/main') : '/login',
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/main',
      builder: (context, state) => const MainPage(),
    ),
    GoRoute(
      path: '/chat_intro',
      builder: (context, state) => const ChatIntroPage(),
    ),
    GoRoute(
      path: '/chat',
      builder: (context, state) => const ChatPage(),
    ),
    GoRoute(
      path: '/chatbot_history',
      builder: (context, state) => const ChatbotHistory(),
    ),
    GoRoute(
      path: '/tts',
      builder: (context, state) => const TTSPage(),
    ),
    GoRoute(
      path: '/map',
      builder: (context, state) => const MapPage(),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfilePage(),
    ),
    GoRoute(
      path: '/reservation',
      builder: (context, state) => const ReservationPage(),
    ),
  ],
);
