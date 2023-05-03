import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MyHomePage extends StatelessWidget {
  MyHomePage({super.key});

  final Completer<GoogleMapController> _completer = Completer();
  late GoogleMapController _googleMapController;
  late final CameraPosition initialCameraPosition = const CameraPosition(
    target: LatLng(28.6139, 77.2090),
    zoom: 13,
    tilt: 4,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Google Maps"),
      ),
      body: GoogleMap(
        initialCameraPosition: initialCameraPosition,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        compassEnabled: true,
        zoomControlsEnabled: false,
        onMapCreated: (controller) {
          _completer.complete(controller);
          _googleMapController = controller;
        },
      ),
    );
  }
}
