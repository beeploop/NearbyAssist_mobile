import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nearby_assist/config/employment_type.dart';
import 'package:nearby_assist/models/detailed_service_model.dart';
import 'package:nearby_assist/pages/booking/widget/date_picker_controller.dart';
import 'package:nearby_assist/pages/booking/widget/service_information_section.dart';
import 'package:nearby_assist/pages/booking/widget/summary_section.dart';
import 'package:nearby_assist/pages/booking/widget/user_information_section.dart';
import 'package:nearby_assist/providers/user_provider.dart';
import 'package:provider/provider.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({super.key, required this.details});

  final DetailedServiceModel details;

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  EmploymentType? _employmentType = EmploymentType.pakyaw;
  final _calendarController = DatePickerController();

  int _currentStep = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Booking',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: context.read<UserProvider>().user.isVerified == false
          ? Center(
              child: AlertDialog(
                icon: const Icon(CupertinoIcons.exclamationmark_triangle),
                title: const Text('Account not verified'),
                content: const Text(
                    'Please verify your account to unlock more features'),
                actions: [
                  TextButton(
                    onPressed: () => context.pop(),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () => context.pushNamed('verifyAccount'),
                    child: const Text('Verify'),
                  ),
                ],
              ),
            )
          : Stepper(
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
        content: ServiceInformationSection(
          details: widget.details,
          calendarController: _calendarController,
          employmentType: _employmentType,
          onEmploymentTypeChange: _onChangeEmploymentType,
        ),
      ),
      Step(
        isActive: _currentStep >= 1,
        title: const Text('Step 2'),
        content: const UserInformationSection(),
      ),
      Step(
        isActive: _currentStep >= 2,
        title: const Text('Step 3'),
        content: SummarySection(
          detail: widget.details,
          calendarController: _calendarController,
          employmentType: _employmentType!,
        ),
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
                    onPressed: _book,
                    child: const Text('Book'),
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

  void _onChangeEmploymentType(EmploymentType? value) {
    setState(() {
      _employmentType = value;
    });
  }

  bool _isValid() {
    return true;
  }

  Future<void> _book() async {
    //
  }
}
