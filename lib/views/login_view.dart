// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:html';

import 'package:bconnect_capacitacion/app_route.dart';
import 'package:bconnect_capacitacion/env.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String whatsappNumber = Environment().WHATSAPP_NUMBER;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BConnect - Capacitación'),
        elevation: 2,
      ),
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: Center(
          child: SizedBox(
            height: 40,
            width: 250,
            child: ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.green[700]),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)))),
              onPressed: _launchUrl,
              child: const Text(
                'Iniciar sesión en WhatsApp',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _launchUrl() async {
    final url = Uri.parse('https://wa.me/%2b$whatsappNumber?text=Capacitación');
    if (!await launchUrl(url)) {
      throw Exception('Could not launch url');
    }
  }
}
