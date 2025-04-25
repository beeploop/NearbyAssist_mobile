import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nearby_assist/models/booking_model.dart';
import 'package:nearby_assist/pages/account/bookings/to_rate/rate_page.dart';
import 'package:nearby_assist/pages/account/bookings/widget/menu.dart';
import 'package:nearby_assist/pages/booking/widget/row_tile.dart';
import 'package:nearby_assist/utils/money_formatter.dart';

class ToRateSummaryPage extends StatefulWidget {
  const ToRateSummaryPage({super.key, required this.booking});

  final BookingModel booking;

  @override
  State<ToRateSummaryPage> createState() => _ToRateSummaryPageState();
}

class _ToRateSummaryPageState extends State<ToRateSummaryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Details',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          Menu(booking: widget.booking),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                label: 'Base Rate:',
                text: formatCurrency(widget.booking.service.rate),
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
              const SizedBox(height: 20),

              // Actions
              FilledButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => RatePage(booking: widget.booking),
                    ),
                  );
                },
                style: const ButtonStyle(
                  minimumSize: WidgetStatePropertyAll(Size.fromHeight(50)),
                ),
                child: const Text('Rate'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
