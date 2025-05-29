import 'package:auto_size_text/auto_size_text.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:nearby_assist/models/booking_model.dart';
import 'package:nearby_assist/models/pricing_type.dart';
import 'package:nearby_assist/pages/account/widget/booking_status_chip.dart';
import 'package:nearby_assist/pages/account/widget/input_field.dart';
import 'package:nearby_assist/pages/booking/widget/row_tile.dart';
import 'package:nearby_assist/providers/client_booking_provider.dart';
import 'package:nearby_assist/utils/date_formatter.dart';
import 'package:nearby_assist/utils/format_quantity_booked.dart';
import 'package:nearby_assist/utils/money_formatter.dart';
import 'package:nearby_assist/utils/show_generic_error_modal.dart';
import 'package:nearby_assist/utils/show_generic_success_modal.dart';
import 'package:provider/provider.dart';

class PendingRequestSummaryPage extends StatefulWidget {
  const PendingRequestSummaryPage({
    super.key,
    required this.booking,
  });

  final BookingModel booking;

  @override
  State<PendingRequestSummaryPage> createState() =>
      _PendingRequestSummaryPageState();
}

class _PendingRequestSummaryPageState extends State<PendingRequestSummaryPage> {
  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'Booking Summary',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.pushNamed(
                  'chat',
                  queryParameters: {
                    'recipientId': widget.booking.vendor.id,
                    'recipient': widget.booking.vendor.name,
                  },
                );
              },
              icon: const Icon(CupertinoIcons.ellipses_bubble),
            ),
            const SizedBox(width: 20),
          ],
        ),
        body: Padding(
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
                          color: Colors.grey.shade900,
                        )),
                    const Spacer(),
                    BookingStatusChip(status: widget.booking.status),
                  ],
                ),
                const Divider(),

                // Date created
                Row(
                  children: [
                    const Text('Date Booked',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const Spacer(),
                    Text(
                      DateFormatter.yearMonthDateFromDT(
                          widget.booking.createdAt),
                    ),
                  ],
                ),
                const Divider(),

                // Vendor information
                const SizedBox(height: 20),
                Text(
                  'Vendor Information',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 20),
                RowTile(
                    label: 'Vendor Name:', text: widget.booking.vendor.name),
                const Divider(),

                // Client information
                const SizedBox(height: 20),
                Text(
                  'Client Information',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 20),
                RowTile(
                    label: 'Client Name:', text: widget.booking.client.name),
                const Divider(),

                // Service Price
                const SizedBox(height: 20),
                Text(
                  'Service Information',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 20),

                // Title
                AutoSizeText(
                  'Title:',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                AutoSizeText(
                  widget.booking.serviceTitle,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 10),

                // Description
                AutoSizeText(
                  'Description',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                AutoSizeText(
                  widget.booking.serviceDescription,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 20),

                RowTile(
                  label: 'Base Price:',
                  text: formatCurrency(widget.booking.price),
                ),
                const SizedBox(height: 10),
                RowTile(
                  label: 'Pricing Type',
                  text: widget.booking.pricingType.label,
                ),

                // Dates and schedules
                if (widget.booking.pricingType != PricingType.fixed)
                  const SizedBox(height: 10),
                if (widget.booking.pricingType != PricingType.fixed)
                  RowTile(
                    label: 'Booked for',
                    text: formatQuantityBooked(
                      widget.booking.quantity,
                      widget.booking.pricingType,
                    ),
                  ),
                const SizedBox(height: 20),
                AutoSizeText(
                  'Add-ons:',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
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

                // Dates
                const SizedBox(height: 20),
                Row(
                  children: [
                    Text(
                      'Preferred schedule',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    Text(
                      _pickedDateFormat(),
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Divider(),

                // Estimated cost
                const SizedBox(height: 20),
                RowTile(
                  label: 'Total Cost:',
                  text: formatCurrency(widget.booking.total()),
                ),
                const SizedBox(height: 20),

                // Cancel Button
                const SizedBox(height: 20),
                FilledButton(
                  onPressed: _cancelConfirmation,
                  style: const ButtonStyle(
                    minimumSize: WidgetStatePropertyAll(Size.fromHeight(50)),
                    backgroundColor: WidgetStatePropertyAll(Colors.red),
                  ),
                  child: const Text('Cancel'),
                ),

                // For padding the bottom
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _cancelConfirmation() {
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
        title: Text(
          'Are you sure?',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        content: InputField(
          controller: reason,
          hintText: 'Reason',
          minLines: 3,
          maxLines: 6,
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.pop();
              _handleCancelBooking(reason.text);
            },
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }

  void _handleCancelBooking(String reason) async {
    final loader = context.loaderOverlay;

    try {
      loader.show();

      if (reason.isEmpty) {
        throw 'Provide reason for cancellation';
      }

      await context
          .read<ClientBookingProvider>()
          .cancelPending(widget.booking.id, reason);

      if (!mounted) return;
      showGenericSuccessModal(context, message: 'Booking request cancelled');
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

  String _pickedDateFormat() {
    if (widget.booking.pricingType == PricingType.perDay) {
      return '${DateFormatter.yearMonthDateFromDT(widget.booking.requestedStart)} - ${DateFormatter.yearMonthDateFromDT(widget.booking.requestedEnd)}';
    }

    return DateFormatter.yearMonthDateFromDT(widget.booking.requestedStart);
  }
}
