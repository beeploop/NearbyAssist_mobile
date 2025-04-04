import 'package:flutter/material.dart';
import 'package:nearby_assist/models/booking_model.dart';

class BookingStatusChip extends StatelessWidget {
  const BookingStatusChip({super.key, required this.status});

  final BookingStatus status;

  @override
  Widget build(BuildContext context) {
    Color color = _pickColor();

    return Chip(
      label: Text(status.name),
      labelStyle: const TextStyle(
        fontSize: 12,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      visualDensity: VisualDensity.compact,
      padding: const EdgeInsets.all(2),
      backgroundColor: color,
      shape: const RoundedRectangleBorder(
        side: BorderSide(color: Colors.transparent),
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
    );
  }

  Color _pickColor() {
    switch (status) {
      case BookingStatus.pending:
        return Colors.orange;
      case BookingStatus.confirmed:
        return Colors.teal;
      case BookingStatus.done:
        return Colors.green;
      case BookingStatus.rejected:
        return Colors.red;
      case BookingStatus.cancelled:
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }
}
