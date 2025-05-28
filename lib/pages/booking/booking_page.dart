import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:nearby_assist/models/booking_request_model.dart';
import 'package:nearby_assist/models/detailed_service_model.dart';
import 'package:nearby_assist/models/pricing_type.dart';
import 'package:nearby_assist/models/service_extra_model.dart';
import 'package:nearby_assist/pages/booking/widget/service_information_section.dart';
import 'package:nearby_assist/pages/booking/widget/summary_section.dart';
import 'package:nearby_assist/pages/booking/widget/user_information_section.dart';
import 'package:nearby_assist/providers/client_booking_provider.dart';
import 'package:nearby_assist/providers/user_provider.dart';
import 'package:nearby_assist/utils/custom_snackbar.dart';
import 'package:provider/provider.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({super.key, required this.details});

  final DetailedServiceModel details;

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  final List<ServiceExtraModel> _selectedExtras = [];
  final _addressController = TextEditingController();
  final _quantityController = TextEditingController(text: '1');
  DateTimeRange _selectedDates = DateTimeRange(
    start: DateTime.now(),
    end: DateTime.now(),
  );
  final _scheduleController = TextEditingController();

  int _currentStep = 0;

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'Booking',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
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
        content: ServiceInformationSection(
          pricingType: widget.details.service.pricingType,
          quantityController: _quantityController,
          selectedExtras: _selectedExtras,
          scheduleController: _scheduleController,
          details: widget.details,
          onSelectedDateRangeCallback: _updateSelectedRangeCallback,
        ),
      ),
      Step(
        isActive: _currentStep >= 1,
        title: const Text('Step 2'),
        content: UserInformationSection(
          addressController: _addressController,
        ),
      ),
      Step(
        isActive: _currentStep >= 2,
        title: const Text('Step 3'),
        content: SummarySection(
          quantityController: _quantityController,
          detail: widget.details,
          clientAddress: _addressController.text,
          selectedExtras: _selectedExtras,
          scheduleController: _scheduleController,
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
      Navigator.pop(context);
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
                    onPressed: _showBookingConfirmation,
                    child: const Text('Submit Request'),
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

  bool _isValid() {
    if (_currentStep == 0) {
      final quantity = int.tryParse(_quantityController.text);
      if (quantity == null || quantity < 1) {
        _showErrorSnackbar('Invalid quantity');
        return false;
      }

      if (_scheduleController.text.isEmpty) {
        if (!mounted) return false;
        showCustomSnackBar(
          context,
          'Set preferred schedule',
          backgroundColor: Colors.amber,
          textColor: Colors.black,
          closeIconColor: Colors.black87,
          dismissable: true,
          duration: const Duration(seconds: 5),
        );

        return false;
      }
    }

    return true;
  }

  void _showBookingConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(
          CupertinoIcons.question_circle,
          color: Colors.amber,
          size: 40,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        title: const Text('Confirm', style: TextStyle(fontSize: 20)),
        content: const Text('Are you sure you want to submit this request?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _book();
            },
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }

  Future<void> _book() async {
    final loader = context.loaderOverlay;

    try {
      loader.show();

      final quantity = int.tryParse(_quantityController.text);
      if (quantity == null || quantity < 1) throw "Invalid quantity amount";

      final start = _selectedDates.start.toString().split(" ")[0];
      final end = _selectedDates.end.toString().split(" ")[0];

      final booking = BookingRequestModel(
        vendorId: widget.details.vendor.id,
        clientId: context.read<UserProvider>().user.id,
        serviceId: widget.details.service.id,
        extras: _selectedExtras,
        quantity: quantity,
        totalCost: _computeTotal().toString(),
        requestedStart: start,
        requestedEnd: end,
      );

      await context.read<ClientBookingProvider>().book(booking);
      _onSuccess();
    } on DioException catch (error) {
      _onError(error.response?.data['message']);
    } catch (error) {
      _onError(error.toString());
    } finally {
      loader.hide();
    }
  }

  void _onSuccess() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          icon: const Icon(
            CupertinoIcons.check_mark_circled_solid,
            color: Colors.green,
            size: 40,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: const Text('Booking Successful'),
          content: const Text(
              'Please wait for the vendor to contact you and confirm your booking.'),
          actions: [
            TextButton(
              onPressed: () {
                context.pop();
                context.pop();
              },
              child: const Text('OK'),
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
          title: const Text('Booking Failed'),
          content: Text(error),
          actions: [
            TextButton(
              onPressed: () {
                context.pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  double _computeTotal() {
    final quantity = int.tryParse(_quantityController.text) ?? 1;
    final service = widget.details.service;

    final base = switch (widget.details.service.pricingType) {
      PricingType.fixed => service.price,
      PricingType.perHour => service.price * quantity,
      PricingType.perDay => service.price * quantity,
    };

    return _selectedExtras.fold(base, (prev, extra) => prev + extra.price);
  }

  void _updateSelectedRangeCallback(DateTime startDate, DateTime endDate) {
    setState(() {
      _selectedDates = DateTimeRange(
        start: startDate,
        end: endDate,
      );

      final start = _selectedDates.start.toString().split(" ")[0];
      final end = _selectedDates.end.toString().split(" ")[0];
      _scheduleController.text = '$start - $end';
    });
  }

  void _showErrorSnackbar(String error) {
    showCustomSnackBar(
      context,
      error,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      closeIconColor: Colors.white,
      dismissable: true,
      duration: const Duration(seconds: 5),
    );
  }
}
