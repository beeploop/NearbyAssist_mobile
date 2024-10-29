import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/model/auth_model.dart';
import 'package:nearby_assist/model/my_service.dart';
import 'package:nearby_assist/model/service_detail_model.dart';
import 'package:nearby_assist/model/tag_model.dart';
import 'package:nearby_assist/services/map_location_picker_service.dart';
import 'package:nearby_assist/services/storage_service.dart';
import 'package:nearby_assist/services/vendor_service.dart';
import 'package:nearby_assist/widgets/input_box.dart';

class EditService extends StatefulWidget {
  const EditService({super.key, required this.serviceId});

  final String serviceId;

  @override
  State<EditService> createState() => _EditService();
}

class _EditService extends State<EditService> {
  final TextEditingController _latlongController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  List<String> _currentTags = [];

  void _setFormValues(ServiceDetailModel service) {
    if (_descriptionController.text.isEmpty) {
      _descriptionController.text = service.serviceInfo.description;
    }

    if (_priceController.text.isEmpty) {
      _priceController.text = service.serviceInfo.rate.toString();
    }

    _currentTags = service.serviceInfo.tags;

    if (getIt.get<MapLocationService>().getLocation() == null) {
      getIt.get<MapLocationService>().setLocation(LatLng(
            service.serviceInfo.latitude,
            service.serviceInfo.longitude,
          ));
      _latlongController.text =
          getIt.get<MapLocationService>().getLatlongString() ?? "";
    } else {
      _latlongController.text =
          getIt.get<MapLocationService>().getLatlongString() ??
              "This should be set";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: FutureBuilder(
          future: Future.wait([
            getIt.get<StorageService>().getTags(),
            getIt
                .get<VendorService>()
                .getServiceInfo(widget.serviceId, toogleLoading: false),
          ]),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.hasError) {
              final err = snapshot.error.toString();
              return Center(child: Text(err));
            }

            if (!snapshot.hasData) {
              return const Center(
                child: Text('Unexpected behavior, no error but has no data'),
              );
            }

            final availableTags = snapshot.data![0] as List<TagModel>;
            final service = snapshot.data![1] as ServiceDetailModel;
            _setFormValues(service);

            return _buildForm(availableTags);
          }),
    );
  }

  Widget _buildForm(List<TagModel> availableTags) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _buildTagDropdown(availableTags),
        const SizedBox(height: 20),
        InputBox(
          controller: _descriptionController,
          hintText: 'Describe your service',
          lines: 6,
        ),
        const SizedBox(height: 20),
        InputBox(controller: _priceController, hintText: '\$ Price'),
        const SizedBox(height: 20),
        InputBox(controller: _latlongController, hintText: 'Latlong'),
        const SizedBox(height: 20),
        FilledButton(
          onPressed: () => context.pushNamed('editLocation'),
          child: const Text('Update Location'),
        ),
        const SizedBox(height: 20),
        FilledButton(
          onPressed: () => _handleUpdate(context),
          child: const Text('Save'),
        ),
      ],
    );
  }

  Widget _buildTagDropdown(List<TagModel> availableTags) {
    return Form(
      child: DropdownSearch<String>.multiSelection(
        dropdownDecoratorProps: const DropDownDecoratorProps(
          dropdownSearchDecoration: InputDecoration(
            hintText: 'Tags',
          ),
        ),
        items: availableTags.map((e) => e.title).toList(),
        selectedItems: _currentTags,
        onChanged: (tags) {
          _currentTags = tags;
        },
      ),
    );
  }

  Future<void> _handleUpdate(BuildContext context) async {
    try {
      if (_descriptionController.text.isEmpty ||
          _priceController.text.isEmpty ||
          _latlongController.text.isEmpty ||
          _currentTags.isEmpty) {
        throw Exception('Please fill all fields');
      }

      final userId = getIt.get<AuthModel>().getUserId();
      final service = MyService(
        id: widget.serviceId,
        vendorId: userId,
        description: _descriptionController.text,
        rate: _priceController.text,
        latitude: _latlongController.text.split(',').first,
        longitude: _latlongController.text.split(',').last,
        tags: _currentTags,
      );

      await getIt.get<VendorService>().updateService(service);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Service updated")),
        );

        context.pop();
      }
    } catch (err) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(err.toString())),
        );
      }
    }
  }

  @override
  void dispose() {
    _latlongController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    getIt.get<MapLocationService>().clear();
    super.dispose();
  }
}
