import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:nearby_assist/config/constants.dart';
import 'package:nearby_assist/models/service_model.dart';
import 'package:nearby_assist/models/tag_model.dart';
import 'package:nearby_assist/pages/account/services/utils/location_editing_controller.dart';
import 'package:nearby_assist/pages/account/services/widget/location_picker.dart';
import 'package:nearby_assist/pages/account/widget/input_field.dart';
import 'package:nearby_assist/providers/managed_service_provider.dart';
import 'package:nearby_assist/providers/user_provider.dart';
import 'package:nearby_assist/services/location_service.dart';
import 'package:nearby_assist/services/manage_services_service.dart';
import 'package:nearby_assist/utils/custom_snackbar.dart';
import 'package:provider/provider.dart';

class AddServicePage extends StatefulWidget {
  const AddServicePage({super.key});

  @override
  State<AddServicePage> createState() => _AddServicePageState();
}

class _AddServicePageState extends State<AddServicePage> {
  final List<TagModel> _availableTags = [];
  List<TagModel> _selectedTags = [];
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _mapController = MapController();
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

  void initializeTags() {
    final expertises =
        Provider.of<UserProvider>(context, listen: false).user.expertise;

    for (final expertise in expertises) {
      _availableTags.addAll(expertise.tags);
    }
  }

  @override
  void initState() {
    super.initState();
    initializeTags();
    _getLocation();
  }

  @override
  Widget build(BuildContext context) {
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
              DropdownSearch<TagModel>.multiSelection(
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
                items: (filter, props) => _availableTags,
                itemAsString: (tag) => tag.title,
                compareFn: (tag, selected) => tag.id == selected.id,
                selectedItems: _selectedTags,
                onChanged: (items) => _selectedTags = items,
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
                onPressed: _save,
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

  void _handleLocationPicked() {
    setState(() {
      _locationController.setLocation(
        _mapController.camera.center,
      );
    });
    context.pop();
  }

  void _save() async {
    try {
      final provider = context.read<ManagedServiceProvider>();

      final data = ServiceModel(
        vendorId: context.read<UserProvider>().user.id,
        title: _titleController.text,
        description: _descriptionController.text,
        rate: double.parse(_priceController.text),
        latitude: _locationController.location.latitude,
        longitude: _locationController.location.longitude,
        tags: _selectedTags.map((e) => e.title).toList(),
      );

      final service = ManageServicesService();
      final response = await service.add(data);

      provider.add(response);

      _onSuccess();
    } catch (error) {
      _showErrorModal(error.toString());
    }
  }

  void _onSuccess() {
    showCustomSnackBar(
      context,
      'Service added successfully',
      duration: const Duration(seconds: 5),
      backgroundColor: Colors.green,
      textColor: Colors.white,
      closeIconColor: Colors.white,
    );

    context.pop();
  }

  void _showErrorModal(String error) {
    showCustomSnackBar(
      context,
      error,
      duration: const Duration(seconds: 5),
      backgroundColor: Colors.red,
      textColor: Colors.white,
      closeIconColor: Colors.white,
    );
  }
}
