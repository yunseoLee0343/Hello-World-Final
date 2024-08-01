import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hello_world_final/auth/auth_service.dart';
import 'package:hello_world_final/pages/chat/model/message.dart';
import 'package:hello_world_final/router/app_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool isAuthenticated = false;
bool isFirstLaunch = true;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  isAuthenticated = await AuthService.isLoggedIn();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool('isFirstLaunch', true);
  isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ko'), Locale('ja')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => Messages()),
        ],
        child: MyApp(
          isAuthenticated: true,
          // isAuthenticated: isAuthenticated,
          isFirstLaunch: isFirstLaunch,
        ),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool isAuthenticated;
  final bool isFirstLaunch;

  const MyApp(
      {super.key, required this.isAuthenticated, required this.isFirstLaunch});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerDelegate: appRouter.routerDelegate,
      routeInformationParser: appRouter.routeInformationParser,
      routeInformationProvider: appRouter.routeInformationProvider,
      theme: ThemeData(
        fontFamily: 'Nunito',
      ),
      themeMode: ThemeMode.system,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
    );
  }
}
