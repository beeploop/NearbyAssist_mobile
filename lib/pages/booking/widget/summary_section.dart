import 'package:flutter/material.dart';
import 'package:nearby_assist/config/employment_type.dart';
import 'package:nearby_assist/models/detailed_service_model.dart';
import 'package:nearby_assist/pages/booking/widget/date_picker_controller.dart';
import 'package:nearby_assist/pages/booking/widget/row_tile.dart';
import 'package:nearby_assist/providers/user_provider.dart';
import 'package:provider/provider.dart';

class SummarySection extends StatefulWidget {
  const SummarySection({
    super.key,
    required this.detail,
    required this.employmentType,
    required this.calendarController,
  });

  final DetailedServiceModel detail;
  final EmploymentType employmentType;
  final DatePickerController calendarController;

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
        const SizedBox(height: 20),
        RowTile(label: 'Client Name', text: user.name),
        const SizedBox(height: 20),
        RowTile(label: 'Client Email', text: user.email),
        const SizedBox(height: 20),
        const RowTile(
            label: 'Client Address', text: ''), // TODO: Implement address
        const SizedBox(height: 20),
        RowTile(label: 'Vendor Name', text: widget.detail.vendor.name),
        const SizedBox(height: 20),
        RowTile(label: 'Vendor Email', text: widget.detail.vendor.email),
        const SizedBox(height: 20),
        RowTile(label: 'Rate', text: '₱ ${widget.detail.service.rate}'),
        const SizedBox(height: 20),
        RowTile(
            label: 'Duration',
            text: '${widget.calendarController.days} day(s)'),
        const SizedBox(height: 20),
        RowTile(
            label: 'Start Date',
            text: widget.calendarController.formattedStart),
        const SizedBox(height: 20),
        RowTile(
            label: 'End Date', text: widget.calendarController.formattedEnd),
        const SizedBox(height: 20),
        RowTile(label: 'Employment Type', text: widget.employmentType.value),
        const SizedBox(height: 20),
        RowTile(label: 'Estimated Cost', text: '${computeCost()}'),
        const SizedBox(height: 20),
      ],
    );
  }

  double computeCost() {
    if (widget.employmentType == EmploymentType.pakyaw) {
      return widget.detail.service.rate;
    }

    return widget.detail.service.rate * widget.calendarController.days;
  }
}
