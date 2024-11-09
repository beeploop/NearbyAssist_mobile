import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:nearby_assist/config/constants.dart';
import 'package:nearby_assist/pages/account/services/utils/location_editing_controller.dart';
import 'package:nearby_assist/pages/account/services/widget/location_picker.dart';
import 'package:nearby_assist/pages/account/widget/input_field.dart';
import 'package:nearby_assist/pages/search/widget/dropdown_search_bar_controller.dart';
import 'package:nearby_assist/services/location_service.dart';

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

  void _save() {
    throw UnimplementedError();
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
