import 'dart:convert';
import 'package:flutter/material.dart';
import '../app_route.dart';
import '../helpers/preferences_helper.dart';
import '../models/bc_user.dart';
import '../models/firebase_user.dart';
import '../services/bconnect_service.dart';

class AuthPage extends StatefulWidget {
  final String? token;
  final String? code;

  const AuthPage({this.token, this.code, Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  BCUser? user;
  FirebaseUser? firebaseUser;

  @override
  void initState() {
    super.initState();
    checkToken(context);
  }

  Future<void> checkToken(BuildContext context) async {
    await removePreferences();
    String token = widget.token ?? '';
    String code = widget.code ?? '';
    if (token == '' && code == '') {
      if (!mounted) return;
      await Navigator.pushNamedAndRemoveUntil(
          context, AppRoute.loginRoute, (route) => false);
    }

    try {
      BCUser? user;
      String userKey = '';
      if (code != '') {
        final authUserCode = await BConnectService().authByAccessCode(code);
        user = authUserCode?.user;
        token = authUserCode?.accessToken ?? '';
      } else {
        final authUser = await BConnectService().authByAccessToken(token);
        user = authUser?.user;
      }

      if (mounted && user == null) {
        await Navigator.pushNamedAndRemoveUntil(
            context, AppRoute.loginRoute, (route) => false);
      }
      final firebaseUser = await BConnectService().firebaseAuth(token);
      if (mounted && firebaseUser == null) {
        await Navigator.pushNamedAndRemoveUntil(
            context, AppRoute.loginRoute, (route) => false);
      }
      final colaborador =
          await BConnectService().getColaborador(user?.sId ?? '');
      await PreferencesHelper.setString('userkey', userKey);
      await PreferencesHelper.setString('token', token);
      await PreferencesHelper.setString('user', jsonEncode(user?.toJson()));
      await PreferencesHelper.setString(
          'firebase_user', jsonEncode(firebaseUser?.toJson()));
      await PreferencesHelper.setString(
          'colaborador', jsonEncode(colaborador?.toJson()));
      if (!mounted) return;
      await Navigator.pushNamedAndRemoveUntil(
          context, AppRoute.initialRoute, (route) => false);
    } catch (e) {
      if (!mounted) return;
      await Navigator.pushNamedAndRemoveUntil(
          context, AppRoute.loginRoute, (route) => false);
    }
  }

  Future<void> removePreferences() async {
    await PreferencesHelper.remove('userkey');
    await PreferencesHelper.remove('token');
    await PreferencesHelper.remove('user');
    await PreferencesHelper.remove('firebase_user');
    await PreferencesHelper.remove('colaborador');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BConnect'),
        elevation: 2,
      ),
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              CircularProgressIndicator(),
              Text('Iniciando sesión...'),
            ],
          ),
        ),
      ),
    );
  }
}
