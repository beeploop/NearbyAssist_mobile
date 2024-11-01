import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:nearby_assist/config/constants.dart';
import 'package:nearby_assist/utils/custom_snackbar.dart';

class CustomMap extends StatefulWidget {
  const CustomMap({super.key});

  @override
  State<CustomMap> createState() => _CustomMapState();
}

class _CustomMapState extends State<CustomMap> with TickerProviderStateMixin {
  late final _controller = AnimatedMapController(vsync: this);

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: _controller.mapController,
      options: MapOptions(
        initialCenter: defaultLocation,
        initialZoom: 13.0,
        onMapReady: _mapReady,
      ),
      children: [
        TileLayer(
          urlTemplate: tileMapProvider,
          userAgentPackageName: 'com.example.app',
          tileProvider: _tileProvider(),
        ),
        MarkerLayer(
          markers: [
            _createMarker(
              coordinates: defaultLocation,
              icon: CupertinoIcons.person_circle_fill,
              color: Colors.red,
              onTap: _centerMap,
            ),
            _createMarker(
              coordinates: testLocation,
              icon: CupertinoIcons.location_solid,
              color: Colors.red,
              onTap: () => context.pushNamed(
                'vendor',
                queryParameters: {'serviceId': 'foobar'},
              ),
            ),
          ],
        ),
      ],
    );
  }

  TileProvider _tileProvider() {
    return CancellableNetworkTileProvider();
  }

  Marker _createMarker({
    required LatLng coordinates,
    required IconData icon,
    required Color color,
    required void Function() onTap,
  }) {
    return Marker(
      rotate: true,
      alignment: Alignment.topCenter,
      point: coordinates,
      child: GestureDetector(
        onTap: onTap,
        child: Icon(icon, color: color, size: 40),
      ),
    );
  }

  void _mapReady() {
    _centerMap();

    showCustomSnackBar(
      context,
      "Map is ready",
      duration: const Duration(seconds: 2),
      backgroundColor: Colors.green[400],
    );
  }

  void _centerMap() {
    _controller.animateTo(
      dest: defaultLocation,
      zoom: 16,
    );
  }
}
