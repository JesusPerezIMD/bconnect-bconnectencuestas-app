import 'package:bconnect_capacitacion/views/capacitacion/capacitacion_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:bconnect_capacitacion/env.dart';
import 'package:bconnect_capacitacion/helpers/preferences_helper.dart';
import 'package:bconnect_capacitacion/models/bc_user.dart';
import 'package:bconnect_capacitacion/models/customer.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import 'package:bconnect_capacitacion/views/capacitacion/historial_view.dart';

class InfoPage extends StatefulWidget {
  final BCUser user;
  final Customer customer;
  final String encuesta;
  const InfoPage(this.user, this.customer, this.encuesta, {super.key});

  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  String whatsappNumber = Environment().WHATSAPP_NUMBER;
  final formatCurrency =
      NumberFormat.currency(locale: 'es_MX', symbol: '', decimalDigits: 2);

  @override
  void initState() {
    super.initState();
    //onSignOut(onSignOut);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('BConnect - Capacitación'),
          elevation: 2,
        ),
        body: SingleChildScrollView(
            padding: const EdgeInsets.all(10),
            child: ConstrainedBox(
                constraints: const BoxConstraints(
                  minHeight: 500,
                ),
                child: Padding(
                    padding: const EdgeInsets.all(0),
                    child: Column(children: [
                      ListTile(
                        title: Text(
                            'Gracias ${widget.user.names?.split(' ')[0] ?? ''}, gracias por responder la capacitación.'),
                      ),
                      ListTile(
                        title: Text('Solicitud:  ${widget.encuesta}'),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      _itemCaption('Fecha y Hora'),
                      _itemDescription(
                          Icons.event,
                          DateFormat('dd/MMMM/yyyy h:mm a', 'es')
                              .format(DateTime.now() ?? DateTime.now())),
                      const SizedBox(
                        height: 20,
                      ),
                      btnHome(),
                      const SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: SizedBox(
                          width: 250,
                          height: 40,
                          child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Colors.green[700]),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0)))),
                            onPressed: _launchWhatsApp,
                            child: const Text(
                              'Regresar a WhatsApp',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ])))));
  }

  Widget _itemCaption(String caption) {
    return Row(
      children: [
        const SizedBox(width: 40),
        const SizedBox(width: 5),
        Text(
          caption,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        )
      ],
    );
  }

  Widget _itemDescription(IconData icon, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 40,
          child: Icon(icon, size: 20),
        ),
        const SizedBox(width: 5),
        Flexible(
          child: Padding(
            padding: const EdgeInsets.only(top: 1),
            child: Text(
              description,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        )
      ],
    );
  }

  Future<void> _launchWhatsApp() async {
    final url = Uri.parse('https://wa.me/%2b$whatsappNumber');
    if (!await launchUrl(url)) {
      throw Exception('Could not launch url');
    }
  }

  Future<void> onSignOut(BuildContext context) async {
    await removePreferences();
  }

  Future<void> removePreferences() async {
    await PreferencesHelper.remove('token');
    await PreferencesHelper.remove('userkey');
    await PreferencesHelper.remove('user');
    await PreferencesHelper.remove('firebase_user');
    await PreferencesHelper.remove('colaborador');
  }

  SizedBox btnHome() {
    return SizedBox(
        width: 250,
        height: 40,
        //height: getProportionatedScreenHeight(50),
        child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute<void>(
                        builder: (BuildContext context) =>
                            const CapacitacionPage()),
                    (route) => false);
              },
              style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)))),
              child: const Text(
                'Nueva Capacitación',
                style: TextStyle(color: Colors.white),
              ),
            )));
  }

  SizedBox btnHistory() {
    return SizedBox(
        width: 250,
        height: 40,
        //height: getProportionatedScreenHeight(50),
        child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute<void>(
                        builder: (BuildContext context) =>
                            const HistorialCapacitacionPage()),
                    (route) => false);
              },
              style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)))),
              child: const Text(
                'Historial de Reportes',
                style: TextStyle(color: Colors.white),
              ),
            )));
  }
}
