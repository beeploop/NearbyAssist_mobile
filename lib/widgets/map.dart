import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class CustomMap extends StatefulWidget {
  const CustomMap({super.key});

  @override
  State<CustomMap> createState() => _CustomMap();
}

class _CustomMap extends State<CustomMap> {
  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: const MapOptions(
        initialCenter: LatLng(7.422365, 125.825984),
        initialZoom: 18.0,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.app',
        ),
        const MarkerLayer(
          markers: [
            Marker(
                point: LatLng(7.422365, 125.825984),
                child: Icon(
                  Icons.pin_drop,
                  color: Colors.red,
                )),
          ],
        ),
        CircleLayer(
          circles: [
            CircleMarker(
              point: const LatLng(7.422365, 125.825984),
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
