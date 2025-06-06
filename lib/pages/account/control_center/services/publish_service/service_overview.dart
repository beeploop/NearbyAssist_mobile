import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:nearby_assist/config/theme/app_colors.dart';

class ServiceOverview extends StatefulWidget {
  const ServiceOverview({
    super.key,
    required this.titleController,
    required this.descriptionController,
    required this.tagsController,
  });

  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final TextEditingController tagsController;

  @override
  State<ServiceOverview> createState() => _ServiceOverviewState();
}

class _ServiceOverviewState extends State<ServiceOverview> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AutoSizeText(
          'Overview',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),

        // Title
        const AutoSizeText('Title'),
        const SizedBox(height: 10),
        TextFormField(
          maxLength: 50,
          controller: widget.titleController,
          onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            hintText: 'Name of your service',
            hintStyle: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: AppColors.grey),
          ),
        ),
        const SizedBox(height: 20),

        // Description
        const AutoSizeText('Description'),
        const SizedBox(height: 10),
        TextFormField(
          controller: widget.descriptionController,
          onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            hintText:
                'Describe your service and provide details the client should know.',
            hintStyle: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: AppColors.grey),
          ),
          minLines: 3,
          maxLines: 6,
        ),
        const SizedBox(height: 20),

        // Tags
        const AutoSizeText('Tags'),
        const SizedBox(height: 8),
        AutoSizeText(
          'Searchable keywords to help users discover your service.',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        AutoSizeText(
          'For multiple tags, separate each one with comma (,)',
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: widget.tagsController,
          onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            hintText: 'ex. plumbing service, plumber, water leakage repair',
            hintStyle: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: AppColors.grey),
          ),
        ),

        // Bottom padding
        const SizedBox(height: 20),
      ],
    );
  }
}
