import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:nearby_assist/config/constants.dart';
import 'package:nearby_assist/pages/account/services/utils/location_editing_controller.dart';
import 'package:nearby_assist/pages/account/services/widget/location_picker.dart';
import 'package:nearby_assist/providers/location_provider.dart';
import 'package:provider/provider.dart';

class AddServicePage extends StatefulWidget {
  const AddServicePage({super.key});

  @override
  State<AddServicePage> createState() => _AddServicePageState();
}

class _AddServicePageState extends State<AddServicePage> {
  final _mapController = MapController();
  final _locationController = LocationEditingController(
    initialLocation: defaultLocation,
  );

  Future<void> _getLocation() async {
    final position = await context.read<LocationProvider>().getLocation();
    setState(() {
      _locationController.setLocation(
        LatLng(position.latitude, position.longitude),
      );
    });
  }

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text("add service"),
            Text('Location: ${_locationController.location}'),
            FilledButton(
              onPressed: _showLocationPicker,
              child: const Text("Set Location"),
            ),
          ],
        ),
      ),
    );
  }

  void _showLocationPicker() {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      builder: (context) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.85,
        child: LocationPicker(
          mapController: _mapController,
          locationController: _locationController,
          onLocationPicked: _handleLocationPicked,
        ),
      ),
    );
  }

  void _handleLocationPicked() {
    setState(() {
      _locationController.setLocation(
        _mapController.camera.center,
      );
    });
    context.pop();
  }
}
