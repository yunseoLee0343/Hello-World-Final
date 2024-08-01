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
import 'package:hello_world_final/pages/onboarding/onboarding.dart';
import 'package:hello_world_final/pages/profile/detailed_page.dart';
import 'package:hello_world_final/pages/profile/profile_page.dart';
import 'package:hello_world_final/pages/profile/recent_page.dart';

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
  // '/onboarding',
  routes: [
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingPage(),
    ),
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
      builder: (BuildContext context, GoRouterState state) {
        final CenterDetails centerDetails = state.extra as CenterDetails;
        return ReservationPage(
          centerID: centerDetails.centerID,
          centerName: centerDetails.centerName,
        );
      },
    ),
    GoRoute(
      path: '/recent_applicants',
      builder: (context, state) => const RecentPage(),
    ),
    GoRoute(
      path: '/applicant_summary',
      builder: (context, state) {
        // Extract roomId from state.extra
        final summaryId = state.extra as String? ?? '';
        return DetailedPage(
          summaryId: summaryId,
        );
      },
    ),
    // GoRoute(
    //   path: '/applicant_past_records',
    //   builder: (context, state) => const PastPage(),
    // ),
  ],
);
