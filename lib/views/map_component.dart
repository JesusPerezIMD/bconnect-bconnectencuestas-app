import 'dart:async';
import 'package:bconnect_capacitacion/env.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class MapComponent extends StatefulWidget {
  const MapComponent({super.key});

  @override
  State<MapComponent> createState() => _MapComponentState();
}

class _MapComponentState extends State<MapComponent> {
  final Completer<GoogleMapController> _controller = Completer();
  LatLng _center = Environment().DEFAULT_LOCATION;
  final Set<Marker> _markers = <Marker>{};
  Marker? lastMarker;
  bool _isLoading = true;
  int cont = 0;

  Future<void> getUserCurrentLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) async {
      await Geolocator.requestPermission();
    });

    Position location;
    try {
      location = await Geolocator.getCurrentPosition();
      _center = LatLng(location.latitude, location.longitude);
      // ignore: empty_catches
    } catch (e) {}
    setState(() {
      _isLoading = false;
    });
    _addMarker(_center);
  }

  @override
  void initState() {
    super.initState();
    getUserCurrentLocation();
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  void _addMarker(LatLng pos) {
    if (lastMarker != null) _markers.remove(lastMarker);

    setState(() {
      MarkerId markerId = MarkerId('position$cont');
      Marker? newMarker = Marker(
          markerId: markerId,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          position: pos);
      _markers.add(newMarker);
      lastMarker = newMarker;
      cont = cont + 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Seleccionar ubicación')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(children: <Widget>[
              FractionallySizedBox(
                  heightFactor: 0.9,
                  child: GoogleMap(
                      onMapCreated: _onMapCreated,
                      myLocationEnabled: true,
                      compassEnabled: true,
                      initialCameraPosition: CameraPosition(
                        target: _center,
                        zoom: 15.0,
                      ),
                      markers: Set<Marker>.of(_markers),
                      onTap: (LatLng latLng) {
                        _addMarker(latLng);
                      })),
              Container(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: btnSelectLocation(),
                ),
              )
            ]),
    );
  }

  SizedBox btnSelectLocation() {
    return SizedBox(
        width: 400,
        height: 40,
        //height: getProportionatedScreenHeight(50),
        child: Container(
            height: 40,
            decoration: const BoxDecoration(
                backgroundBlendMode: BlendMode.color, color: Colors.white),
            child: ElevatedButton(
                onPressed: () {
                  //getLocation(context);
                },
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color(0xFFF37733)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)))),
                child: const Text('Confirmar ubicación'))));
  }
}
