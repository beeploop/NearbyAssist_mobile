import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:geolocator/geolocator.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:nearby_assist/models/pricing_type.dart';
import 'package:nearby_assist/models/service_model.dart';
import 'package:nearby_assist/models/update_service_model.dart';
import 'package:nearby_assist/providers/control_center_provider.dart';
import 'package:nearby_assist/utils/show_generic_error_modal.dart';
import 'package:nearby_assist/utils/show_location_disabled_modal.dart';
import 'package:provider/provider.dart';

class EditServicePage extends StatefulWidget {
  const EditServicePage({super.key, required this.service});

  final ServiceModel service;

  @override
  State<EditServicePage> createState() => _EditServicePageState();
}

class _EditServicePageState extends State<EditServicePage> {
  bool _hasChanged = false;
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _tagsController = TextEditingController();
  late PricingType _pricingType;

  @override
  void initState() {
    _titleController.text = widget.service.title;
    _descriptionController.text = widget.service.description;
    _priceController.text = widget.service.price.toString();
    _pricingType = widget.service.pricingType;
    _tagsController.text = widget.service.tags.join(", ");

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Edit',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: _body(),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: FilledButton(
            onPressed: _hasChanged ? _handleSave : () {},
            style: ButtonStyle(
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              minimumSize: const WidgetStatePropertyAll(
                Size.fromHeight(50),
              ),
              backgroundColor: WidgetStatePropertyAll(
                !_hasChanged ? Colors.grey : null,
              ),
            ),
            child: const Text('Save'),
          ),
        ),
      ),
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
              maxLength: 50,
              controller: _titleController,
              onChanged: (value) {
                if (value != widget.service.title) {
                  setState(() {
                    _hasChanged = true;
                  });
                } else {
                  setState(() {
                    _hasChanged = false;
                  });
                }
              },
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
              onChanged: (value) {
                if (value != widget.service.description) {
                  setState(() {
                    _hasChanged = true;
                  });
                } else {
                  setState(() {
                    _hasChanged = false;
                  });
                }
              },
              onTapOutside: (_) =>
                  FocusManager.instance.primaryFocus?.unfocus(),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
              maxLines: 6,
              minLines: 3,
            ),
            const SizedBox(height: 20),

            // Price
            const Text('Price'),
            const SizedBox(height: 10),
            TextFormField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              onChanged: (value) {
                if (double.parse(value) != widget.service.price) {
                  setState(() {
                    _hasChanged = true;
                  });
                } else {
                  setState(() {
                    _hasChanged = false;
                  });
                }
              },
              onTapOutside: (_) =>
                  FocusManager.instance.primaryFocus?.unfocus(),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),

            // Pricing type
            Row(
              children: [
                const Text('Pricing: '),
                const SizedBox(width: 10),
                DropdownButton<PricingType>(
                  value: _pricingType,
                  items: PricingType.values
                      .map((type) => DropdownMenuItem(
                            value: type,
                            child: Text(type.label),
                          ))
                      .toList(),
                  onChanged: (type) {
                    setState(() {
                      _pricingType = type ?? widget.service.pricingType;
                      _hasChanged = true;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Tags
            const Text('Select tags'),
            const SizedBox(height: 10),
            TextFormField(
              controller: _tagsController,
              onChanged: (value) {
                if (value != widget.service.description) {
                  setState(() {
                    _hasChanged = true;
                  });
                } else {
                  setState(() {
                    _hasChanged = false;
                  });
                }
              },
              onTapOutside: (event) => FocusScope.of(context).unfocus(),
              decoration: const InputDecoration(
                labelText: 'Tags',
                border: OutlineInputBorder(),
                hintText: 'Tags',
                hintStyle: TextStyle(color: Colors.grey),
              ),
            ),

            // Bottom padding
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Future<void> _handleSave() async {
    final loader = context.loaderOverlay;

    try {
      loader.show();

      if (_titleController.text.isEmpty ||
          _descriptionController.text.isEmpty ||
          _priceController.text.isEmpty ||
          _tagsController.text.isEmpty) {
        throw "Don't leave empty fields";
      }

      if (widget.service.disabled) {
        throw "Service is disabled";
      }

      final navigator = Navigator.of(context);
      final provider = context.read<ControlCenterProvider>();

      final updatedData = UpdateServiceModel(
        id: widget.service.id,
        vendorId: widget.service.vendorId,
        title: _titleController.text,
        description: _descriptionController.text,
        price: double.parse(_priceController.text),
        pricingType: _pricingType,
        tags: _tagsController.text
            .split(",")
            .map((tag) => tag.trim().toLowerCase())
            .toList(),
      );

      await provider.updateService(updatedData, widget.service.extras);

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
