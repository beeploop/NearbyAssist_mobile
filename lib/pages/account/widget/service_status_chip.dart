import 'package:flutter/material.dart';
import 'package:nearby_assist/models/service_model.dart';

class ServiceStatusChip extends StatelessWidget {
  const ServiceStatusChip({super.key, required this.status});

  final ServiceStatus status;

  @override
  Widget build(BuildContext context) {
    Color color = _pickColor();

    return Chip(
      label: Text(status.title),
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
      case ServiceStatus.underReview:
        return Colors.amber.shade800;
      case ServiceStatus.accepted:
        return Colors.green.shade800;
      case ServiceStatus.rejected:
        return Colors.red.shade800;
    }
  }
}
