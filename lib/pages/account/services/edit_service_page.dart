import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:nearby_assist/config/constants.dart';
import 'package:nearby_assist/pages/account/services/utils/location_editing_controller.dart';
import 'package:nearby_assist/pages/account/services/widget/location_picker.dart';
import 'package:nearby_assist/providers/service_provider.dart';
import 'package:nearby_assist/services/location_service.dart';
import 'package:nearby_assist/utils/pretty_json.dart';
import 'package:provider/provider.dart';

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

  Future<void> _getLocation() async {
    final position = await LocationService().getLocation();
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
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Edit',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: FutureBuilder(
        future: context.read<ServiceProvider>().getService(widget.serviceId),
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
                  'An error occurred while fetching data of this vendor. Please try again later',
                ),
              ),
            );
          }

          final data = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text(prettyJSON(data)),
                ],
              ),
            ),
          );
        },
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
