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
  final _mapController = MapController();

  void _zoomToFit(List<Service> services) {
    final coordinates = services.map((service) {
      return LatLng(service.latitude, service.longitude);
    }).toList();
    coordinates.add(currentLocation);
    final bounds = LatLngBounds.fromPoints(coordinates);

    if (bounds.northEast == bounds.southWest) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _mapController.move(currentLocation, 16.0);
      });
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _mapController.fitCamera(CameraFit.bounds(
        bounds: bounds,
        padding: const EdgeInsets.fromLTRB(80, 150, 80, 80),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
        listenable: getIt.get<SearchingService>(),
        builder: (context, child) {
          final updated = getIt.get<SearchingService>().getServiceLocations();
          _zoomToFit(updated);

          return FlutterMap(
            mapController: _mapController,
            options: MapOptions(
                initialCenter: currentLocation,
                initialZoom: 16.0,
                onMapReady: () {
                  _zoomToFit(updated);
                }),
            children: [
              TileLayer(
                urlTemplate: tileMapProvider,
                userAgentPackageName: 'com.example.app',
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    rotate: true,
                    alignment: Alignment.topCenter,
                    point: currentLocation,
                    child: const Icon(Icons.account_circle,
                        size: 40, color: Color.fromARGB(90, 255, 0, 0)),
                  ),
                  ..._markerBuilder(updated),
                ],
              ),
            ],
          );
        });
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
                queryParameters: {'serviceId': service.id},
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
