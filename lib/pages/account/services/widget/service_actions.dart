import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nearby_assist/models/service_model.dart';
import 'package:nearby_assist/providers/saves_provider.dart';
import 'package:nearby_assist/providers/search_provider.dart';
import 'package:nearby_assist/utils/custom_snackbar.dart';
import 'package:provider/provider.dart';

class ServiceActions extends StatefulWidget {
  const ServiceActions({
    super.key,
    required this.serviceId,
    this.saved = false,
  });

  final String serviceId;
  final bool saved;

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
          Expanded(
            child: TextButton.icon(
              onPressed: widget.saved ? _unsave : _save,
              icon: Icon(
                widget.saved
                    ? CupertinoIcons.bookmark_fill
                    : CupertinoIcons.bookmark,
              ),
              label: Text(widget.saved ? 'Saved' : 'Save'),
            ),
          ),
        ],
      ),
    );
  }

  void _viewMap(BuildContext context) {
    context.pushNamed(
      'route',
      queryParameters: {'serviceId': widget.serviceId},
    );
  }

  void _save() {
    final result = context.read<SearchProvider>().getById(widget.serviceId);
    final service = ServiceModel(
      id: result.id,
      description: '',
      latitude: result.latitude,
      longitude: result.longitude,
      vendor: result.vendor,
    );
    context.read<SavesProvider>().save(service);

    showCustomSnackBar(context, 'Saved service');
  }

  void _unsave() {
    final result = context.read<SearchProvider>().getById(widget.serviceId);
    final service = ServiceModel(
      id: result.id,
      description: '',
      latitude: result.latitude,
      longitude: result.longitude,
      vendor: result.vendor,
    );
    context.read<SavesProvider>().unsave(service);

    showCustomSnackBar(context, 'Removed save');
  }
}
