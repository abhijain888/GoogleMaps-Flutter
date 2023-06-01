import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_maps_widget/google_maps_widget.dart';
import 'api_keys.dart';

class PolylinesMap extends StatefulWidget {
  const PolylinesMap({super.key});

  @override
  State<PolylinesMap> createState() => _PolylinesMapState();
}

class _PolylinesMapState extends State<PolylinesMap> {
  final mapsWidgetController = GlobalKey<GoogleMapsWidgetState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: GoogleMapsWidget(
                apiKey: APIKey.mapsApiKey,
                key: mapsWidgetController,
                sourceLatLng: const LatLng(
                  40.484000837597925,
                  -3.369978368282318,
                ),
                destinationLatLng: const LatLng(
                  40.48017307700204,
                  -3.3618026599287987,
                ),

                ///////////////////////////////////////////////////////
                //////////////    OPTIONAL PARAMETERS    //////////////
                ///////////////////////////////////////////////////////

                routeWidth: 2,
                sourceMarkerIconInfo: MarkerIconInfo(
                  infoWindowTitle: "This is source name",
                  onTapInfoWindow: (_) {
                    print("Tapped on source info window");
                  },
                  assetPath: "assets/images/house-marker-icon.png",
                ),
                destinationMarkerIconInfo: const MarkerIconInfo(
                  assetPath: "assets/images/restaurant-marker-icon.png",
                ),
                driverMarkerIconInfo: MarkerIconInfo(
                  infoWindowTitle: "Alex",
                  assetPath: "assets/images/driver-marker-icon.png",
                  onTapMarker: (currentLocation) {
                    print("Driver is currently at $currentLocation");
                  },
                  assetMarkerSize: const Size.square(125),
                  rotation: 90,
                ),
                onPolylineUpdate: (p) {
                  print("Polyline updated: ${p.points}");
                },
                updatePolylinesOnDriverLocUpdate: true,
                // mock stream
                driverCoordinatesStream: Stream.periodic(
                  const Duration(milliseconds: 5500),
                  (i) => LatLng(
                    40.47747872288886 + i / 10000,
                    -3.368043154478073 - i / 10000,
                  ),
                ),
                totalTimeCallback: (time) => print(time),
                totalDistanceCallback: (distance) => print(distance),
              ),
            ),
            // demonstrates how to interact with the controller
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        mapsWidgetController.currentState!.setSourceLatLng(
                          LatLng(
                            40.484000837597925 * (Random().nextDouble()),
                            -3.369978368282318,
                          ),
                        );
                      },
                      child: const Text('Update source'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        final googleMapsCon = await mapsWidgetController
                            .currentState!
                            .getGoogleMapsController();
                        googleMapsCon.showMarkerInfoWindow(
                          MarkerIconInfo.sourceMarkerId,
                        );
                      },
                      child: const Text('Show source info'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
