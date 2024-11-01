import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:nearby_assist/config/constants.dart';
import 'package:nearby_assist/pages/account/services/utils/location_editing_controller.dart';

class LocationPicker extends StatefulWidget {
  const LocationPicker({
    super.key,
    required this.onLocationPicked,
    required this.mapController,
    required this.locationController,
  });

  final void Function() onLocationPicked;
  final MapController mapController;
  final LocationEditingController locationController;

  @override
  State<LocationPicker> createState() => _LocationPickerState();
}

class _LocationPickerState extends State<LocationPicker> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          FlutterMap(
            mapController: widget.mapController,
            options: MapOptions(
              initialCenter: widget.locationController.location,
              initialZoom: 16.0,
              onMapEvent: _mapEvent,
            ),
            children: [
              TileLayer(
                urlTemplate: tileMapProvider,
                userAgentPackageName: 'com.example.app',
                tileProvider: _tileProvider(),
              ),
              MarkerLayer(
                markers: [_locationMarker()],
              )
            ],
          ),
          Positioned(
            bottom: 10,
            left: 10,
            right: 10,
            child: FilledButton(
              onPressed: widget.onLocationPicked,
              child: const Text("Pick Location"),
            ),
          ),
        ],
      ),
    );
  }

  void _mapEvent(MapEvent event) {
    if (event is MapEventMove ||
        event is MapEventScrollWheelZoom ||
        event is MapEventDoubleTapZoom) {
      setState(() {
        widget.locationController.setLocation(
          widget.mapController.camera.center,
        );
      });
    }
  }

  Marker _locationMarker() {
    return Marker(
      alignment: Alignment.topCenter,
      point: widget.locationController.location,
      child: const Icon(
        size: 40,
        CupertinoIcons.placemark_fill,
        color: Color.fromARGB(255, 255, 7, 7),
      ),
    );
  }

  TileProvider _tileProvider() {
    return CancellableNetworkTileProvider();
  }
}
