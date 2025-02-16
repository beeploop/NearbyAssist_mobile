import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:nearby_assist/config/constants.dart';
import 'package:nearby_assist/providers/route_provider.dart';
import 'package:nearby_assist/providers/user_provider.dart';
import 'package:provider/provider.dart';

class RoutePage extends StatefulWidget {
  const RoutePage({super.key, required this.serviceId});

  final String serviceId;

  @override
  State<RoutePage> createState() => _RoutePageState();
}

class _RoutePageState extends State<RoutePage> with TickerProviderStateMixin {
  late final _controller = AnimatedMapController(vsync: this);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: context.read<UserProvider>().user.isVerified == false
          ? Center(
              child: AlertDialog(
                icon: const Icon(CupertinoIcons.exclamationmark_triangle),
                title: const Text('Account not verified'),
                content: const Text('Verify your account to unlock feature'),
                actions: [
                  TextButton(
                    onPressed: () => context.pop(),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () => context.pushNamed('verifyAccount'),
                    child: const Text('Verify'),
                  ),
                ],
              ),
            )
          : FutureBuilder(
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

    final userPos = LatLng(route[0][0].toDouble(), route[0][1].toDouble());

    return FlutterMap(
      mapController: _controller.mapController,
      options: MapOptions(
        initialZoom: 15,
        initialCenter: userPos,
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
            Marker(
              rotate: true,
              alignment: Alignment.topCenter,
              point: userPos,
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
  }

  TileProvider _tileProvider() {
    return CancellableNetworkTileProvider();
  }

  void _fitMarkers(List<LatLng> coordinates) {
    _controller.animatedFitCamera(
      cameraFit: CameraFit.coordinates(
        coordinates: coordinates,
        padding: const EdgeInsets.all(50),
      ),
    );
  }
}
