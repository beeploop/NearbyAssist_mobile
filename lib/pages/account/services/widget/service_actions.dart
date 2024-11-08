import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
    throw UnimplementedError();
  }

  void _unsave() {
    throw UnimplementedError();
  }
}
