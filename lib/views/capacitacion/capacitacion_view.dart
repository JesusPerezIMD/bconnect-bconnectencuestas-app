// ignore_for_file: file_names
import 'dart:convert';
import 'package:bconnect_capacitacion/app_route.dart';
import 'package:bconnect_capacitacion/app_theme.dart';
import 'package:bconnect_capacitacion/constants.dart';
import 'package:bconnect_capacitacion/env.dart';
import 'package:bconnect_capacitacion/views/account/account_view.dart';
import 'package:bconnect_capacitacion/views/capacitacion/info_view.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gm;
import '../../models/models.dart';
import '../../components/components.dart';
import '../../helpers/helpers.dart';
import '../../services/services.dart';
import 'package:bconnect_capacitacion/components/navigation_bar_component.dart';

class CapacitacionPage extends StatefulWidget {
  const CapacitacionPage({super.key});

  @override
  State<CapacitacionPage> createState() => _CapacitacionPageState();
}

class _CapacitacionPageState extends State<CapacitacionPage> {
  final _formKey = GlobalKey<FormState>();
  BCUser? user;
  FirebaseUser? firebaseUser;
  BCColaborador? colaborador;
  bool isValid = true;
  bool isValidCustomer = true;
  bool isLoadingButton = false;
  Customer? selectedCustomer;
  String? codigo = '';
  String? idColaborador = '';
  String? division = '';
  String? idCompania = '';
  String? compania = '';
  String? apellido_empleado = '';
  String? nombre_empleado = '';
  String? telefono = '';
  String? encuesta = '';
  Capacitacion? oencuesta;
  List<Capacitacion> encuestas = [];
  String? userid = '';
  String serviceName = Environment().SERVICE_NAME;
  String? bitacoraid = '';
  bool isLoading = false;
  List<Capacitacion> filteredEncuestas = [];
  final TextEditingController _searchController = TextEditingController();

  Future<void> getEncuestas(String division) async {
    var colemp = colaborador?.codemp;
    var result =
        await BConnectService().getCapacitacion(division, serviceName, colemp!);
    if (mounted) {
      setState(() {
        if (result.isNotEmpty) {
          encuestas = result;
          oencuesta = null;
        } else {
          encuestas = [];
          oencuesta = null;
        }
      });
    }
  }

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      if (mounted) {
        await initUser(context);
        setState(() {});
      }
    });
    super.initState();
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
      userid = user?.sId!;
      getEncuestas(userid!);
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
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: btnSave(),
          ),
          NavigationBarComponenet(0),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: 10),
              Material(
                elevation: 0.0,
                child: Container(
                  margin: const EdgeInsets.fromLTRB(8, 8, 8, 16),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Buscar Encuesta',
                      prefixIcon: Icon(Icons.search, color: Colors.grey),
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(color: Colors.grey, width: 0.5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(color: Colors.grey, width: 0.5),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        filteredEncuestas = encuestas
                            .where((encuesta) => encuesta.bc_nombre!
                                .toLowerCase()
                                .contains(value.toLowerCase()))
                            .toList();

                        oencuesta = null;
                      });
                    },
                  ),
                ),
              ),
              Expanded(
                child: filteredEncuestas.isEmpty &&
                        _searchController.text.isEmpty
                    ? ListView.builder(
                        itemCount: encuestas.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                oencuesta = encuestas[index];
                              });
                            },
                            child: Container(
                              color: oencuesta == encuestas[index]
                                  ? Colors.grey.withOpacity(0.4)
                                  : Colors.transparent,
                              child: ListTile(
                                title:
                                    Text(encuestas[index].bc_nombre.toString()),
                              ),
                            ),
                          );
                        },
                      )
                    : filteredEncuestas.isEmpty
                        ? Center(
                            child: Text(
                              "No existen datos...",
                              style:
                                  TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                          )
                        : ListView.builder(
                            itemCount: filteredEncuestas.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    oencuesta = filteredEncuestas[index];
                                  });
                                },
                                child: Container(
                                  color: oencuesta == filteredEncuestas[index]
                                      ? Colors.grey.withOpacity(0.4)
                                      : Colors.transparent,
                                  child: ListTile(
                                    title: Text(filteredEncuestas[index]
                                        .bc_nombre
                                        .toString()),
                                  ),
                                ),
                              );
                            },
                          ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void showValidForm() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(msgErrorFormulario),
        backgroundColor: Colors.red,
      ),
    );
  }

  SizedBox btnSave() {
    return SizedBox(
      width: 600,
      height: 50,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
        child: ElevatedButton(
          onPressed: oencuesta != null ? onSubmit : null,
          style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
          ),
          child: !isLoadingButton
              ? const Text(
                  'Seleccionar',
                  style: TextStyle(fontSize: 16),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      padding: const EdgeInsets.all(5.0),
                      child: const CircularProgressIndicator(
                        strokeWidth: 3,
                      ),
                    ),
                    const Text(
                      ' Procesando...',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  onSubmit() {
    if (_formKey.currentState!.validate() && isValid) {
      _formKey.currentState?.save();
      send(context);
    } else {
      showValidForm();
    }
  }

  void send(BuildContext context) async {
    setState(() {
      isLoadingButton = true;
      isValidCustomer = true;
    });

    encuesta = oencuesta?.bc_nombre;
    codigo = colaborador?.codemp;
    division = colaborador?.division;
    telefono = colaborador?.phone;
    nombre_empleado = colaborador?.names!;
    apellido_empleado = colaborador?.lastNames;
    idColaborador = colaborador?.sId;
    idCompania = colaborador?.idcia;
    compania = colaborador?.nombrecia;

    String id = await getBitacoraEncuesta(encuesta!, division!, compania!, codigo!, Environment().SERVICE_NAME, '');

    String? url = oencuesta?.bc_url?.replaceAll("[encuesta_value]", encuesta!);
    url = url?.replaceAll('[codemp_value]', codigo!);
    url = url?.replaceAll('[division_value]', division!);
    url = url?.replaceAll('[telefono_value]', telefono!);
    url = url?.replaceAll('[nombreemp_value]', nombre_empleado!);
    url = url?.replaceAll('[apellidoemp_value]', apellido_empleado!);
    url = url?.replaceAll('[uuid_value]', idColaborador!);
    url = url?.replaceAll('[idcia_value]', idCompania!);
    url = url?.replaceAll('[bitacoraid_value]', id);

    Uri uri = Uri.parse(url!);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'No se puede abrir $url';
    }

    try {
      if (defaultTargetPlatform == TargetPlatform.iOS ||
          defaultTargetPlatform == TargetPlatform.android) {
        if (!mounted) return;
      }

      if (!mounted) return;
      await Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute<void>(
              builder: (BuildContext context) => InfoPage(
                  user ?? BCUser(), selectedCustomer ?? Customer(), encuesta!)),
          (route) => false);

      setState(() {
        _formKey.currentState!.reset();
        selectedCustomer = null;
        isLoadingButton = false;
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      setState(() {
        isLoadingButton = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
          content: Text(
              "Ocurrió un error al solicitar la Encuesta. Intente de nuevo más tarde.")));
    }
  }

  Future<String> getBitacoraEncuesta(
      String encuesta,
      String division,
      String compania,
      String codemp,
      String servicename,
      String clienteid) 
      
  async {
    var result = await BConnectService().setBitacoraEncuesta(
        encuesta, division, compania, codemp, servicename, clienteid);
    if (mounted) {
      setState(() {
        bitacoraid = result;
      });
    }
    return result!;
  }

}
