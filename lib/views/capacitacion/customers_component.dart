import 'dart:async';
import 'dart:math';
import 'package:bconnect_capacitacion/helpers/gps_helper.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gm;
import 'package:bconnect_capacitacion/env.dart';
import 'package:bconnect_capacitacion/models/customer.dart';
import 'package:bconnect_capacitacion/services/bconnect_service.dart';

class CustomersComponent extends StatefulWidget {
  final Customer? selectedCustomer;
  final String? codemp;
  final String? division;
  final String? compania;
  final String? sId;
  final String? sIdEncuesta;

  const CustomersComponent(
      {super.key,
      this.selectedCustomer,
      this.codemp,
      this.division,
      this.compania,
      this.sId,
      this.sIdEncuesta});

  @override
  State<CustomersComponent> createState() => _CustomersComponentState();
}

class _CustomersComponentState extends State<CustomersComponent>
    with TickerProviderStateMixin {
  Timer? debounce;
  final searchController = TextEditingController();
  String lastTextSearch = '';
  late AnimationController animationController;
  List<Customer> customers = [];
  bool loadingCustomers = true;
  bool filtered = false;
  gm.LatLng? currentLocation;
  gm.LatLng? gpsLocation;
  bool isActiveGPS = false;
  Random random = Random();

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      gpsPosition();
    });
    super.initState();
    searchController.addListener(searchOnChange);
    animationController = BottomSheet.createAnimationController(this);
    animationController.duration = const Duration(seconds: 0);
    animationController.reverseDuration = const Duration(seconds: 0);
  }

  @override
  void dispose() {
    debounce?.cancel();
    searchController.dispose();
    animationController.dispose();
    super.dispose();
  }

  Future<void> gpsPosition() async {
    await GpsHelper.gpsPosition().then((position) async {
      currentLocation = gm.LatLng(position.latitude, position.longitude);
      gpsLocation = gm.LatLng(position.latitude, position.longitude);
      isActiveGPS = true;
      await getCustomers('', 0);
    }).catchError((error, stackTrace) async {
      debugPrint(error);
      setState(() {
        loadingCustomers = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        color: Colors.transparent,
        margin: const EdgeInsets.only(top: 15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            textFieldSearch(),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: ListView(
                shrinkWrap: true,
                // physics: const NeverScrollableScrollPhysics(),
                children: [
                  ...(loadingCustomers
                      ? [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: const [
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 5),
                                child: CircularProgressIndicator(),
                              ),
                            ],
                          )
                        ]
                      : (filtered ? listFilterCustomers() : listCustomers())),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void searchOnChange() {
    if (debounce?.isActive ?? false) debounce?.cancel();
    debounce = Timer(const Duration(milliseconds: 200), () async {
      if (searchController.text != lastTextSearch) {
        lastTextSearch = searchController.text.trim();
        filtered = lastTextSearch.isNotEmpty;
        await getCustomers(lastTextSearch, lastTextSearch == '' ? 0 : 0);
      }
    });
  }

  Future<void> getCustomers(String value, int maxDistance) async {
    setState(() {
      loadingCustomers = true;
    });
    var result = await BConnectService().getCustomers(
        value,
        currentLocation?.longitude ?? Environment().DEFAULT_LOCATION.longitude,
        currentLocation?.latitude ?? Environment().DEFAULT_LOCATION.latitude,
        20,
        maxDistance,
        widget.codemp ?? '',
        widget.division ?? '',
        widget.compania ?? '',
        widget.sId ?? '',
        widget.sIdEncuesta ?? '');
    if (mounted) {
      setState(() {
        customers = result;
        customers.sort((a, b) {
          if (a.censado == b.censado) {
            return 0;
          } else if (a.censado ?? false) {
            return 1;
          } else {
            return -1;
          }
        });
        loadingCustomers = false;
      });
    }
  }

  Widget textFieldSearch() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: TextField(
        controller: searchController,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          hintStyle: TextStyle(color: Colors.grey[500]),
          hintText: "Buscar tienda o establecimiento",
          isDense: true,
          prefixIcon: const Padding(
              padding: EdgeInsets.only(left: 10, right: 5),
              child: Icon(
                Icons.search,
                size: 24,
              )),
          suffixIcon: filtered
              ? Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: searchController.clear),
                )
              : null,
        ),
      ),
    );
  }

  List<Widget> listFilterCustomers() {
    return customers.isEmpty
        ? [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'No se encontraron clientes activos',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
          ]
        : [
            ...customers
                .map((customer) => ListTile(
                      leading: customer.censado ?? false
                          ? CircleAvatar(
                              backgroundColor: Colors.green[400],
                              radius: 14,
                              child: const Icon(
                                Icons.done,
                                color: Colors.white,
                                size: 18,
                              ),
                            )
                          : CircleAvatar(
                              backgroundColor: Colors.grey[300],
                              radius: 14,
                              child: const Icon(
                                Icons.location_on,
                                color: Colors.grey,
                                size: 18,
                              ),
                            ),
                      title: Text(
                          '${(customer.fullName ?? '').toUpperCase()} (${customer.id ?? ''})'),
                      subtitle: Text(
                        '${!isActiveGPS ? '' : '${getTextDistance(customer.distance ?? 0)} - '}${('${(customer.address ?? '')} ${(customer.colonyName ?? '')}\n${(customer.municipalityName ?? '').toUpperCase()}, ${(customer.stateName ?? '').toUpperCase()}').trim()}',
                        style: const TextStyle(fontSize: 12),
                      ),
                      onTap: () async {
                        if (!mounted) return;
                        final Map<String, dynamic> dataReponse = {
                          "customer": customer,
                          "gps": gpsLocation,
                        };
                        Navigator.pop(context, dataReponse);
                      },
                    ))
                .toList()
          ];
  }

  List<Widget> listCustomers() {
    return customers.isEmpty
        ? [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'No tienes clientes activos',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
          ]
        : [
            ...customers
                .map((customer) => ListTile(
                      leading: customer.censado ?? false
                          ? CircleAvatar(
                              backgroundColor: Colors.green[400],
                              radius: 14,
                              child: const Icon(
                                Icons.done,
                                color: Colors.white,
                                size: 18,
                              ),
                            )
                          : CircleAvatar(
                              backgroundColor: Colors.grey[300],
                              radius: 14,
                              child: const Icon(
                                Icons.location_on,
                                color: Colors.grey,
                                size: 18,
                              ),
                            ),
                      isThreeLine: true,
                      title: Text(
                          '${(customer.fullName ?? '').toUpperCase()} (${customer.id ?? ''})'),
                      subtitle: Text(
                        '${getTextDistance(customer.distance ?? 0)} - ${('${(customer.address ?? '')} ${(customer.colonyName ?? '')}\n${(customer.municipalityName ?? '').toUpperCase()}, ${(customer.stateName ?? '').toUpperCase()}').trim()}',
                        style: const TextStyle(fontSize: 12),
                      ),
                      onTap: () {
                        if (!mounted) return;
                        final Map<String, dynamic> dataReponse = {
                          "customer": customer,
                          "gps": gpsLocation,
                        };
                        Navigator.pop(context, dataReponse);
                      },
                    ))
                .toList()
          ];
  }

  String getTextDistance(num num) {
    String unit = '';
    String value = '';

    if (num < 1000) {
      unit = 'm';
      value = ((num / 100).truncate() * 100).toString();
      if (value == '0') value = '100';
    } else {
      unit = 'km';
      value = ((num / 1000).truncate()).toString();
      value = (double.parse(value) +
              ((num - (int.parse(value) * 1000)).truncate() / 100).truncate() /
                  10)
          .toString();
    }

    return '${value.toString()} $unit';
  }
}
