import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nearby_assist/models/booking_model.dart';
import 'package:nearby_assist/pages/account/widget/booking_status_chip.dart';
import 'package:nearby_assist/pages/booking/widget/row_tile.dart';

class ClientHistorySummaryPage extends StatefulWidget {
  const ClientHistorySummaryPage({
    super.key,
    required this.booking,
    this.showChatIcon = false,
  });

  final BookingModel booking;
  final bool showChatIcon;

  @override
  State<ClientHistorySummaryPage> createState() =>
      _ClientHistorySummaryPageState();
}

class _ClientHistorySummaryPageState extends State<ClientHistorySummaryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'History',
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
}
