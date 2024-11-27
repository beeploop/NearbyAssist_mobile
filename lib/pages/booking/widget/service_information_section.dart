import 'package:flutter/material.dart';
import 'package:nearby_assist/config/employment_type.dart';
import 'package:nearby_assist/models/detailed_service_model.dart';
import 'package:nearby_assist/pages/booking/widget/date_picker.dart';
import 'package:nearby_assist/pages/booking/widget/date_picker_controller.dart';
import 'package:nearby_assist/pages/booking/widget/row_tile.dart';

class ServiceInformationSection extends StatefulWidget {
  const ServiceInformationSection({
    super.key,
    required this.details,
    required this.calendarController,
    required this.employmentType,
    required this.onEmploymentTypeChange,
  });

  final DetailedServiceModel details;
  final DatePickerController calendarController;
  final EmploymentType? employmentType;
  final void Function(EmploymentType?) onEmploymentTypeChange;

  @override
  State<ServiceInformationSection> createState() =>
      _ServiceInformationSectionState();
}

class _ServiceInformationSectionState extends State<ServiceInformationSection> {
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
        RowTile(label: 'Title', text: widget.details.service.title),
        const SizedBox(height: 20),
        RowTile(label: 'Rate', text: '₱ ${widget.details.service.rate}'),
        const SizedBox(height: 20),
        const Divider(),
        const SizedBox(height: 20),
        const Text(
          'Choose Date',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        DatePicker(controller: widget.calendarController),
        const SizedBox(height: 20),
        ListenableBuilder(
            listenable: widget.calendarController,
            builder: (context, child) {
              return RowTile(
                  label: 'Duration',
                  text: '${widget.calendarController.days} day(s)');
            }),
        const SizedBox(height: 20),
        const Divider(),
        const SizedBox(height: 20),
        const Text(
          'Employment Type',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        RadioListTile<EmploymentType>(
          value: EmploymentType.pakyaw,
          groupValue: widget.employmentType,
          onChanged: widget.onEmploymentTypeChange,
          title: const Text('Pay Per Task (Pakyaw)'),
          dense: true,
        ),
        RadioListTile<EmploymentType>(
          value: EmploymentType.arawan,
          groupValue: widget.employmentType,
          onChanged: widget.onEmploymentTypeChange,
          title: const Text('Pay Per Day (Arawan)'),
          dense: true,
        ),
        const SizedBox(height: 20),
        const Divider(),
        const SizedBox(height: 20),
        ListenableBuilder(
            listenable: widget.calendarController,
            builder: (context, child) {
              final cost = widget.employmentType == EmploymentType.pakyaw
                  ? widget.details.service.rate
                  : widget.details.service.rate *
                      widget.calendarController.days;

              return RowTile(
                  label: 'Estimated Cost', text: '₱ $cost', bold: true);
            }),
      ],
    );
  }
}
