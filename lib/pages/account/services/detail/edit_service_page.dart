import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nearby_assist/models/service_model.dart';
import 'package:nearby_assist/models/tag_model.dart';
import 'package:nearby_assist/models/update_service_model.dart';
import 'package:nearby_assist/providers/managed_service_provider.dart';
import 'package:nearby_assist/providers/user_provider.dart';
import 'package:nearby_assist/services/location_service.dart';
import 'package:nearby_assist/services/manage_services_service.dart';
import 'package:provider/provider.dart';

class EditServicePage extends StatefulWidget {
  const EditServicePage({super.key, required this.service});

  final ServiceModel service;

  @override
  State<EditServicePage> createState() => _EditServicePageState();
}

class _EditServicePageState extends State<EditServicePage> {
  bool _isLoading = false;
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _rateController = TextEditingController();
  final List<TagModel> _selectedTags = [];
  final List<TagModel> _availableTags = [];

  @override
  void initState() {
    _titleController.text = widget.service.title;
    _descriptionController.text = widget.service.description;
    _rateController.text = widget.service.rate.toString();
    _selectedTags.addAll(widget.service.tags);

    final expertises =
        Provider.of<UserProvider>(context, listen: false).user.expertise;

    for (final expertise in expertises) {
      _availableTags.addAll(expertise.tags);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: const Text(
              'Edit',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          body: _body(),
        ),

        // Show loading overlay
        if (_isLoading)
          const Opacity(
            opacity: 0.8,
            child: ModalBarrier(dismissible: false, color: Colors.black),
          ),
        if (_isLoading)
          const Center(
            child: CircularProgressIndicator(),
          ),
      ],
    );
  }

  Widget _body() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            const Text('Title'),
            const SizedBox(height: 10),
            TextFormField(
              controller: _titleController,
              onTapOutside: (_) =>
                  FocusManager.instance.primaryFocus?.unfocus(),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            // Description
            const Text('Description'),
            const SizedBox(height: 10),
            TextFormField(
              controller: _descriptionController,
              onTapOutside: (_) =>
                  FocusManager.instance.primaryFocus?.unfocus(),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
              maxLines: 6,
              minLines: 3,
            ),
            const SizedBox(height: 20),

            // Rate
            const Text('Rate'),
            const SizedBox(height: 10),
            TextFormField(
              controller: _rateController,
              onTapOutside: (_) =>
                  FocusManager.instance.primaryFocus?.unfocus(),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            // Tags
            const Text('Select tags'),
            const SizedBox(height: 10),
            _tagDropdown(),
            const SizedBox(height: 20),

            // Save button
            FilledButton(
              style: const ButtonStyle(
                minimumSize: WidgetStatePropertyAll(Size.fromHeight(50)),
              ),
              onPressed: _handleSave,
              child: const Text('Save'),
            ),

            // Bottom padding
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _tagDropdown() {
    return DropdownSearch<TagModel>.multiSelection(
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
      onChanged: (items) {
        _selectedTags.clear();
        _selectedTags.addAll(items);
      },
    );
  }

  void _toggleLoader(bool state) {
    setState(() {
      _isLoading = state;
    });
  }

  Future<void> _handleSave() async {
    try {
      _toggleLoader(true);

      final navigator = Navigator.of(context);
      final provider = context.read<ManagedServiceProvider>();

      final location = await LocationService().getLocation();

      final updatedData = UpdateServiceModel(
        id: widget.service.id,
        vendorId: widget.service.vendorId,
        title: _titleController.text,
        description: _descriptionController.text,
        rate: double.parse(_rateController.text),
        tags: _selectedTags,
        latitude: location.latitude,
        longitude: location.longitude,
      );

      await ManageServicesService().update(updatedData);

      // Update the locally saved record
      provider.update(ServiceModel(
        id: updatedData.id,
        vendorId: updatedData.vendorId,
        title: updatedData.title,
        description: updatedData.description,
        rate: updatedData.rate,
        tags: updatedData.tags,
        extras: widget.service.extras,
        latitude: updatedData.latitude,
        longitude: updatedData.longitude,
      ));

      // Navigate back
      navigator.pop();
    } on LocationServiceDisabledException catch (_) {
      _showLocationServiceDisabledDialog();
    } catch (error) {
      _onError(error.toString());
    } finally {
      _toggleLoader(false);
    }
  }

  void _showLocationServiceDisabledDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Location Services Disabled'),
          content: const Text(
            'Please enable location services to use this feature.',
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                await Geolocator.openLocationSettings();
              },
              child: const Text('Open Settings'),
            ),
          ],
        );
      },
    );
  }

  void _onError(String error) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          icon: const Icon(
            CupertinoIcons.xmark_circle_fill,
            color: Colors.red,
            size: 40,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: const Text('Failed'),
          content: Text(
            error,
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
