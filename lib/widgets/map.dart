import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:nearby_assist/config/constants.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/services/location_service.dart';
import 'package:nearby_assist/services/search_service.dart';

class CustomMap extends StatefulWidget {
  const CustomMap({super.key});

  @override
  State<CustomMap> createState() => _CustomMap();
}

class _CustomMap extends State<CustomMap> {
  final radius = getIt.get<SearchingService>().getRadius();
  final currentLocation = getIt.get<LocationService>().getLocation();
  final serviceLocations = getIt.get<SearchingService>().getServiceLocations();

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        initialCenter: currentLocation,
        initialZoom: 17.0,
      ),
      children: [
        TileLayer(
          urlTemplate: tileMapProvider,
          userAgentPackageName: 'com.example.app',
        ),
        MarkerLayer(
          markers: [
            Marker(
                point: currentLocation,
                child: const Icon(
                  Icons.pin_drop,
                  color: Colors.red,
                )),
            ..._markerBuilder(),
          ],
        ),
        CircleLayer(
          circles: [
            CircleMarker(
              point: currentLocation,
              radius: radius,
              color: Colors.blue.withOpacity(0.5),
              useRadiusInMeter: true,
            )
          ],
        )
      ],
    );
  }

  List<Marker> _markerBuilder() {
    List<Marker> markers = [];

    for (var service in serviceLocations) {
      markers.add(
        Marker(
          point: LatLng(service.latitude, service.longitude),
          child: const Icon(
            Icons.pin_drop,
            color: Colors.teal,
          ),
        ),
      );
    }

    return markers;
  }
}
