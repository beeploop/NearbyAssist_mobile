import 'package:flutter/material.dart';
import 'package:nearby_assist/models/service_model.dart';

class Overview extends StatelessWidget {
  const Overview({super.key, required this.service});

  final ServiceModel service;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            _label('Title'),
            Text(service.title),
            const SizedBox(height: 20),

            // Description
            _label('Description'),
            Text(service.description),
            const SizedBox(height: 20),

            // Rate
            _label('Rate'),
            Text(
              '₱ ${service.rate}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),

            // Tags
            _label('Tags'),
            Wrap(
              spacing: 4,
              runSpacing: 4,
              children: [
                ...service.tags.map((tag) => _chip(tag)),
              ],
            ),

            // Bottom padding
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _label(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _chip(String label) {
    return Chip(
      label: Text(label),
      labelStyle: const TextStyle(
        fontSize: 12,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      backgroundColor: Colors.green.shade600,
      visualDensity: VisualDensity.compact,
      padding: const EdgeInsets.all(2),
      shape: const RoundedRectangleBorder(
        side: BorderSide(color: Colors.transparent),
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
    );
  }
}
