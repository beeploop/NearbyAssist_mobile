import 'package:flutter/material.dart';

class ServiceOverview extends StatefulWidget {
  const ServiceOverview({
    super.key,
    required this.titleController,
    required this.descriptionController,
  });

  final TextEditingController titleController;
  final TextEditingController descriptionController;

  @override
  State<ServiceOverview> createState() => _ServiceOverviewState();
}

class _ServiceOverviewState extends State<ServiceOverview> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Overview',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        _titleField(),
        const SizedBox(height: 10),
        _descriptionField(),
      ],
    );
  }

  Widget _titleField() {
    return Row(
      children: [
        const Text('Title:'),
        const SizedBox(width: 10),
        Expanded(
          child: TextFormField(
            onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _descriptionField() {
    return Row(
      children: [
        const Text('Description:'),
        const SizedBox(width: 10),
        Expanded(
          child: TextFormField(
            onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
            minLines: 2,
            maxLines: 4,
          ),
        ),
      ],
    );
  }
}
