import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:nearby_assist/config/constants.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/model/service_model.dart';
import 'package:nearby_assist/services/location_service.dart';
import 'package:nearby_assist/services/search_service.dart';

class CustomMap extends StatefulWidget {
  const CustomMap({super.key});

  @override
  State<CustomMap> createState() => _CustomMap();
}

class _CustomMap extends State<CustomMap> {
  final currentLocation = getIt.get<LocationService>().getLocation();

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        initialCenter: currentLocation,
        initialZoom: 16.0,
      ),
      children: [
        TileLayer(
          urlTemplate: tileMapProvider,
          userAgentPackageName: 'com.example.app',
        ),
        ListenableBuilder(
          listenable: getIt.get<SearchingService>(),
          builder: (context, child) {
            final serviceLocations =
                getIt.get<SearchingService>().getServiceLocations();

            return MarkerLayer(
              markers: [
                Marker(
                  rotate: true,
                  alignment: Alignment.topCenter,
                  point: currentLocation,
                  child: const Icon(Icons.location_pin,
                      size: 40, color: Color.fromARGB(70, 255, 0, 0)),
                ),
                ..._markerBuilder(serviceLocations),
              ],
            );
          },
        ),
        ListenableBuilder(
          listenable: getIt.get<SearchingService>(),
          builder: (context, child) {
            final radius = getIt.get<SearchingService>().getRadius();

            return CircleLayer(
              circles: [
                CircleMarker(
                  point: currentLocation,
                  radius: radius,
                  color: Colors.blue.withOpacity(0.3),
                  useRadiusInMeter: true,
                )
              ],
            );
          },
        ),
      ],
    );
  }

  List<Marker> _markerBuilder(List<Service> serviceLocations) {
    List<Marker> markers = [];

    for (var service in serviceLocations) {
      markers.add(
        Marker(
          height: 80,
          width: 60,
          rotate: true,
          alignment: Alignment.topCenter,
          point: LatLng(service.latitude, service.longitude),
          child: GestureDetector(
            onTap: () {
              context.goNamed(
                'vendor',
                queryParameters: {'serviceId': '${service.id}'},
              );
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  color: Colors.red,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  child: Text(
                    '${service.rank}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const Icon(Icons.location_pin, size: 40, color: Colors.red),
              ],
            ),
          ),
        ),
      );
    }

    return markers;
  }
}
