import 'package:flutter/cupertino.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:nearby_assist/config/constants.dart';
import 'package:nearby_assist/pages/account/profile/profile_settings/change_address/location_editing_controller.dart';

class LocationPicker extends StatefulWidget {
  const LocationPicker({
    super.key,
    required this.mapController,
    required this.locationController,
  });

  final MapController mapController;
  final LocationEditingController locationController;

  @override
  State<LocationPicker> createState() => _LocationPickerState();
}

class _LocationPickerState extends State<LocationPicker> {
  @override
  Widget build(BuildContext context) {
    return FlutterMap(
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
      rotate: true,
      alignment: Alignment.center,
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
