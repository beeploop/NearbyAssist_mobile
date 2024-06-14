import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:nearby_assist/config/constants.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/services/routing_service.dart';

class DestinationRoute extends StatefulWidget {
  const DestinationRoute({super.key, required this.serviceId});

  final int serviceId;

  @override
  State<StatefulWidget> createState() => _DestinationRoute();
}

class _DestinationRoute extends State<DestinationRoute> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: FutureBuilder(
            future: getIt.get<RoutingService>().findRoute(widget.serviceId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              final route = snapshot.data;

              if (route == null) {
                return const Center(
                  child: Text('No route found'),
                );
              }

              return FlutterMap(
                options: MapOptions(
                  initialCenter: LatLng(
                    route[0][0].toDouble(),
                    route[0][1].toDouble(),
                  ),
                  initialZoom: 15.0,
                ),
                children: [
                  TileLayer(
                    urlTemplate: tileMapProvider,
                    userAgentPackageName: 'com.example.app',
                  ),
                  PolylineLayer(
                    polylines: [
                      Polyline(
                        points: [..._constructPolylineRoute(route)],
                        color: Colors.blue,
                        strokeWidth: 4.0,
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

  List<LatLng> _constructPolylineRoute(List<List<num>> route) {
    List<LatLng> coords = [];

    for (var coordinates in route) {
      coords.add(LatLng(coordinates[0].toDouble(), coordinates[1].toDouble()));
    }

    return coords;
  }
}
