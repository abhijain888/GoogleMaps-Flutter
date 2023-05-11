import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MyHomePage extends StatelessWidget {
  MyHomePage({super.key});

  final Completer<GoogleMapController> _completer = Completer();
  late GoogleMapController _googleMapController;
  late final CameraPosition initialCameraPosition = CameraPosition(
    target: intialLocation, // LatLng(28.6139, 77.2090),
    zoom: 15.5,
    tilt: 4,
  );

  LatLng intialLocation = const LatLng(23.762912, 90.427816);

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
        markers: {
          Marker(
            markerId: const MarkerId("1"),
            position: intialLocation,
          ),
        },
        circles: {
          Circle(
            circleId: const CircleId("1"),
            center: intialLocation,
            radius: 420,
            strokeWidth: 2,
            fillColor: const Color(0xFF006491).withOpacity(0.2),
          ),
        },
      ),
    );
  }
}
