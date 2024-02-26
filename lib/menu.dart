import 'package:flutter/cupertino.dart';

class AppRouteItem{
  final String label;
  final String route;
  final IconData icon;
  final Widget screen;

  AppRouteItem({required this.label, required this.route, required this.icon, required this.screen});
}