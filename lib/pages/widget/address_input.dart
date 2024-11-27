import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:nearby_assist/config/constants.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/pages/account/services/utils/location_editing_controller.dart';
import 'package:nearby_assist/pages/account/services/widget/location_picker.dart';
import 'package:nearby_assist/pages/account/widget/input_field.dart';
import 'package:nearby_assist/providers/user_provider.dart';
import 'package:nearby_assist/services/geocoding_service.dart';
import 'package:provider/provider.dart';

class AddressInput extends StatefulWidget {
  const AddressInput({super.key, required this.onLocationPicked});

  final void Function(String) onLocationPicked;

  @override
  State<AddressInput> createState() => _AddressInputState();
}

class _AddressInputState extends State<AddressInput> {
  final _addressController = TextEditingController();
  final _mapController = MapController();
  final _locationController = LocationEditingController(
    initialLocation: defaultLocation,
  );

  @override
  void initState() {
    super.initState();

    final user = Provider.of<UserProvider>(context, listen: false).user;
    if (user.latitude != null && user.longitude != null) {
      final location = LatLng(user.latitude!, user.longitude!);
      _locationController.setLocation(location);
    }

    if (user.address != null) {
      _addressController.text = user.address!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: InputField(
            controller: _addressController,
            hintText: 'your address',
            minLines: 1,
            maxLines: 6,
          ),
        ),
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

      setState(() {
        _addressController.text = response.displayName;
      });

      widget.onLocationPicked(response.displayName);

      if (!mounted) return;
      context.pop();
    } catch (error) {
      logger.log('Error getting address: $error');
    }
  }
}
