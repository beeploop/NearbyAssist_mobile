import 'package:flutter/material.dart';
import 'package:nearby_assist/pages/account/services/publish_service/service_gallery.dart';
import 'package:nearby_assist/pages/account/services/publish_service/service_overview.dart';
import 'package:nearby_assist/pages/account/services/publish_service/service_pricing.dart';
import 'package:nearby_assist/pages/account/services/publish_service/service_publish.dart';

class PublishServicePage extends StatefulWidget {
  const PublishServicePage({super.key});

  @override
  State<PublishServicePage> createState() => _PublishServicePageState();
}

class _PublishServicePageState extends State<PublishServicePage> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

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
        ),
      ),
      Step(
        isActive: _currentStep >= 1,
        title: const Text('Step 2'),
        content: const ServicePricing(),
      ),
      Step(
        isActive: _currentStep >= 2,
        title: const Text('Step 3'),
        content: const ServiceGallery(),
      ),
      Step(
        isActive: _currentStep >= 3,
        title: const Text('Step 4'),
        content: const ServicePublish(),
      ),
    ];
  }

  void _onContinue() {
    if (_currentStep >= 3) {
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
          _currentStep >= 3
              ? Expanded(
                  child: FilledButton(
                    onPressed: () {},
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
}
