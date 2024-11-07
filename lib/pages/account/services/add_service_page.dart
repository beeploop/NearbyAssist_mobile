import 'dart:math';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:nearby_assist/config/constants.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/models/service_model.dart';
import 'package:nearby_assist/models/user_model.dart';
import 'package:nearby_assist/pages/account/services/utils/location_editing_controller.dart';
import 'package:nearby_assist/pages/account/services/widget/location_picker.dart';
import 'package:nearby_assist/pages/account/widget/input_field.dart';
import 'package:nearby_assist/pages/search/widget/dropdown_search_bar_controller.dart';
import 'package:nearby_assist/providers/auth_provider.dart';
import 'package:nearby_assist/providers/location_provider.dart';
import 'package:nearby_assist/providers/managed_services_provider.dart';
import 'package:provider/provider.dart';

class AddServicePage extends StatefulWidget {
  const AddServicePage({super.key});

  @override
  State<AddServicePage> createState() => _AddServicePageState();
}

class _AddServicePageState extends State<AddServicePage> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _tagsController = DropdownSearchBarController();
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
    final user = context.watch<AuthProvider>().user;
    final manageProvider = context.read<ManagedServicesProvider>();

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              InputField(
                controller: _titleController,
                hintText: 'Title',
                labelText: 'Title',
              ),
              const SizedBox(height: 10),
              InputField(
                controller: _descriptionController,
                hintText: 'Short description of your service',
                minLines: 4,
                maxLines: 8,
              ),
              const SizedBox(height: 10),
              InputField(
                controller: _priceController,
                hintText: '\$0.00',
                labelText: 'Price',
              ),
              const SizedBox(height: 10),
              DropdownSearch<String>.multiSelection(
                decoratorProps: const DropDownDecoratorProps(
                  decoration: InputDecoration(
                    hintText: 'select tags',
                    border: OutlineInputBorder(),
                  ),
                ),
                popupProps: PopupPropsMultiSelection.modalBottomSheet(
                  containerBuilder: (context, child) {
                    return Padding(
                      padding: const EdgeInsets.all(10),
                      child: child,
                    );
                  },
                  modalBottomSheetProps: const ModalBottomSheetProps(
                    showDragHandle: true,
                  ),
                  showSearchBox: true,
                  showSelectedItems: true,
                  searchFieldProps: const TextFieldProps(
                    decoration: InputDecoration(
                      hintText: 'filter tags',
                    ),
                  ),
                  searchDelay: const Duration(milliseconds: 500),
                ),
                autoValidateMode: AutovalidateMode.always,
                items: (filter, props) => serviceTags,
                selectedItems: _tagsController.selectedTags,
                onChanged: (items) => _tagsController.replaceAll(items),
              ),
              const SizedBox(height: 10),
              Text('Location: ${_locationController.location}'),
              FilledButton(
                style: const ButtonStyle(
                  minimumSize: WidgetStatePropertyAll(Size.fromHeight(50)),
                ),
                onPressed: _showLocationPicker,
                child: const Text("Set Location"),
              ),
              const SizedBox(height: 10),
              FilledButton(
                style: const ButtonStyle(
                  minimumSize: WidgetStatePropertyAll(Size.fromHeight(50)),
                ),
                onPressed: () => _save(user, manageProvider),
                child: const Text('Save'),
              ),
            ],
          ),
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

  void _save(UserModel user, ManagedServicesProvider provider) {
    final title = _titleController.text;
    final description = _descriptionController.text;
    final price = _priceController.text;
    final tags = _tagsController.selectedTags;
    final location = _locationController.location;

    logger.log('Title: $title');
    logger.log('Description: $description');
    logger.log('Price: $price');
    logger.log('Location: $location');
    logger.log('Tags: ${tags.toString()}');

    final service = ServiceModel(
      id: Random().nextInt(1000).toString(),
      vendor: user.id,
      description: description,
      latitude: location.latitude,
      longitude: location.longitude,
    );

    provider.add(service);

    context.pop();
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
