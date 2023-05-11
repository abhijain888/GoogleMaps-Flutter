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
        polygons: {
          Polygon(
            polygonId: const PolygonId("1"),
            fillColor: const Color(0xFF006491).withOpacity(0.1),
            strokeWidth: 2,
            points: const [
              LatLng(23.766315, 90.425778),
              LatLng(23.764691, 90.424767),
              LatLng(23.761916, 90.426862),
              LatLng(23.758532, 90.428588),
              LatLng(23.758825, 90.429228),
              LatLng(23.763698, 90.431324),
            ],
          ),
        },
      ),
    );
  }
}
