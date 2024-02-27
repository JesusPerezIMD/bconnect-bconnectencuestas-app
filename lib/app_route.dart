import 'package:bconnect_capacitacion/models/bc_colaborador.dart';
import 'package:bconnect_capacitacion/models/bc_user.dart';
import 'package:bconnect_capacitacion/views/account/account_view.dart';
import 'package:bconnect_capacitacion/views/encuestas/encuesta_view.dart';
import 'package:flutter/material.dart';

import 'menu.dart';
import 'views/auth_view.dart';
import 'views/login_view.dart';

class AppRoute {
  static const String loginRoute = 'Login';
  static const String authRoute = 'Auth';
  static const String initialRoute = 'Encuestas';
  static const String infoRoute = 'Info';

  static List<AppRouteItem> menuOptions = <AppRouteItem>[
    AppRouteItem(
      label: 'Login',
      route: 'Login',
      icon: Icons.security,
      screen: const LoginPage(),
    ),
    AppRouteItem(
      label: 'Auth',
      route: 'Auth',
      icon: Icons.security,
      screen: const AuthPage(),
    ),
    AppRouteItem(
      label: 'Encuestas',
      route: 'Encuestas',
      icon: Icons.edit_note,
      screen: const CapacitacionPage(),
    ),
    AppRouteItem(
      label: 'Cuenta',
      route: 'Cuenta',
      icon: Icons.account_circle,
      screen: AccountPage(BCUser(), BCColaborador()),
    ),
  ];

  static Map<String, Widget Function(BuildContext)> getRoutes() {
    Map<String, Widget Function(BuildContext)> routes = {};
    for (var item in menuOptions) {
      routes.addAll({item.route: (context) => item.screen});
    }

    return routes;
  }
}
