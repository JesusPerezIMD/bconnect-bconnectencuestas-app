import 'dart:convert';
import 'package:bconnect_capacitacion/components/navigation_bar_component.dart';
import 'package:bconnect_capacitacion/env.dart';
import 'package:flutter/material.dart';
import 'package:bconnect_capacitacion/app_route.dart';
import 'package:bconnect_capacitacion/helpers/preferences_helper.dart';
import 'package:bconnect_capacitacion/views/account/account_view.dart';
import 'package:bconnect_capacitacion/views/encuestas/encuesta_view.dart';
import '../../models/models.dart';
import '../../components/components.dart';
import 'package:intl/intl.dart';
import '../../services/bconnect_service.dart';

class HistorialCapacitacionPage extends StatefulWidget {
  final BitacoraEncuesta? responsecapacitacion;
  const HistorialCapacitacionPage({Key? key, this.responsecapacitacion})
      : super(key: key);
  @override
  State<HistorialCapacitacionPage> createState() =>
      _HistorialCapacitacionPageState();
}

class _HistorialCapacitacionPageState extends State<HistorialCapacitacionPage> {
  List<BitacoraEncuesta> encuestas = [];
  List<BitacoraEncuesta> filteredEncuestas = [];
  String? selectedResult;
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
        if (result.isNotEmpty) {
          encuestas = result;
          filteredEncuestas = encuestas;
          selectedResult = filteredEncuestas.first.bc_encuestaname;
          filteredEncuestas = encuestas
              .where((encuesta) => encuesta.bc_encuestaname == selectedResult)
              .toList();
          loadingReports = false;
        } else {
          encuestas = [];
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      await initUser(context);
      if (mounted) {
        setState(() {});
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
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    "Historial de Encuestas",
                    style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Column(
                    children: [
                      ddlEstatus(), // Aquí llamas al DropdownButtonFormField
                      SizedBox(height: 10), // Espacio adicional hacia abajo
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(10),
                    itemCount: filteredEncuestas.length,
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
                                      'Folio: ${filteredEncuestas[index].bc_folio ?? ''}',
                                      style: TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                '${DateFormat('dd/MM/yyyy hh:mm a').format(filteredEncuestas[index].createdon ?? DateTime.now())}',
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

  DropdownButtonFormField<String> ddlEstatus() {
    Set<String> uniqueEncuestas = encuestas.map((encuesta) => encuesta.bc_encuestaname ?? '').toSet();
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        hintText: 'Seleccione una Estatus',
        border: InputBorder.none,
        filled: false,
        fillColor: Color.fromRGBO(204, 204, 204, 80),
        hintStyle: TextStyle(fontWeight: FontWeight.bold),
      ),
      value: selectedResult,
      items: uniqueEncuestas.map((encuesta) {
        return DropdownMenuItem<String>(
          value: encuesta,
          child: Text(encuesta),
        );
      }).toList(),
      icon: Icon(
        Icons.expand_more,
        color: Colors.red,
      ),
      onChanged: (String? value) {
        setState(() {
          selectedResult = value;
          filteredEncuestas = encuestas.where((encuesta) => encuesta.bc_encuestaname == selectedResult).toList();
        });
      },
    );
  }

}
