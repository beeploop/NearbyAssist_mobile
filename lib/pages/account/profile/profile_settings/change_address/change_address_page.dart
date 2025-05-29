import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:nearby_assist/config/constants.dart';
import 'package:nearby_assist/models/user_model.dart';
import 'package:nearby_assist/pages/account/profile/profile_settings/change_address/location_editing_controller.dart';
import 'package:nearby_assist/pages/account/profile/profile_settings/change_address/location_picker.dart';
import 'package:nearby_assist/providers/user_provider.dart';
import 'package:nearby_assist/utils/show_generic_error_modal.dart';
import 'package:nearby_assist/utils/show_location_disabled_modal.dart';
import 'package:provider/provider.dart';

class ChangeAddressPage extends StatefulWidget {
  const ChangeAddressPage({super.key});

  @override
  State<ChangeAddressPage> createState() => _ChangeAddressPageState();
}

class _ChangeAddressPageState extends State<ChangeAddressPage> {
  bool _submittable = false;
  final _addressController = TextEditingController();
  final _mapController = MapController();
  late LocationEditingController _locationController;
  late UserModel user;

  @override
  void initState() {
    super.initState();
    user = Provider.of<UserProvider>(context, listen: false).user;
    _addressController.text = user.address;
    _addressController.addListener(_inputListener);

    if (user.latitude == null || user.longitude == null) {
      _locationController = LocationEditingController(
        initialLocation: defaultLocation,
      );
    } else {
      _locationController = LocationEditingController(
        initialLocation: LatLng(user.latitude!, user.longitude!),
      );
    }
    _locationController.addListener(_inputListener);
  }

  @override
  void dispose() {
    super.dispose();
    _addressController.removeListener(_inputListener);
    _locationController.removeListener(_inputListener);
    _mapController.dispose();
  }

  void _inputListener() {
    if (user.address.trim() != _addressController.text.trim() &&
            _addressController.text.isNotEmpty ||
        user.latitude! != _locationController.location.latitude &&
            user.longitude! != _locationController.location.longitude) {
      setState(() {
        _submittable = true;
      });
    } else {
      setState(() {
        _submittable = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Change Address'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              TextFormField(
                controller: _addressController,
                onTapOutside: (event) => FocusScope.of(context).unfocus(),
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  labelText: 'Address',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.6,
                child: LocationPicker(
                  mapController: _mapController,
                  locationController: _locationController,
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: FilledButton(
            onPressed: _submittable ? _showAddressChangeConfirmation : () {},
            style: ButtonStyle(
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              backgroundColor: WidgetStatePropertyAll(
                !_submittable ? Colors.grey : null,
              ),
              minimumSize: const WidgetStatePropertyAll(
                Size.fromHeight(50),
              ),
            ),
            child: const Text('Change Address'),
          ),
        ),
      ),
    );
  }

  void _showAddressChangeConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(
          CupertinoIcons.question_circle,
          color: Colors.amber,
          size: 40,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        title: Text(
          'Change address',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: _handleChangeAddress,
            style: ButtonStyle(
              backgroundColor: const WidgetStatePropertyAll(Colors.green),
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }

  Future<void> _handleChangeAddress() async {
    final loader = context.loaderOverlay;
    try {
      loader.show();
      final navigator = Navigator.of(context);
      navigator.pop();

      if (_addressController.text.isEmpty) {
        throw "Invalid address provided";
      }

      await context.read<UserProvider>().changeAddress(
          _addressController.text.trim(), _locationController.location);

      navigator.pop();
      navigator.pop();
    } on LocationServiceDisabledException catch (_) {
      if (!mounted) return;
      showLocationDisabledModal(context);
    } on DioException catch (error) {
      if (!mounted) return;
      showGenericErrorModal(context, message: error.response?.data['message']);
    } catch (error) {
      if (!mounted) return;
      showGenericErrorModal(context, message: error.toString());
    } finally {
      loader.hide();
    }
  }
}
