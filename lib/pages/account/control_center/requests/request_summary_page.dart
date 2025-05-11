import 'package:auto_size_text/auto_size_text.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:nearby_assist/models/booking_model.dart';
import 'package:nearby_assist/models/user_model.dart';
import 'package:nearby_assist/pages/account/widget/booking_status_chip.dart';
import 'package:nearby_assist/pages/account/widget/input_field.dart';
import 'package:nearby_assist/pages/booking/widget/row_tile.dart';
import 'package:nearby_assist/providers/control_center_provider.dart';
import 'package:nearby_assist/providers/user_provider.dart';
import 'package:nearby_assist/utils/money_formatter.dart';
import 'package:nearby_assist/utils/show_generic_error_modal.dart';
import 'package:nearby_assist/utils/show_generic_success_modal.dart';
import 'package:nearby_assist/utils/show_restricted_account_modal.dart';
import 'package:provider/provider.dart';

class RequestSummaryPage extends StatefulWidget {
  const RequestSummaryPage({
    super.key,
    required this.booking,
  });

  final BookingModel booking;

  @override
  State<RequestSummaryPage> createState() => _RequestSummaryPageState();
}

class _RequestSummaryPageState extends State<RequestSummaryPage> {
  final _scheduleController = TextEditingController();
  late UserModel _user;

  @override
  void initState() {
    super.initState();

    _user = Provider.of<UserProvider>(context, listen: false).user;
  }

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'Received',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.pushNamed(
                  'chat',
                  queryParameters: {
                    'recipientId': widget.booking.client.id,
                    'recipient': widget.booking.client.name,
                  },
                );
              },
              icon: const Icon(CupertinoIcons.ellipses_bubble),
            ),
            const SizedBox(width: 20),
          ],
        ),
        body: _body(context),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
          child: Row(
            children: [
              // Reject button
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: widget.booking.status == BookingStatus.cancelled
                          ? Colors.grey
                          : Colors.red,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: widget.booking.status != BookingStatus.cancelled
                      ? _onTapReject
                      : () {},
                  child: Text(
                    'Reject',
                    style: TextStyle(
                      color: widget.booking.status == BookingStatus.cancelled
                          ? Colors.grey
                          : Colors.red,
                    ),
                  ),
                ),
              ),

              // Gap
              const SizedBox(width: 10),

              // Accept button
              Expanded(
                child: FilledButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(
                      widget.booking.status == BookingStatus.cancelled
                          ? Colors.grey
                          : null,
                    ),
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  onPressed: widget.booking.status != BookingStatus.cancelled
                      ? _onTapAccept
                      : () {},
                  child: const Text('Accept'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Padding _body(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status
            Row(
              children: [
                Text('Status',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade800,
                    )),
                const Spacer(),
                BookingStatusChip(status: widget.booking.status),
              ],
            ),
            const Divider(),

            // Vendor information
            const SizedBox(height: 20),
            const Text('Vendor Information', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            RowTile(label: 'Vendor Name:', text: widget.booking.vendor.name),
            const Divider(),

            // Client information
            const SizedBox(height: 20),
            const Text('Client Information', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            RowTile(label: 'Client Name:', text: widget.booking.client.name),
            const Divider(),

            // Service Price
            const SizedBox(height: 20),
            const Text('Service Information', style: TextStyle(fontSize: 16)),

            // Extras
            const SizedBox(height: 20),
            AutoSizeText(widget.booking.service.title),
            const SizedBox(height: 10),
            RowTile(
              label: 'Base Price:',
              text: formatCurrency(widget.booking.service.price),
            ),
            const SizedBox(height: 10),
            RowTile(
              label: 'Pricing Type',
              text: widget.booking.service.pricingType.label,
            ),
            const SizedBox(height: 20),
            const AutoSizeText(
              'Extras:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            ...widget.booking.extras.map((extra) {
              return RowTile(
                label: extra.title,
                text: formatCurrency(extra.price),
                withLeftPad: true,
              );
            }),
            const SizedBox(height: 20),
            const Divider(),

            // Estimated cost
            const SizedBox(height: 20),
            RowTile(
              label: 'Total Cost:',
              text: formatCurrency(widget.booking.total()),
            ),

            // Bottom padding
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  void _onTapAccept() {
    if (_user.isRestricted) {
      showAccountRestrictedModal(context);
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(
          CupertinoIcons.question_circle,
          color: Colors.green,
          size: 40,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        title: const Text(
          'Set a schedule for this booking',
          style: TextStyle(fontSize: 20),
        ),
        content: TextField(
          controller: _scheduleController,
          decoration: const InputDecoration(
            labelText: 'Schedule',
            filled: true,
            prefixIcon: Icon(CupertinoIcons.calendar),
          ),
          readOnly: true,
          onTap: _pickDate,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => _confirmRequest(
              widget.booking.id,
              _scheduleController.text,
            ),
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }

  void _onTapReject() {
    if (_user.isRestricted) {
      showAccountRestrictedModal(context);
      return;
    }

    final reason = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(
          CupertinoIcons.question_circle,
          color: Colors.red,
          size: 40,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        title: const Text('Reject this request?'),
        content: InputField(
          controller: reason,
          hintText: 'Reason',
          minLines: 3,
          maxLines: 6,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => _rejectRequest(widget.booking.id, reason.text),
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmRequest(String id, String schedule) async {
    final loader = context.loaderOverlay;

    try {
      loader.show();
      Navigator.pop(context);

      if (schedule.isEmpty) {
        throw 'Invalid schedule';
      }

      await context.read<ControlCenterProvider>().confirm(id, schedule);

      if (!mounted) return;
      showGenericSuccessModal(context, message: 'Confirmed request');
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

  Future<void> _rejectRequest(String id, String reason) async {
    final loader = context.loaderOverlay;

    try {
      loader.show();
      Navigator.pop(context);

      if (reason.isEmpty) {
        throw 'Provide reason for rejection';
      }

      await context.read<ControlCenterProvider>().reject(id, reason);

      if (!mounted) return;
      showGenericSuccessModal(context, message: 'Rejected request');
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

  Future<void> _pickDate() async {
    DateTime? schedule = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(
          const Duration(days: 30)), // restrict schedule to 30 days advance
    );

    if (schedule == null) return;

    setState(() {
      _scheduleController.text = schedule.toString().split(" ")[0];
    });
  }
}
