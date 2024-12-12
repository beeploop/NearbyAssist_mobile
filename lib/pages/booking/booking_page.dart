import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/models/booking_model.dart';
import 'package:nearby_assist/models/detailed_service_model.dart';
import 'package:nearby_assist/models/service_extra_model.dart';
import 'package:nearby_assist/pages/booking/widget/service_information_section.dart';
import 'package:nearby_assist/pages/booking/widget/summary_section.dart';
import 'package:nearby_assist/pages/booking/widget/user_information_section.dart';
import 'package:nearby_assist/providers/transaction_provider.dart';
import 'package:nearby_assist/providers/user_provider.dart';
import 'package:nearby_assist/utils/pretty_json.dart';
import 'package:provider/provider.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({super.key, required this.details});

  final DetailedServiceModel details;

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  final List<ServiceExtraModel> _selectedExtras = [];
  String _clientAddress = '';

  int _currentStep = 0;

  @override
  void initState() {
    super.initState();
    final user = Provider.of<UserProvider>(context, listen: false).user;
    if (user.address != null) {
      _clientAddress = user.address!;
    }
  }

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
          selectedExtras: _selectedExtras,
          details: widget.details,
        ),
      ),
      Step(
        isActive: _currentStep >= 1,
        title: const Text('Step 2'),
        content: UserInformationSection(
          onAddressLocated: _onAddressLocated,
        ),
      ),
      Step(
        isActive: _currentStep >= 2,
        title: const Text('Step 3'),
        content: SummarySection(
          detail: widget.details,
          clientAddress: _clientAddress,
          selectedExtras: _selectedExtras,
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

  void _onAddressLocated(String address) {
    setState(() {
      _clientAddress = address;
    });
  }

  bool _isValid() {
    return true;
  }

  Future<void> _book() async {
    final booking = BookingModel(
      vendorId: widget.details.vendor.id,
      clientId: context.read<UserProvider>().user.id,
      serviceId: widget.details.service.id,
      extras: _selectedExtras,
      totalCost: _computeTotal().toString(),
    );

    logger.log(prettyJSON(booking));

    try {
      await context.read<TransactionProvider>().createTransaction(booking);

      _onSuccess();
    } catch (error) {
      _onError(error.toString());
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
    double total = widget.details.service.rate;
    for (final extra in _selectedExtras) {
      total += extra.price;
    }
    return total;
  }
}
