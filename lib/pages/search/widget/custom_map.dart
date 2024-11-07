import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:nearby_assist/config/constants.dart';
import 'package:nearby_assist/models/service_model.dart';
import 'package:nearby_assist/providers/location_provider.dart';
import 'package:nearby_assist/providers/services_provider.dart';
import 'package:nearby_assist/utils/custom_snackbar.dart';
import 'package:provider/provider.dart';

class CustomMap extends StatefulWidget {
  const CustomMap({super.key});

  @override
  State<CustomMap> createState() => _CustomMapState();
}

class _CustomMapState extends State<CustomMap> with TickerProviderStateMixin {
  late final _controller = AnimatedMapController(vsync: this);
  LatLng _location = defaultLocation;

  Future<void> _getLocation() async {
    final position = await context.read<LocationProvider>().getLocation();
    setState(() {
      _location = LatLng(position.latitude, position.longitude);
      _centerMap();
    });
  }

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  @override
  Widget build(BuildContext context) {
    final services = context.watch<ServicesProvider>().services;
    _fitMarkers(services);

    return Stack(
      children: [
        FlutterMap(
          mapController: _controller.mapController,
          options: MapOptions(
            initialCenter: LatLng(_location.latitude, _location.longitude),
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
                  point: LatLng(_location.latitude, _location.longitude),
                  icon: CupertinoIcons.person_circle_fill,
                  color: Colors.red,
                  onTap: _centerMap,
                ),

                // Display markers for the services
                ...services.map((service) {
                  return _createMarker(
                    point: LatLng(service.latitude, service.longitude),
                    icon: CupertinoIcons.location_solid,
                    color: Colors.red,
                    onTap: () => context.pushNamed(
                      'viewService',
                      queryParameters: {'serviceId': service.id},
                    ),
                  );
                }),
              ],
            ),
          ],
        ),
        Positioned(
          bottom: 20,
          right: 20,
          child: FloatingActionButton(
            onPressed: _centerMap,
            backgroundColor: Colors.green,
            child: const Icon(
              CupertinoIcons.map_pin_ellipse,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  TileProvider _tileProvider() {
    return CancellableNetworkTileProvider();
  }

  Marker _createMarker({
    required LatLng point,
    required IconData icon,
    required Color color,
    required void Function() onTap,
  }) {
    return Marker(
      rotate: true,
      alignment: Alignment.topCenter,
      point: point,
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
      "There might be some delay in displaying the map depending on your connection",
      duration: const Duration(seconds: 6),
      backgroundColor: Colors.green[400],
    );
  }

  void _centerMap() {
    _controller.animateTo(
      dest: LatLng(_location.latitude, _location.longitude),
      zoom: 16,
    );
  }

  void _fitMarkers(List<ServiceModel> services) {
    final userPosition = LatLng(_location.latitude, _location.longitude);

    final coordinates = services.map((service) {
      return LatLng(service.latitude, service.longitude);
    }).toList();
    coordinates.add(userPosition);
    final bounds = LatLngBounds.fromPoints(coordinates);

    if (bounds.northEast == bounds.southWest) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _controller.animateTo(dest: userPosition, zoom: 16.0);
      });
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.animatedFitCamera(
        cameraFit: CameraFit.bounds(
          bounds: bounds,
          padding: const EdgeInsets.fromLTRB(40, 120, 40, 40),
        ),
      );
    });
  }
}
