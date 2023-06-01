import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_google_maps/api_keys.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:location/location.dart';

class MapsDirections extends StatefulWidget {
  const MapsDirections({super.key});

  @override
  State<MapsDirections> createState() => _MapsDirectionsState();
}

class _MapsDirectionsState extends State<MapsDirections> {
  final Completer<GoogleMapController> _controller = Completer();

  LatLng sourceLoc = const LatLng(28.6163, 77.3772);
  LatLng destinationLoc = const LatLng(28.6181, 77.3705);

  Location location = Location();

  List<LatLng> polylineCoordinates = [];
  LocationData? currentLocation;

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
    getPolyPoints();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Directions in Maps"),
        actions: [
          IconButton(
            onPressed: () {
              getPolyPoints();
            },
            icon: const Icon(Icons.download),
          ),
        ],
      ),
      body: SafeArea(
        child: currentLocation == null
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                    currentLocation!.latitude!,
                    currentLocation!.longitude!,
                  ),
                  zoom: 15,
                ),
                onMapCreated: (controller) async {
                  _controller.complete(controller);

                  GoogleMapController googleMapController =
                      await _controller.future;

                  location.onLocationChanged.listen((newLoc) {
                    currentLocation = newLoc;

                    googleMapController.animateCamera(
                      CameraUpdate.newCameraPosition(
                        CameraPosition(
                          target: LatLng(
                            currentLocation!.latitude!,
                            currentLocation!.longitude!,
                          ),
                          zoom: 14,
                        ),
                      ),
                    );

                    setState(() {});
                  });
                },
                polylines: {
                  Polyline(
                    polylineId: const PolylineId("route"),
                    points: polylineCoordinates,
                    width: 2,
                    color: Colors.purple.shade800,
                    visible: true,
                  ),
                },
                markers: {
                  Marker(
                    markerId: const MarkerId("current_location"),
                    position: LatLng(
                      currentLocation!.latitude!,
                      currentLocation!.longitude!,
                    ),
                  ),
                  Marker(
                    markerId: const MarkerId("source_id"),
                    position: sourceLoc,
                  ),
                  Marker(
                    markerId: const MarkerId("destination_id"),
                    position: destinationLoc,
                  ),
                },
              ),
      ),
    );
  }

  void getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      APIKey.mapsApiKey,
      PointLatLng(sourceLoc.latitude, sourceLoc.longitude),
      PointLatLng(destinationLoc.latitude, destinationLoc.longitude),
      travelMode: TravelMode.driving,
    );

    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polylineCoordinates.add(
          LatLng(
            point.latitude,
            point.longitude,
          ),
        );
      }
      setState(() {});
    }
  }

  void getCurrentLocation() async {
    location.getLocation().then((location) => currentLocation = location);
  }
}
