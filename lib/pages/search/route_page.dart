import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:latlong2/latlong.dart';
import 'package:nearby_assist/config/constants.dart';
import 'package:nearby_assist/providers/route_provider.dart';
import 'package:provider/provider.dart';

class RoutePage extends StatefulWidget {
  const RoutePage({
    super.key,
    required this.serviceId,
    required this.vendorName,
  });

  final String serviceId;
  final String vendorName;

  @override
  State<RoutePage> createState() => _RoutePageState();
}

class _RoutePageState extends State<RoutePage> with TickerProviderStateMixin {
  final _initialZoom = 14.0;
  final _maxZoom = 18.0;
  late final _controller = AnimatedMapController(vsync: this);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder(
        future: context.read<RouteProvider>().getRoute(widget.serviceId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return const Center(
              child: AlertDialog(
                icon: Icon(CupertinoIcons.exclamationmark_triangle),
                title: Text('Something went wrong'),
                content: Text(
                  'An error occurred while finding a route to the service. Please try again later',
                ),
              ),
            );
          }

          final route = snapshot.data!;
          return _mapView(route);
        },
      ),
    );
  }

  Widget _mapView(List<List<num>> route) {
    final coordinates = route
        .map((coord) => LatLng(coord[0].toDouble(), coord[1].toDouble()))
        .toList();

    return FlutterMap(
      mapController: _controller.mapController,
      options: MapOptions(
        initialZoom: _initialZoom,
        maxZoom: _maxZoom,
        initialCenter: coordinates.first,
        onMapReady: () => _fitMarkers(coordinates),
      ),
      children: [
        TileLayer(
          urlTemplate: tileMapProvider,
          userAgentPackageName: 'com.example.app',
          tileProvider: _tileProvider(),
        ),
        PolylineLayer(
          polylines: [
            Polyline(
              points: coordinates,
              color: Colors.orange,
              strokeWidth: 6.0,
            ),
          ],
        ),
        MarkerLayer(
          markers: [
            // user
            Marker(
              height: 60,
              width: 90,
              rotate: true,
              alignment: Alignment.topCenter,
              point: coordinates.first,
              child: Column(
                children: [
                  Container(
                    color: Colors.red,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 2,
                    ),
                    child: const Text(
                      "I'm here",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const Icon(Icons.person_pin, size: 30.0, color: Colors.red),
                ],
              ),
            ),

            // vendor
            Marker(
              height: 60,
              width: 120,
              rotate: true,
              alignment: Alignment.topCenter,
              point: coordinates.last,
              child: Column(
                children: [
                  Container(
                    color: Colors.red,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 2,
                    ),
                    child: Text(
                      widget.vendorName,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const Icon(Icons.person_pin, size: 30.0, color: Colors.red),
                ],
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

  void _fitMarkers(List<LatLng> coordinates) {
    final bounds = LatLngBounds.fromPoints(coordinates);

    if (bounds.northEast == bounds.southWest) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _controller.animateTo(dest: coordinates.first, zoom: 16);
      });
      return;
    }
    _controller.animatedFitCamera(
      cameraFit: CameraFit.bounds(
        bounds: bounds,
        padding: const EdgeInsets.fromLTRB(80, 180, 80, 80),
      ),
    );
  }
}
