import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nearby_assist/utils/custom_snackbar.dart';

class ServiceActions extends StatelessWidget {
  const ServiceActions({
    super.key,
    required this.serviceId,
    this.saved = false,
  });

  final String serviceId;
  final bool saved;

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
              onPressed: () => _save(context),
              icon: Icon(
                saved ? CupertinoIcons.bookmark_fill : CupertinoIcons.bookmark,
              ),
              label: const Text('Save'),
            ),
          ),
        ],
      ),
    );
  }

  void _viewMap(BuildContext context) {
    context.pushNamed(
      'route',
      queryParameters: {'serviceId': serviceId},
    );
  }

  void _save(BuildContext context) {
    showCustomSnackBar(context, 'Saved service');
  }
}
