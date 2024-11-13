import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nearby_assist/models/detailed_service_model.dart';
import 'package:nearby_assist/providers/saves_provider.dart';
import 'package:provider/provider.dart';

class ServiceActions extends StatefulWidget {
  const ServiceActions({
    super.key,
    required this.service,
  });

  final DetailedServiceModel service;

  @override
  State<ServiceActions> createState() => _ServiceActionsState();
}

class _ServiceActionsState extends State<ServiceActions> {
  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          Expanded(
            child: TextButton.icon(
              onPressed: () => _viewMap(context),
              icon: const Icon(CupertinoIcons.arrow_up_right_diamond),
              label: const Text('View route'),
            ),
          ),
          const VerticalDivider(),
          Consumer<SavesProvider>(
            builder: (context, saves, child) {
              return Expanded(
                child: TextButton.icon(
                  onPressed: saves.isSaved(widget.service.service.id)
                      ? () => saves.unsave(widget.service.service.id)
                      : () => saves.save(widget.service),
                  icon: Icon(
                    saves.isSaved(widget.service.service.id)
                        ? CupertinoIcons.bookmark_fill
                        : CupertinoIcons.bookmark,
                  ),
                  label: Text(saves.isSaved(widget.service.service.id)
                      ? 'Saved'
                      : 'Save'),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _viewMap(BuildContext context) {
    context.pushNamed(
      'route',
      queryParameters: {'serviceId': widget.service.service.id},
    );
  }
}
