import 'package:flutter/material.dart';
import 'package:nearby_assist/models/transaction_model.dart';

class TransactionStatusChip extends StatelessWidget {
  const TransactionStatusChip({super.key, required this.status});

  final TransactionStatus status;

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
      case TransactionStatus.pending:
        return Colors.orange;
      case TransactionStatus.confirmed:
        return Colors.teal;
      case TransactionStatus.done:
        return Colors.green;
      case TransactionStatus.rejected:
        return Colors.red;
      case TransactionStatus.cancelled:
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }
}
