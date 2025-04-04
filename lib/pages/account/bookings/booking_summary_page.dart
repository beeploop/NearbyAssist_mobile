import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nearby_assist/models/booking_model.dart';
import 'package:nearby_assist/pages/account/bookings/widget/booking_status_chip.dart';
import 'package:nearby_assist/pages/account/widget/input_field.dart';
import 'package:nearby_assist/pages/booking/widget/row_tile.dart';
import 'package:nearby_assist/providers/booking_provider.dart';
import 'package:provider/provider.dart';

class BookingSummaryPage extends StatefulWidget {
  const BookingSummaryPage({
    super.key,
    required this.booking,
    this.showChatIcon = false,
  });

  final BookingModel booking;
  final bool showChatIcon;

  @override
  State<BookingSummaryPage> createState() => _BookingSummaryPageState();
}

class _BookingSummaryPageState extends State<BookingSummaryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Booking Summary',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          if (widget.showChatIcon)
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
        padding: const EdgeInsets.all(20),
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
                        color: Colors.grey[900],
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
              AutoSizeText(
                widget.booking.service.title,
              ),
              const SizedBox(height: 10),
              RowTile(
                  label: 'Base Rate:',
                  text: '₱ ${widget.booking.service.rate}'),
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
                  text: '₱ ${extra.price}',
                  withLeftPad: true,
                );
              }),
              const SizedBox(height: 20),
              const Divider(),

              // Estimated cost
              const SizedBox(height: 20),
              RowTile(label: 'Total Cost:', text: '₱ ${_calculateTotalCost()}'),
              const SizedBox(height: 20),

              // Cancel Button
              const SizedBox(height: 20),
              if (widget.booking.status == BookingStatus.pending)
                FilledButton(
                  onPressed: () {
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
                        title: const Text('Are you sure?'),
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
                              _cancelBooking(reason.text);
                            },
                            child: const Text('Continue'),
                          ),
                        ],
                      ),
                    );
                  },
                  style: const ButtonStyle(
                    minimumSize: WidgetStatePropertyAll(Size.fromHeight(50)),
                    backgroundColor: WidgetStatePropertyAll(Colors.red),
                  ),
                  child: const Text('Cancel'),
                ),
            ],
          ),
        ),
      ),
    );
  }

  double _calculateTotalCost() {
    double total = widget.booking.service.rate;
    for (final extra in widget.booking.extras) {
      total += extra.price;
    }
    return total;
  }

  void _cancelBooking(String reason) async {
    try {
      if (reason.isEmpty) {
        throw 'Provide reason for cancellation';
      }

      await context
          .read<BookingProvider>()
          .cancelBookingRequest(widget.booking.id, reason);

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
          title: const Text('Successful'),
          content:
              const Text('You successfully cancelled your booking request'),
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
          title: const Text('Failed'),
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
}
