import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:nearby_assist/models/detailed_service_model.dart';
import 'package:nearby_assist/models/pricing_type.dart';
import 'package:nearby_assist/models/service_extra_model.dart';
import 'package:nearby_assist/pages/booking/widget/row_tile.dart';
import 'package:nearby_assist/utils/money_formatter.dart';

class ServiceInformationSection extends StatefulWidget {
  const ServiceInformationSection({
    super.key,
    required this.pricingType,
    required this.quantityController,
    required this.selectedExtras,
    required this.details,
  });

  final PricingType pricingType;
  final TextEditingController quantityController;
  final List<ServiceExtraModel> selectedExtras;
  final DetailedServiceModel details;

  @override
  State<ServiceInformationSection> createState() =>
      _ServiceInformationSectionState();
}

class _ServiceInformationSectionState extends State<ServiceInformationSection> {
  final Map<String, bool> _selectedExtras = {};

  void initializeExtras() {
    for (final extra in widget.details.service.extras) {
      _selectedExtras[extra.id] = false;
    }
  }

  @override
  void initState() {
    super.initState();
    initializeExtras();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Service Details',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),

        // Title and description
        const Text(
          'Title',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(widget.details.service.title),
        const SizedBox(height: 20),
        const Text(
          'Description',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(widget.details.service.description),
        const SizedBox(height: 20),
        RowTile(
          label: 'Base Price',
          text: formatCurrency(widget.details.service.price),
        ),
        const SizedBox(height: 10),
        RowTile(label: 'Pricing Type', text: widget.pricingType.label),
        const SizedBox(height: 12),

        // Quantity
        if (widget.pricingType != PricingType.fixed)
          TextFormField(
            controller: widget.quantityController,
            onTapOutside: (event) => FocusScope.of(context).unfocus(),
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: () {
                switch (widget.pricingType) {
                  case PricingType.fixed:
                    return 'Quantity';
                  case PricingType.perHour:
                    return 'Hours';
                  case PricingType.perDay:
                    return 'Days';
                }
              }(),
              border: const OutlineInputBorder(),
              hintText: '',
              hintStyle: const TextStyle(color: Colors.grey),
            ),
          ),
        if (widget.pricingType != PricingType.fixed) const SizedBox(height: 10),

        const SizedBox(height: 20),
        const Divider(),
        const Text('Add-ons:', style: TextStyle(fontWeight: FontWeight.bold)),

        // Extras
        ..._buildExtras(),
      ],
    );
  }

  List<Widget> _buildExtras() {
    return widget.details.service.extras.map((extra) {
      return ListTile(
        titleAlignment: ListTileTitleAlignment.top,
        leading: Checkbox(
          onChanged: (bool? value) {
            if (value == null) return;

            setState(() {
              _selectedExtras[extra.id] = value;
            });

            if (value) {
              widget.selectedExtras.add(extra);
            } else {
              widget.selectedExtras.removeWhere((item) => item.id == extra.id);
            }
          },
          value: _selectedExtras[extra.id],
        ),
        title: Text(
          extra.title,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: ExpandableText(
          extra.description,
          expandText: 'Read more',
          collapseText: 'Show less',
          maxLines: 2,
          linkColor: Colors.blue,
        ),
        trailing: Text(
          '₱ ${extra.price}',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      );
    }).toList();
  }
}
