import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:nearby_assist/config/constants.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/services/location_service.dart';
import 'package:nearby_assist/services/map_location_picker_service.dart';

class LocationPicker extends StatefulWidget {
  const LocationPicker({super.key});

  @override
  State<LocationPicker> createState() => _LocationPicker();
}

class _LocationPicker extends State<LocationPicker> {
  final MapController _mapController = MapController();
  LatLng _selectedLocation = getIt.get<MapLocationService>().getLocation() ??
      getIt.get<LocationService>().getLocation();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pick Location',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Stack(
        children: [
          _osmWidget(),
          Column(
            children: [
              _buildLatlongIndicator(),
              Expanded(
                child: Container(),
              ),
              FilledButton(
                onPressed: () {
                  double latitude = _selectedLocation.latitude;
                  double longitude = _selectedLocation.longitude;
                  getIt
                      .get<MapLocationService>()
                      .setLocation(LatLng(latitude, longitude));

                  context.pop();
                },
                child: const Text('Pick Location'),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ],
      ),
    );
  }

  Widget _osmWidget() {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
          initialCenter: _selectedLocation,
          initialZoom: 17,
          onTap: (tapLoc, position) {
            setState(() {
              _selectedLocation = position;
            });
          },
          onMapEvent: (MapEvent event) {
            if (event is MapEventMove ||
                event is MapEventScrollWheelZoom ||
                event is MapEventDoubleTapZoom) {
              setState(() {
                _selectedLocation = _mapController.camera.center;
              });
            }
          }),
      children: [
        TileLayer(
          urlTemplate: tileMapProvider,
        ),
        MarkerLayer(markers: [
          Marker(
            alignment: Alignment.topCenter,
            point: _selectedLocation,
            child: const Icon(
              size: 40,
              Icons.location_pin,
              color: Color.fromARGB(255, 255, 7, 7),
            ),
          ),
        ])
      ],
    );
  }

  Widget _buildLatlongIndicator() {
    return Container(
      color: Colors.white60,
      alignment: Alignment.topLeft,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Latitude: \t${_selectedLocation.latitude}",
            style: const TextStyle(fontSize: 14),
          ),
          Text(
            "Longitude: \t${_selectedLocation.longitude}",
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }
}
