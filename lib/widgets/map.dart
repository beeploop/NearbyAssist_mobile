import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/services/location_service.dart';

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
        initialZoom: 18.0,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
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
          ],
        ),
        CircleLayer(
          circles: [
            CircleMarker(
              point: currentLocation,
              radius: 200,
              color: Colors.blue.withOpacity(0.5),
              useRadiusInMeter: true,
            )
          ],
        )
      ],
    );
  }
}
