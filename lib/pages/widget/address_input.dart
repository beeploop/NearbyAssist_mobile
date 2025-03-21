import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:nearby_assist/config/constants.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/pages/account/services/utils/location_editing_controller.dart';
import 'package:nearby_assist/pages/account/services/widget/location_picker.dart';
import 'package:nearby_assist/pages/booking/widget/input_field.dart';
import 'package:nearby_assist/providers/user_provider.dart';
import 'package:nearby_assist/services/geocoding_service.dart';
import 'package:provider/provider.dart';

class AddressInput extends StatefulWidget {
  const AddressInput({
    super.key,
    required this.controller,
    this.initialLocation,
    this.readOnly = false,
  });

  final TextEditingController controller;
  final LatLng? initialLocation;
  final bool readOnly;

  @override
  State<AddressInput> createState() => _AddressInputState();
}

class _AddressInputState extends State<AddressInput> {
  //final _addressController = TextEditingController();
  final _mapController = MapController();
  late LocationEditingController _locationController;

  @override
  void initState() {
    super.initState();

    _locationController = LocationEditingController(
      initialLocation: widget.initialLocation ?? defaultLocation,
    );

    final user = Provider.of<UserProvider>(context, listen: false).user;
    if (user.latitude != null && user.longitude != null) {
      final location = LatLng(user.latitude!, user.longitude!);
      _locationController.setLocation(location);
    }

    if (user.address != null) {
      widget.controller.text = user.address!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: InputField(
            controller: widget.controller,
            hintText: 'your address',
            labelText: 'Address',
            minLines: 1,
            maxLines: 6,
            readOnly: widget.readOnly,
          ),
        ),
        if (!widget.readOnly)
          IconButton(
            onPressed: _showAddressPicker,
            icon: const Icon(CupertinoIcons.compass),
          ),
      ],
    );
  }

  void _showAddressPicker() {
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
          onLocationPicked: _onLocationPicked,
        ),
      ),
    );
  }

  Future<void> _onLocationPicked() async {
    try {
      final geocoding = GeocodingService();
      final response = await geocoding.lookupAddress(
        _locationController.location.latitude,
        _locationController.location.longitude,
      );

      widget.controller.text = response.displayName;

      if (!mounted) return;
      context.pop();
    } catch (error) {
      logger.log('Error getting address: $error');
    }
  }
}
