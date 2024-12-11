import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:nearby_assist/models/service_extra_model.dart';
import 'package:nearby_assist/models/service_model.dart';
import 'package:nearby_assist/models/tag_model.dart';
import 'package:nearby_assist/pages/account/services/publish_service/service_overview.dart';
import 'package:nearby_assist/pages/account/services/publish_service/service_pricing.dart';
import 'package:nearby_assist/pages/account/services/publish_service/service_publish.dart';
import 'package:nearby_assist/pages/account/services/publish_service/widget/service_extra.dart';
import 'package:nearby_assist/providers/managed_service_provider.dart';
import 'package:nearby_assist/providers/user_provider.dart';
import 'package:nearby_assist/services/location_service.dart';
import 'package:nearby_assist/services/manage_services_service.dart';
import 'package:nearby_assist/utils/custom_snackbar.dart';
import 'package:provider/provider.dart';

class PublishServicePage extends StatefulWidget {
  const PublishServicePage({super.key});

  @override
  State<PublishServicePage> createState() => _PublishServicePageState();
}

class _PublishServicePageState extends State<PublishServicePage> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _basePriceController = TextEditingController();
  final List<TagModel> _selectedTags = [];
  final List<ServiceExtra> _serviceExtras = [];

  int _currentStep = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Stepper(
        type: StepperType.horizontal,
        elevation: 0,
        steps: _steps(),
        currentStep: _currentStep,
        onStepContinue: _onContinue,
        onStepCancel: _onCancel,
        controlsBuilder: _controlsBuilder,
      ),
    );
  }

  List<Step> _steps() {
    return [
      Step(
        isActive: _currentStep >= 0,
        title: const Text('Step 1'),
        content: ServiceOverview(
          titleController: _titleController,
          descriptionController: _descriptionController,
          selectedTags: _selectedTags,
        ),
      ),
      Step(
        isActive: _currentStep >= 1,
        title: const Text('Step 2'),
        content: ServicePricing(
          basePriceController: _basePriceController,
          serviceExtras: _serviceExtras,
        ),
      ),
      Step(
        isActive: _currentStep >= 2,
        title: const Text('Step 3'),
        content: const ServicePublish(),
      ),
    ];
  }

  void _onContinue() {
    if (_currentStep >= 2) {
      return;
    }

    if (!_isValid()) {
      return;
    }

    setState(() {
      _currentStep++;
    });
  }

  void _onCancel() {
    if (_currentStep <= 0) {
      return;
    }

    setState(() {
      _currentStep--;
    });
  }

  bool _isValid() {
    if (_currentStep == 0) {
      if (_titleController.text.isEmpty ||
          _descriptionController.text.isEmpty) {
        showCustomSnackBar(
          context,
          'Fill up required fields',
          backgroundColor: Colors.red,
          closeIconColor: Colors.white,
          textColor: Colors.white,
        );
        return false;
      }
    }

    if (_currentStep == 1) {
      if (_basePriceController.text.isEmpty) {
        showCustomSnackBar(
          context,
          'Set base price',
          backgroundColor: Colors.red,
          closeIconColor: Colors.white,
          textColor: Colors.white,
        );
        return false;
      }
    }

    return true;
  }

  Widget _controlsBuilder(BuildContext context, ControlsDetails controls) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: controls.onStepCancel,
              child: const Text('Back'),
            ),
          ),
          const SizedBox(width: 10),
          _currentStep >= 2
              ? Expanded(
                  child: FilledButton(
                    onPressed: _handlePublish,
                    child: const Text('Publish'),
                  ),
                )
              : Expanded(
                  child: FilledButton(
                    onPressed: controls.onStepContinue,
                    child: const Text('Continue'),
                  ),
                )
        ],
      ),
    );
  }

  void _handlePublish() async {
    try {
      final provider = context.read<ManagedServiceProvider>();
      final user = context.read<UserProvider>().user;

      final List<ServiceExtraModel> extras = [];
      for (final entry in _serviceExtras) {
        if (entry.controller.title.isEmpty ||
            entry.controller.description.isEmpty) {
          continue;
        }

        final extra = ServiceExtraModel(
          id: '',
          title: entry.controller.title,
          description: entry.controller.description,
          price: entry.controller.price,
        );

        extras.add(extra);
      }

      final location = await LocationService().getLocation();

      final service = ServiceModel(
        id: '',
        vendorId: user.id,
        title: _titleController.text,
        description: _descriptionController.text,
        rate: double.tryParse(_basePriceController.text) ?? 0,
        latitude: location.latitude,
        longitude: location.longitude,
        tags: _selectedTags.map((e) => e.title).toList(),
        extras: extras,
      );

      final response = await ManageServicesService().add(service);

      provider.add(response);

      _onSuccess();
    } catch (error) {
      if (error == LocationServiceDisabledException) {
        _showLocationServiceDisabledDialog();
        return;
      }

      _showErrorModal(error.toString());
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

  void _onSuccess() {
    showCustomSnackBar(
      context,
      'Service published successfully',
      backgroundColor: Colors.green,
      textColor: Colors.white,
      closeIconColor: Colors.white,
      duration: const Duration(seconds: 5),
    );

    context.pop();
  }

  void _showErrorModal(String error) {
    showCustomSnackBar(
      context,
      error,
      duration: const Duration(seconds: 5),
      backgroundColor: Colors.red,
      closeIconColor: Colors.white,
      textColor: Colors.white,
    );
  }
}
