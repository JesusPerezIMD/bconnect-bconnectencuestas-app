import 'dart:convert';
import 'package:bconnect_capacitacion/components/navigation_bar_component.dart';
import 'package:bconnect_capacitacion/env.dart';
import 'package:flutter/material.dart';
import 'package:bconnect_capacitacion/app_route.dart';
import 'package:bconnect_capacitacion/helpers/preferences_helper.dart';
import 'package:bconnect_capacitacion/views/account/account_view.dart';
import 'package:bconnect_capacitacion/views/capacitacion/capacitacion_view.dart';
import '../../models/models.dart';
import '../../components/components.dart';
import 'package:intl/intl.dart';
import '../../services/bconnect_service.dart';

class HistorialCapacitacionPage extends StatefulWidget {
  final SolicitudCapacitacion? responsecapacitacion;
  const HistorialCapacitacionPage({Key? key, this.responsecapacitacion})
      : super(key: key);
  @override
  State<HistorialCapacitacionPage> createState() =>
      _HistorialCapacitacionPageState();
}

class _HistorialCapacitacionPageState extends State<HistorialCapacitacionPage> {
  List<SolicitudCapacitacion> encuestas = [];
  final _formKey = GlobalKey<FormState>();
  BCUser? user;
  String? userid = '';
  String? colaboradorid = '';
  FirebaseUser? firebaseUser;
  BCColaborador? colaborador;
  bool loadingReports = true;

  Future<void> getHistory(String codemp) async {
    var result = await BConnectService().getHistorySaludEncuestas(codemp);
    if (mounted) {
      setState(() {
        encuestas = result;
        loadingReports = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      await initUser(context);
        if (mounted) {
          setState(() {
          });
        }
    });
  }

  Future<void> initUser(BuildContext context) async {
    try {
      final jsonUser = await PreferencesHelper.getString('user');
      user = BCUser.fromJson(jsonDecode(jsonUser ?? ''));
      if (mounted && user == null) {
        await Navigator.pushNamedAndRemoveUntil(
            context, AppRoute.loginRoute, (route) => false);
      }
      final jsonFirebaseUser =
          await PreferencesHelper.getString('firebase_user');
      firebaseUser = FirebaseUser.fromJson(jsonDecode(jsonFirebaseUser ?? ''));
      if (mounted && firebaseUser == null) {
        await Navigator.pushNamedAndRemoveUntil(
            context, AppRoute.loginRoute, (route) => false);
      }
      final jsonColaborador = await PreferencesHelper.getString('colaborador');
      colaborador = BCColaborador.fromJson(jsonDecode(jsonColaborador ?? ''));
      colaboradorid = colaborador?.codemp;
      getHistory(colaboradorid!);
    } catch (e) {
      await Navigator.pushNamedAndRemoveUntil(
          context, AppRoute.loginRoute, (route) => false);
    }
  }

@override
Widget build(BuildContext context) {
  final userInitials =
      '${(user?.names ?? '') == '' ? '' : (user?.names ?? '').substring(0, 1)}${(user?.lastNames ?? '') == '' ? '' : (user?.lastNames ?? '').substring(0, 1)}';
  return Scaffold(
    appBar: BconnectAppBar(
      onPressed: () => {
        Navigator.push(
            context,
            MaterialPageRoute<void>(
                builder: (BuildContext context) => AccountPage(
                    user ?? BCUser(), colaborador ?? BCColaborador())))
      },
      userInitials: userInitials,
    ),
    bottomNavigationBar: NavigationBarComponenet(1),
body: encuestas.isEmpty
    ? Center(
        child: Text(
          "No existen datos",
          style: TextStyle(
            fontSize: 16, // Puedes ajustar el tamaño del texto aquí
            color: Colors.grey, // Puedes ajustar el color del texto aquí
          ),
        ),
      )
    : Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                "Historial de Bconnect Encuestas",
                style: TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontSize: 14,
                  fontWeight: FontWeight.bold, // Puedes ajustar el estilo del título aquí
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: encuestas.length,
              itemBuilder: (context, index) {
                return Column(
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Folio: ${encuestas[index].bp_folio ?? ''}',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '${DateFormat('dd/MM/yyyy hh:mm a').format(encuestas[index].createdon ?? DateTime.now())}',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                    ),
                  ),
                    ],
                  ),
                  Divider(height: 0),
                ],
                );
              },
            ),
          ),
        ],
      ),
  );
}
}
