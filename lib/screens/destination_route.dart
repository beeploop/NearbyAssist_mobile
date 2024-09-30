import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:nearby_assist/config/constants.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/services/routing_service.dart';

class DestinationRoute extends StatefulWidget {
  const DestinationRoute({super.key, required this.serviceId});

  final String serviceId;

  @override
  State<StatefulWidget> createState() => _DestinationRoute();
}

class _DestinationRoute extends State<DestinationRoute> {
  final _mapController = MapController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: FutureBuilder(
            future: getIt.get<RoutingService>().getRoute(widget.serviceId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              final route = snapshot.data;

              if (route == null || route.isEmpty) {
                return const Center(
                  child: Text('No route found'),
                );
              }

              final coords = route.map((coord) {
                return LatLng(coord[0].toDouble(), coord[1].toDouble());
              }).toList();

              return FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: LatLng(
                    route[0][0].toDouble(),
                    route[0][1].toDouble(),
                  ),
                  initialZoom: 15.0,
                  onMapReady: () {
                    _mapController.fitCamera(
                      CameraFit.coordinates(
                        coordinates: coords,
                        padding: const EdgeInsets.all(50),
                      ),
                    );
                  },
                ),
                children: [
                  TileLayer(
                    urlTemplate: tileMapProvider,
                    userAgentPackageName: 'com.example.app',
                  ),
                  PolylineLayer(
                    polylines: [
                      Polyline(
                        points: coords,
                        color: Colors.orange,
                        strokeWidth: 6.0,
                      ),
                    ],
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        rotate: true,
                        alignment: Alignment.topCenter,
                        point: LatLng(
                          route[0][0].toDouble(),
                          route[0][1].toDouble(),
                        ),
                        child: const Icon(
                          Icons.person_pin,
                          size: 30.0,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ],
              );
            }),
      ),
    );
  }
}
