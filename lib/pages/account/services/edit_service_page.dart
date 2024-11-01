import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_router/go_router.dart';
import 'package:nearby_assist/config/constants.dart';
import 'package:nearby_assist/pages/account/services/utils/location_editing_controller.dart';
import 'package:nearby_assist/pages/account/services/widget/location_picker.dart';

class EditServicePage extends StatefulWidget {
  const EditServicePage({super.key, required this.serviceId});

  final String serviceId;

  @override
  State<EditServicePage> createState() => _EditServicePageState();
}

class _EditServicePageState extends State<EditServicePage> {
  final _controller = MapController();
  final _locationController = LocationEditingController(
    initialLocation: defaultLocation,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Edit',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Text('location: ${_locationController.location}'),
            FilledButton(
              onPressed: _showLocationPicker,
              child: const Text("update location"),
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
      builder: (context) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.85,
        child: LocationPicker(
          mapController: _controller,
          locationController: _locationController,
          onLocationPicked: _pickLocationHandler,
        ),
      ),
    );
  }

  void _pickLocationHandler() {
    setState(() {
      _locationController.setLocation(_controller.camera.center);
    });
    context.pop();
  }
}
