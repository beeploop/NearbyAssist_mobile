import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:nearby_assist/config/constants.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/services/location_service.dart';
import 'package:nearby_assist/services/routing_service.dart';

class DestinationRoute extends StatefulWidget {
  const DestinationRoute({super.key, required this.serviceId});

  final int serviceId;

  @override
  State<StatefulWidget> createState() => _DestinationRoute();
}

class _DestinationRoute extends State<DestinationRoute> {
  final currentLocation = getIt.get<LocationService>().getLocation();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: FlutterMap(
          options: MapOptions(
            initialCenter: currentLocation,
            initialZoom: 16.0,
          ),
          children: [
            TileLayer(
              urlTemplate: tileMapProvider,
              userAgentPackageName: 'com.example.app',
            ),
            MarkerLayer(
              markers: [
                Marker(
                  rotate: true,
                  point: currentLocation,
                  child: const Icon(Icons.location_pin,
                      size: 40, color: Color.fromARGB(80, 255, 0, 0)),
                ),
              ],
            ),
            FutureBuilder(
              future: getIt.get<RoutingService>().findRoute(widget.serviceId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }

                final route = snapshot.data;

                if (route == null) {
                  return const Center(
                    child: Text('No route found'),
                  );
                }

                return PolylineLayer(
                  polylines: [
                    Polyline(
                      points: [..._constructPolylineRoute(route)],
                      color: Colors.blue,
                      strokeWidth: 4.0,
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  List<LatLng> _constructPolylineRoute(List<List<num>> route) {
    List<LatLng> coords = [];

    for (var coordinates in route) {
      coords.add(LatLng(coordinates[0].toDouble(), coordinates[1].toDouble()));
    }

    return coords;
  }
}
