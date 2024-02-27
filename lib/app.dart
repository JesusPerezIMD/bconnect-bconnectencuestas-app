import 'package:bconnect_capacitacion/app_route.dart';
import 'package:bconnect_capacitacion/app_theme.dart';
import 'package:bconnect_capacitacion/views/login_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class App extends StatelessWidget {
  final Widget? home;
  final String? token;

  const App(
      {this.home, this.token, Key? key, required TransitionBuilder builder})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('es', 'es_mx'),
      ],
      theme: AppTheme.lightTheme,
      title: 'BConnect - Encuestas Bconnect',
      home: home ?? const LoginPage(),
      routes: AppRoute.getRoutes(),
    );
  }
}
