import 'package:flutter/material.dart';
import 'package:nearby_assist/models/detailed_service_model.dart';
import 'package:nearby_assist/models/pricing_type.dart';
import 'package:nearby_assist/models/service_extra_model.dart';
import 'package:nearby_assist/pages/booking/widget/row_tile.dart';
import 'package:nearby_assist/providers/user_provider.dart';
import 'package:nearby_assist/utils/date_formatter.dart';
import 'package:nearby_assist/utils/format_quantity_booked.dart';
import 'package:nearby_assist/utils/money_formatter.dart';
import 'package:provider/provider.dart';

class SummarySection extends StatefulWidget {
  const SummarySection({
    super.key,
    required this.quantityController,
    required this.detail,
    required this.clientAddress,
    required this.selectedExtras,
    required this.scheduleController,
  });

  final TextEditingController quantityController;
  final DetailedServiceModel detail;
  final String clientAddress;
  final List<ServiceExtraModel> selectedExtras;
  final TextEditingController scheduleController;

  @override
  State<SummarySection> createState() => _SummarySectionState();
}

class _SummarySectionState extends State<SummarySection> {
  @override
  Widget build(BuildContext context) {
    final user = context.read<UserProvider>().user;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Summary',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),

        // Vendor information
        const SizedBox(height: 20),
        const Text('Vendor Information', style: TextStyle(fontSize: 16)),
        const SizedBox(height: 20),
        RowTile(label: 'Vendor Name:', text: widget.detail.vendor.name),
        const SizedBox(height: 10),
        RowTile(label: 'Vendor Email:', text: widget.detail.vendor.email),
        const Divider(),

        // Client information
        const SizedBox(height: 20),
        const Text('Client Information', style: TextStyle(fontSize: 16)),
        const SizedBox(height: 20),
        RowTile(label: 'Client Name:', text: user.name),
        const SizedBox(height: 10),
        RowTile(label: 'Client Email:', text: user.email),
        const Divider(),

        // Service information
        const SizedBox(height: 20),
        const Text('Service Information', style: TextStyle(fontSize: 16)),

        // Service Price
        const SizedBox(height: 20),
        RowTile(
          label: 'Base Price:',
          text: formatCurrency(widget.detail.service.price),
        ),
        const SizedBox(height: 20),
        RowTile(
          label: 'Pricing Type:',
          text: widget.detail.service.pricingType.label,
        ),
        const SizedBox(height: 20),
        if (widget.detail.service.pricingType != PricingType.fixed)
          const SizedBox(height: 10),
        if (widget.detail.service.pricingType != PricingType.fixed)
          RowTile(
            label: 'Booking for:',
            text: formatQuantityBooked(
              int.tryParse(widget.quantityController.text) ?? 1,
              widget.detail.service.pricingType,
            ),
          ),
        const SizedBox(height: 20),
        const Text(
          'Add-ons:',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        ...widget.selectedExtras.map((extra) {
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
            const Text(
              'Preferred schedule',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            Text(_pickedDateFormat()),
          ],
        ),
        const SizedBox(height: 20),
        const Divider(),

        // Estimated cost
        const SizedBox(height: 20),
        RowTile(
          label: 'Total Cost:',
          text: formatCurrency(_calculateTotalCost()),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  double _calculateTotalCost() {
    final quantity = int.tryParse(widget.quantityController.text) ?? 1;
    final service = widget.detail.service;

    final base = switch (widget.detail.service.pricingType) {
      PricingType.fixed => service.price,
      PricingType.perHour => service.price * quantity,
      PricingType.perDay => service.price * quantity,
    };

    return widget.selectedExtras
        .fold(base, (prev, extra) => prev + extra.price);
  }

  String _pickedDateFormat() {
    if (widget.scheduleController.text.isEmpty) {
      return "";
    }

    final dates = widget.scheduleController.text.split(" - ");

    if (widget.detail.service.pricingType == PricingType.perDay) {
      return '${DateFormatter.yearMonthDate(dates[0])} - ${DateFormatter.yearMonthDate(dates[1])}';
    }
    return DateFormatter.yearMonthDate(dates[0]);
  }
}
