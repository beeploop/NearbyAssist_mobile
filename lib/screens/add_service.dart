import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/model/auth_model.dart';
import 'package:nearby_assist/model/my_service.dart';
import 'package:nearby_assist/services/map_location_picker_service.dart';
import 'package:nearby_assist/services/search_service.dart';
import 'package:nearby_assist/services/vendor_service.dart';
import 'package:nearby_assist/widgets/input_box.dart';
import 'package:nearby_assist/widgets/listenable_loading_button.dart';

class AddService extends StatefulWidget {
  const AddService({super.key});

  @override
  State<AddService> createState() => _AddService();
}

class _AddService extends State<AddService> {
  final TextEditingController _latlongController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final List<String> _selectedTags = [];

  @override
  void dispose() {
    super.dispose();
    getIt.get<MapLocationService>().clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Service',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListenableBuilder(
        listenable: getIt.get<MapLocationService>(),
        builder: (context, _) {
          final tags = getIt.get<SearchingService>().getTags();
          _latlongController.text =
              getIt.get<MapLocationService>().getLatlongString();

          return Center(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Form(
                  child: DropdownSearch<String>.multiSelection(
                    dropdownDecoratorProps: const DropDownDecoratorProps(
                      dropdownSearchDecoration: InputDecoration(
                        hintText: 'Tags',
                      ),
                    ),
                    items: [...tags],
                    onChanged: (tags) {
                      setState(() {
                        _selectedTags.clear();
                        _selectedTags.addAll(tags);
                      });
                    },
                    selectedItems: _selectedTags,
                  ),
                ),
                const SizedBox(height: 20),
                InputBox(
                  controller: _descriptionController,
                  hintText: 'Describe your service',
                  lines: 6,
                ),
                const SizedBox(height: 20),
                InputBox(
                  controller: _priceController,
                  hintText: '\$ Price',
                ),
                const SizedBox(height: 20),
                InputBox(
                  controller: _latlongController,
                  hintText: 'Latlong',
                ),
                const SizedBox(height: 20),
                FilledButton(
                  onPressed: () {
                    context.goNamed('location-picker');
                  },
                  child: const Text('Pick Location'),
                ),
                const SizedBox(height: 20),
                ListenableLoadingButton(
                  listenable: getIt.get<VendorService>(),
                  isLoadingFunction: () =>
                      getIt.get<VendorService>().isLoading(),
                  onPressed: () async {
                    try {
                      if (_descriptionController.text.isEmpty ||
                          _priceController.text.isEmpty ||
                          _latlongController.text.isEmpty ||
                          _selectedTags.isEmpty) {
                        throw Exception('Please fill all fields');
                      }

                      final userId = getIt.get<AuthModel>().getUserId();
                      final location =
                          getIt.get<MapLocationService>().getLocation();
                      if (location == null) {
                        throw Exception('Please pick a location');
                      }

                      final service = MyService(
                        id: '',
                        vendorId: userId,
                        description: _descriptionController.text,
                        rate: _priceController.text,
                        latitude: location.latitude.toString(),
                        longitude: location.longitude.toString(),
                        tags: _selectedTags,
                      );
                      await getIt.get<VendorService>().addService(service);

                      if (context.mounted) {
                        context.pop();
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(e.toString())),
                        );
                      }
                    }
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
