import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:nearby_assist/models/new_extra.dart';
import 'package:nearby_assist/models/new_service.dart';
import 'package:nearby_assist/models/pricing_type.dart';
import 'package:nearby_assist/pages/account/control_center/services/publish_service/service_overview.dart';
import 'package:nearby_assist/pages/account/control_center/services/publish_service/service_pricing.dart';
import 'package:nearby_assist/pages/account/control_center/services/publish_service/service_publish.dart';
import 'package:nearby_assist/pages/account/control_center/services/publish_service/widget/service_extra.dart';
import 'package:nearby_assist/providers/control_center_provider.dart';
import 'package:nearby_assist/providers/user_provider.dart';
import 'package:nearby_assist/utils/custom_snackbar.dart';
import 'package:nearby_assist/utils/show_generic_error_modal.dart';
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
  final _tagsController = TextEditingController();
  PricingType _pricingType = PricingType.fixed;
  final List<ServiceExtra> _serviceExtras = [];

  int _currentStep = 0;

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      child: Scaffold(
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
          tagsController: _tagsController,
        ),
      ),
      Step(
        isActive: _currentStep >= 1,
        title: const Text('Step 2'),
        content: ServicePricing(
          basePriceController: _basePriceController,
          onPricingTypeChange: (type) {
            setState(() {
              _pricingType = type;
            });
          },
          defaultPricing: _pricingType,
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
          _descriptionController.text.isEmpty ||
          _tagsController.text.isEmpty) {
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
    final loader = context.loaderOverlay;

    try {
      loader.show();

      final provider = context.read<ControlCenterProvider>();
      final user = context.read<UserProvider>().user;

      final service = NewService(
        vendorId: user.id,
        title: _titleController.text,
        description: _descriptionController.text,
        price: double.tryParse(_basePriceController.text) ?? 0,
        pricingType: _pricingType,
        tags: _tagsController.text
            .split(",")
            .map((tag) => tag.trim().toLowerCase())
            .toList(),
        extras: _serviceExtras
            .map((extra) => NewExtra(
                  title: extra.controller.title,
                  description: extra.controller.description,
                  price: extra.controller.price,
                ))
            .toList(),
      );

      await provider.addService(service);

      _onSuccess();
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

  void _onSuccess() {
    showCustomSnackBar(
      context,
      'Service published',
      backgroundColor: Colors.green,
      textColor: Colors.white,
      closeIconColor: Colors.white,
      duration: const Duration(seconds: 5),
    );

    Navigator.pop(context);
  }
}
