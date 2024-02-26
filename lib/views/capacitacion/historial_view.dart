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
import '../../models/response_capacitaciondnc.dart';
import '../../models/response_capacitacion.dart';
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
  List<SolicitudCapacitacion> listResponsecapacitacion = [];
  List<SolicitudCapacitacionDNC> listResponsecapacitacionDNC = [];
  List<EstatusSolicitudCapacitacion> listEstatus = [];
  final _formKey = GlobalKey<FormState>();
  BCUser? user;
  FirebaseUser? firebaseUser;
  BCColaborador? colaborador;
  bool loadingReports = true;
  String variablemonto2="Solicitudes aprobacion 2";
  String aprobadorCapacitacion="Aprobador Capacitación";
  double monto2=0;
  String nameCapacitacion="";
  final formatCurrency =
      NumberFormat.currency(locale: 'es_MX', symbol: '', decimalDigits: 2);
  String selectedEstatus = 'Todos';
  List<String> estatusOptions = [
    'Todos',
    'Creada',
    'Aprobada Supervisor',
    'Aprobada Supervisor Grupo',
    'Aprobada Capacitación',
    'Cerrada',
    'Rechazada',
  ];
  ListTileTitleAlignment? titleAlignment; 
  Capacitacion? oencuesta;
  List<Capacitacion> encuestas = [];
  String? userid = '';
  bool bCapacitacionBM = false;
  String serviceName=Environment().SERVICE_NAME;
  String codemp ='';

  Future<void> getCapacitacion(String codemp,String status) async {
    var result = await BConnectService().getResponseCapacitacion(codemp,status);
    if (mounted) {
      setState(() {
        listResponsecapacitacion = result;
        loadingReports = false;
      });
    }
  }

  Future<void> getCapacitacionDNC(String codemp) async {
    var resultDNC = await BConnectService().getResponseCapacitacionDNC(codemp);
    if (mounted) {
      setState(() {
        listResponsecapacitacionDNC = resultDNC;
        loadingReports = false;
      });
    }
  }

  Future<void> getReglasAprobacion() async {
    var result = await BConnectService().getReglasAprobacion();
    if (mounted) {
      setState(() {
        var fila = result?.where((element) => element.name == variablemonto2)
            .toList().first;
        var monto=fila?.valor;
            monto2=double.parse(monto!);
        var fila2 = result?.where((element) => element.name == aprobadorCapacitacion)
            .toList().first;
        var name=fila2?.valor;
            nameCapacitacion=name!;
        loadingReports = false;
      });
    }
  }

  Future<void> getEstatus(String id) async {
    var result = await BConnectService().getDetallesCapacitacion(id);
    if (mounted) {
      setState(() {
       listEstatus = result;
        loadingReports = false;
      });
    }
  }

  Future<void> getEncuestas(String division) async {
    codemp = colaborador!.codemp!;
    var result = await BConnectService().getCapacitacion(division, serviceName, codemp);

    if (mounted) {
      setState(() {
        if (result.isNotEmpty) {
          //result.sort((a, b) => (a.bc_nombre ?? '').compareTo(b.bc_nombre ?? ''));
          encuestas = result;
          oencuesta = encuestas.first;
        } else {
          encuestas = [];
          oencuesta = null;
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      await initUser(context);
      codemp = colaborador!.codemp!;
      userid = user?.sId!;
      await getEncuestas(userid!);

      if (oencuesta == null) {
        if (mounted) {
          setState(() {
            loadingReports = false;
          });
        }
        return;
      }
      if (oencuesta?.orden == 0) {
        await getReglasAprobacion();
        await getCapacitacion(codemp, selectedEstatus);
        bCapacitacionBM = true;
      } else if (oencuesta?.orden == 1) {
        await getCapacitacionDNC(codemp);
        bCapacitacionBM = false;
      } 

      if (mounted) {
        setState(() {
          loadingReports = false;
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
     
    } catch (e) {
      await Navigator.pushNamedAndRemoveUntil(
          context, AppRoute.loginRoute, (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> listaCapacitaciones = listReports();

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
      bottomNavigationBar: const NavigationBarComponenet(1),
      body: loadingReports
          ? const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: CircularProgressIndicator(),
              ),
            )
          : ListView.builder(
              itemCount: listaCapacitaciones.length + 1, // +1 por el widget de filtro
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Padding(
                    padding: const EdgeInsets.all(6),
                    child: filtros());
                }
                return listaCapacitaciones[index - 1];
              },
            ),
    );
  }

  RichText subtitle(SolicitudCapacitacion solicitud){
    var aprobador='${solicitud.siguienteAutorizador}\n';   
   
    return RichText(
      text: TextSpan(
        text: 'Pendiente por Aprobar: ',
        style: const TextStyle(color: Colors.grey),
        children: <TextSpan>[
          TextSpan(text: aprobador,style: const TextStyle(  color: Colors.black, ),),
          const TextSpan(text: 'Estatus: ',style: TextStyle(color:  Colors.grey)),
          TextSpan(text: '${solicitud.estatusname}\n',style: const TextStyle(color: Colors.black)),
          const TextSpan(text: 'Fecha: ',style: TextStyle(color:  Colors.grey)),
          TextSpan(text: '${getDateLocal(solicitud.createdon ?? DateTime.now())} ${getTimeLocal(solicitud.createdon ?? DateTime.now())}',style: const TextStyle(color: Colors.black)),
        ],
      ),
    );
  }

  RichText title(SolicitudCapacitacion solicitud){
    return RichText(
      text: TextSpan(
        text: 'Folio: ',
        style: const TextStyle(color:  Colors.grey),
        children: <TextSpan>[
          TextSpan(text: solicitud.name,style: const TextStyle(  color: Colors.black, ),),
          const TextSpan(text: '\nCurso: ',style: TextStyle(color:  Colors.grey)),
          TextSpan(text: solicitud.capacitacion,style: const TextStyle(color: Colors.black)),
          
        ],
      ),
    );
  }

  List<Widget> listReports() {
    if (listResponsecapacitacion.isEmpty && listResponsecapacitacionDNC.isEmpty) {
      return [
        Padding(
          padding: const EdgeInsets.all(10),
          child: Text(
            'No tienes Solicitudes registradas',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ),
      ];
    } else {
      return bCapacitacionBM ? listPreviousReports() : listDNCCapacitacion();
    }
  }

  Color? colorEstatus(SolicitudCapacitacion solicitud){
      switch(solicitud.estatusname) {
        case "Rechazada":
        return Colors.yellow[100];
        case "Creada":
        case "Cerrada":
        return Colors.blue[100];
        case "Aprobada Supervisor":
        case "Aprobada Supervisor Grupo":
        case "Aprobada Capacitación":
        return  Colors.green[100];
        default:
        return  Colors.grey[100]; 
      }
  }

  Widget iconEstatus(SolicitudCapacitacion solicitud){
    var icon2;
      switch(solicitud.estatusname) {
        case "Rechazada":
        icon2 = const Icon(
                          Icons.clear,
                          color: Colors.yellow,
                          size: 18,
                        );
        break;
        case "Creada":
        icon2 = const Icon(
                          Icons.add,
                          color: Colors.blue,
                          size: 18,
                        );
        break;
        case "Cerrada":
        icon2 = const Icon(
                          Icons.assistant_photo,
                          color: Colors.blue,
                          size: 18,
                        );
        break;
        case "Aprobada Supervisor":
        icon2 = const Icon(
                          Icons.done,
                          color: Colors.green,
                          size: 18,
                        );
        break;
        case "Aprobada Supervisor Grupo":
        icon2 = const Icon(
                          Icons.done_all,
                          color: Colors.green,
                          size: 18,
                        );
        break;
        case "Aprobada Capacitación":
        icon2 = const Icon(
                          Icons.check_circle,
                          color: Colors.green,
                          size: 18,
                        );
        break;
        default:
        icon2 = const Icon(
                          Icons.info_outline,
                          color: Colors.grey,
                          size: 18,
                        );
        break;
      }
      return CircleAvatar(
                        backgroundColor: colorEstatus(solicitud),
                        radius: 14,
                        child: icon2,
                      );
  }
  
  List<Widget> estatusSolicitud() {
    var list = <Widget>[];
    var count =0;
    for (var estatus in listEstatus) {
      var name=estatus.estatusname;
      var autorizador =estatus.autorizador ?? "";
      count++;
      list.add(SimpleDialogOption(
        child: ListTile(
                    title: Text('Estatus: ${name!}'),
                  subtitle: Text('Autorizador: $autorizador\n Fecha: ${getDateLocal(estatus.createdon ?? DateTime.now())} ${getTimeLocal(estatus.createdon ?? DateTime.now())}'),
                  ),                
      ));
      if(count!=listEstatus.length){
          list.add(const Divider(height: 0));
      }       
    }
  return  list;
  }

  List<Widget> listTodayReports() {
    List<Widget> list = [];
    var reports = listResponsecapacitacion.where((report) =>
        DateUtils.isSameDay(
            DateTime.now().toUtc(), (report.createdon ?? DateTime.now())));
    if (reports.isNotEmpty) {
      list.add(Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: Text(
          'Reportes del día',
          style: TextStyle(color: Colors.grey[600]),
        ),
      ));
      list.addAll(reports.map((report) => Column(
            children: <Widget>[
              ListTile(
                contentPadding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                leading: SizedBox(
                  height: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [  iconEstatus(report),],
                  ),
                ),
                trailing: SizedBox(
                  height: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        getDateLocal(report.createdon ?? DateTime.now()),
                        style: const TextStyle(fontSize: 10),
                      ),
                      Text(
                        getTimeLocal(report.createdon ?? DateTime.now()),
                        style: const TextStyle(fontSize: 10),
                      ),
                    ],
                  ),
                ),
                title: Text('${report.name ?? ''} ${report.capacitacion}'),
                subtitle: Text('Estatus: ${report.estatusname}'
                    '  Aprobadores: ${report.aprobador1name}, ${report.aprobador2name}'),
                isThreeLine: true,
              ),
              const Divider(height: 0),
            ],
          )));
    }
    return list;
  }

  List<Widget> listPreviousReports() {
    List<Widget> list = [];
    var reports = listResponsecapacitacion;
    if (reports.isNotEmpty) {
      //list.add(Padding(
        //padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        //child: Text(
          //'Solicitudes de Capacitación',
          //style: TextStyle(color: Colors.grey[600], fontSize: 18,),
        //),
      //));
      
      list.addAll(reports.map((report) => Column(
            children: <Widget>[
              ListTile(
                contentPadding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                leading: SizedBox(
                  height: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                     iconEstatus(report),
                    ],
                  ),
                ),   
              trailing: FloatingActionButton(
                  onPressed:() async {
                    listEstatus = [];
                    var id=report.solicituddecapacitacionid;
                      await getEstatus(id!);
                    _showDialog();
                  },
                  tooltip: 'Lista de estatus',
                  child: const Icon(Icons.more_vert),
                ),
                title: title(report),
                subtitle: subtitle(report),
                isThreeLine: true,
              ),
              const Divider(height: 0),
            ],
          )));
    }
    return list;
  }

  List<Widget> listDNCCapacitacion() {
    List<Widget> list = [];
    var reportsDNC = listResponsecapacitacionDNC;
    if (reportsDNC.isNotEmpty) {
      //list.add(Padding(
        //padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        //child: Text(
          //'DNC Administrativos Plan de Capacitación',
         // style: TextStyle(color: Colors.grey[600], fontSize: 18),
       // ),
      //));
      list.addAll(reportsDNC.map((report) => Column(
            children: <Widget>[
              ListTile(
                contentPadding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                leading: SizedBox(
                  height: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.green[300], // Color verde para el círculo
                        radius: 14,
                        child: const Icon(
                          Icons.check, // Ícono de palomita
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ],
                  ),
                ),
                trailing: SizedBox(
                  height: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        getDateLocal(report.createdon ?? DateTime.now()),
                        style: const TextStyle(color: Colors.grey),
                      ),
                      Text(
                        getTimeLocal(report.createdon ?? DateTime.now()),
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                title: Text('Folio: ${report.bc_folio}'),
                subtitle: Text(
                  'DNC Area: ${report.bc_dncareaname}\nComentarios: ${report.bc_comentarios}',
                ),
                isThreeLine: true,
              ),
              const Divider(height: 0),
            ],
          )));
    }
    return list;
  }

 _showDialog() {
    showDialog(
      context: context,
      builder: (_) {
        return SimpleDialog(
          //title: const Text("Lista de estatus"),
          children: estatusSolicitud(),
        );
      },
    );
  }
  
  String getDateLocal(DateTime utc) {
    return DateFormat('dd/MM/yyyy', 'es').format(
        DateFormat('yyyy-MM-dd HH:mm:ss')
            .parse(utc.toString(), true)
            .toLocal());
  }

  String getTimeLocal(DateTime utc) {
    return DateFormat('h:mm a', 'es').format(DateFormat('yyyy-MM-dd HH:mm:ss')
        .parse(utc.toString(), true)
        .toLocal());
  }

  Form filtros() {
    return Form(
        key: _formKey,
        child: Column(children: [
          const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Capacitación*",
            style: TextStyle(
                color: Color.fromARGB(255, 0, 0, 0),
                fontSize: 14,
                fontWeight: FontWeight.bold),
          )),         
          Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: ddlEncuestas()
          ),
          Visibility(
            visible: bCapacitacionBM,
            child: const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Estatus*",
              style: TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontSize: 14,
                  fontWeight: FontWeight.bold),
            )),
          ), 
          Visibility(
            visible: bCapacitacionBM,
            child: Padding(
            padding: 
            const EdgeInsets.only(bottom: 5), child: ddlEstatus()
            ),
          ),     
    ]));
  }

 DropdownButtonFormField ddlEstatus() {
  return DropdownButtonFormField(
    decoration: const InputDecoration(
        hintText: 'Seleccione una Estatus',
        border: InputBorder.none,
        filled: false,
        fillColor: Color.fromRGBO(204, 204, 204, 80),
        hintStyle: TextStyle(fontWeight: FontWeight.bold)),
    value: selectedEstatus,
    items: estatusOptions.map((item) {
      return DropdownMenuItem(
        value: item,
        child: Text(item),
      );
    }).toList(),
    icon: const Icon(
      Icons.expand_more,
      color: Colors.red,
    ),
    validator: (value) => value == null ? 'Seleccione una Estatus' : null,
    onChanged: (value) {
      setState(() {
        selectedEstatus = value;
        var colemp=colaborador?.codemp;
        getCapacitacion(colemp!,selectedEstatus);
      });
    });
  }

  DropdownButtonFormField ddlEncuestas() {
    return DropdownButtonFormField(
      decoration: const InputDecoration(
          hintText: 'Seleccione una capacitación',
          border: InputBorder.none,
          filled: false,
          fillColor: Color.fromRGBO(204, 204, 204, 80),
          hintStyle: TextStyle(fontWeight: FontWeight.bold)),
      value: oencuesta,
      items: encuestas.isNotEmpty
        ? encuestas.map((item) {
            return DropdownMenuItem(
              value: item,
              child: Text(item.bc_nombre.toString()),
            );
          }).toList()
        : [const DropdownMenuItem(
            value: "NoData",
            child: Text("No existen datos"),
          )],
      icon: const Icon(
        Icons.expand_more,
        color: Colors.red,
      ),
      validator: (value) {
        if (value == "NoData") {
          return 'No hay datos disponibles';
        }
        if (value == null) {
          return 'Seleccione una capacitación';
        }
        return null;
      },
      onChanged: (value) {
        setState(() {
          if (value == "NoData") {
            return;
          }
          oencuesta = value;
          if (oencuesta?.orden == 0) {
            bCapacitacionBM = true;
            listResponsecapacitacion = [];
            listResponsecapacitacionDNC = [];
            getCapacitacion(codemp, selectedEstatus);
           
          } else if (oencuesta?.orden == 1) {
            bCapacitacionBM = false;
            listResponsecapacitacion = [];
            listResponsecapacitacionDNC = [];
            getCapacitacionDNC(codemp);
          } else {
            bCapacitacionBM = false;
            listResponsecapacitacion = [];
            listResponsecapacitacionDNC = [];
          }
        });
      }
    );
  }
}
