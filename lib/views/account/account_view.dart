import 'package:bconnect_capacitacion/models/bc_colaborador.dart';
import 'package:bconnect_capacitacion/views/encuestas/encuesta_view.dart';
import 'package:flutter/material.dart';
import 'package:bconnect_capacitacion/helpers/preferences_helper.dart';
import 'package:bconnect_capacitacion/models/bc_user.dart';

class AccountPage extends StatefulWidget {
  final BCUser user;
  final BCColaborador colaborador;
  const AccountPage(this.user, this.colaborador, {super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  void initState() {
    super.initState();
    //onSignOut(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 2,
          title: const Text('Cuenta'),
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
                      const SizedBox(
                        height: 10,
                      ),
                      _itemCaption('Código'),
                      _itemDescription(
                          Icons.numbers, widget.colaborador.codemp ?? ''),
                      const SizedBox(
                        height: 10,
                      ),
                      _itemCaption('Nombre'),
                      _itemDescription(Icons.person,
                          '${widget.colaborador.names ?? ''} ${widget.colaborador.lastNames ?? ''}'),
                      const SizedBox(
                        height: 20,
                      ),
                      btnSignOut(),
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

  SizedBox btnSignOut() {
    return SizedBox(
        width: 250,
        height: 40,
        child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: ElevatedButton(
              onPressed: () async {
                await onSignOut(context);
                if (!mounted) return;
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute<void>(
                        builder: (BuildContext context) =>
                            const CapacitacionPage()),
                    (route) => false);
              },
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.red[700]),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)))),
              child: const Text(
                'Cerrar Sesión',
                style: TextStyle(color: Colors.white),
              ),
            )));
  }
}
