import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:nearby_assist/models/detailed_service_model.dart';
import 'package:nearby_assist/models/pricing_type.dart';
import 'package:nearby_assist/models/service_extra_model.dart';
import 'package:nearby_assist/pages/booking/widget/row_tile.dart';
import 'package:nearby_assist/utils/date_formatter.dart';
import 'package:nearby_assist/utils/money_formatter.dart';
import 'package:nearby_assist/utils/show_generic_error_modal.dart';

class ServiceInformationSection extends StatefulWidget {
  const ServiceInformationSection({
    super.key,
    required this.pricingType,
    required this.quantityController,
    required this.selectedExtras,
    required this.scheduleController,
    required this.details,
    required this.onSelectedDateRangeCallback,
  });

  final PricingType pricingType;
  final TextEditingController quantityController;
  final List<ServiceExtraModel> selectedExtras;
  final TextEditingController scheduleController;
  final DetailedServiceModel details;
  final void Function(DateTime start, DateTime end) onSelectedDateRangeCallback;

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

        // Description
        const Text(
          'Description',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(widget.details.service.description),
        const SizedBox(height: 20),

        // Schedule
        Row(
          children: [
            const Text(
              'Preferred schedule',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            TextButton(
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                visualDensity: VisualDensity.compact,
                padding: const EdgeInsets.all(0),
              ),
              onPressed: () {
                if (widget.pricingType == PricingType.perDay) {
                  _pickDateRange();
                } else {
                  _pickDate();
                }
              },
              child: Text(widget.scheduleController.text.isEmpty
                  ? 'Pick date'
                  : _pickedDateFormat()),
            ),
          ],
        ),
        const SizedBox(height: 10),

        // Base Price
        RowTile(
          label: 'Base Price',
          text: formatCurrency(widget.details.service.price),
        ),
        const SizedBox(height: 20),

        // Pricing type
        RowTile(label: 'Pricing Type', text: widget.pricingType.label),
        const SizedBox(height: 10),

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

        // Add-ons
        const Text('Add-ons:', style: TextStyle(fontWeight: FontWeight.bold)),
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

  Future<void> _pickDate() async {
    DateTime? schedule = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(
        const Duration(days: 30),
      ), // restrict schedule to 30 days advance
    );

    if (schedule == null) return;
    widget.onSelectedDateRangeCallback(schedule, schedule);
  }

  Future<void> _pickDateRange() async {
    final range = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(
        const Duration(days: 30),
      ), // restrict schedule to 30 days advance
    );

    if (range == null) return;

    if (widget.details.service.pricingType == PricingType.perDay) {
      // add 1 because inDays counts the next day as day 1
      final days = range.duration.inDays + 1;

      if (!mounted) return;
      switch (days.compareTo(int.parse(widget.quantityController.text))) {
        case -1:
          showGenericErrorModal(
            context,
            message:
                'Range of dates selected is less than requested number of days',
          );
          return;
        case 1:
          showGenericErrorModal(
            context,
            message:
                'Range of dates selected is greater than requested number of days',
          );
          return;
      }
    }

    widget.onSelectedDateRangeCallback(range.start, range.end);
  }

  String _pickedDateFormat() {
    final dates = widget.scheduleController.text.split(" - ");

    if (widget.pricingType == PricingType.perDay) {
      return '${DateFormatter.yearMonthDate(dates[0])} - ${DateFormatter.yearMonthDate(dates[1])}';
    }
    return DateFormatter.yearMonthDate(dates[0]);
  }
}
