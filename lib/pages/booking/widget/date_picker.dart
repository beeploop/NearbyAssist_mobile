import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nearby_assist/pages/booking/widget/date_picker_controller.dart';
import 'package:nearby_assist/pages/booking/widget/input_field.dart';

class DatePicker extends StatefulWidget {
  const DatePicker({super.key, required this.controller});

  final DatePickerController controller;

  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: InputField(
            readOnly: true,
            controller: widget.controller.controller,
            hintText: 'Select Date Range',
            labelText: 'mm/dd/yyyy',
          ),
        ),
        IconButton(
          onPressed: _showDatePicker,
          icon: const Icon(CupertinoIcons.calendar_today, color: Colors.green),
        ),
      ],
    );
  }

  void _showDatePicker() async {
    final range = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );

    if (range == null) return;

    setState(() {
      widget.controller.setRange(range);
    });
  }
}
