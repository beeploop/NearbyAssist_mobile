import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nearby_assist/models/booking_model.dart';
import 'package:nearby_assist/pages/account/bookings/to_rate/rate_page.dart';
import 'package:nearby_assist/pages/account/bookings/widget/menu.dart';
import 'package:nearby_assist/pages/booking/widget/row_tile.dart';
import 'package:nearby_assist/utils/date_formatter.dart';
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
              // Date created
              Row(
                children: [
                  const Text('Date Booked',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const Spacer(),
                  Text(
                    DateFormatter.yearMonthDateFromDT(widget.booking.createdAt),
                  ),
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

              // Title
              const AutoSizeText(
                'Title:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              AutoSizeText(
                widget.booking.serviceTitle,
              ),
              const SizedBox(height: 10),

              // Description
              const AutoSizeText(
                'Description',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              AutoSizeText(
                widget.booking.serviceDescription,
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
              const SizedBox(height: 20),
              const AutoSizeText(
                'Add-ons:',
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
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: FilledButton(
          onPressed: () {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => RatePage(booking: widget.booking),
              ),
            );
          },
          style: ButtonStyle(
            shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            minimumSize: const WidgetStatePropertyAll(
              Size.fromHeight(50),
            ),
          ),
          child: const Text('Rate'),
        ),
      ),
    );
  }
}
