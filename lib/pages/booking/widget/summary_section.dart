import 'package:flutter/material.dart';
import 'package:nearby_assist/models/detailed_service_model.dart';
import 'package:nearby_assist/models/service_extra_model.dart';
import 'package:nearby_assist/pages/booking/widget/row_tile.dart';
import 'package:nearby_assist/providers/user_provider.dart';
import 'package:nearby_assist/utils/money_formatter.dart';
import 'package:provider/provider.dart';

class SummarySection extends StatefulWidget {
  const SummarySection({
    super.key,
    required this.detail,
    required this.clientAddress,
    required this.selectedExtras,
  });

  final DetailedServiceModel detail;
  final String clientAddress;
  final List<ServiceExtraModel> selectedExtras;

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

        // Service Price
        const SizedBox(height: 20),
        const Text('Service Information', style: TextStyle(fontSize: 16)),

        // Extras
        const SizedBox(height: 20),
        RowTile(
          label: 'Base Rate:',
          text: formatCurrency(widget.detail.service.rate),
        ),
        const SizedBox(height: 20),
        const Text(
          'Extras:',
          style: TextStyle(
            fontSize: 18,
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
    double total = widget.detail.service.rate;
    for (final extra in widget.selectedExtras) {
      total += extra.price;
    }
    return total;
  }
}
