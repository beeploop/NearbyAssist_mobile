import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nearby_assist/pages/account/control_center/services/publish_service/widget/service_extra_controller.dart';

class ServiceExtra extends StatefulWidget {
  const ServiceExtra({
    super.key,
    required this.removeable,
    required this.onRemoveFn,
    required this.controller,
  });

  final bool removeable;
  final void Function() onRemoveFn;
  final ServiceExtraController controller;

  @override
  State<ServiceExtra> createState() => _ServiceExtraState();
}

class _ServiceExtraState extends State<ServiceExtra> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade300),
        ),
        padding:
            const EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (widget.removeable)
              IconButton(
                onPressed: () => widget.onRemoveFn(),
                icon: const Icon(CupertinoIcons.xmark_circle_fill),
              ),
            _titleField(),
            const SizedBox(height: 10),
            _priceField(),
            const SizedBox(height: 10),
            _descriptionField(),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _titleField() {
    return Row(
      children: [
        const Text('Title'),
        const SizedBox(width: 10),
        Expanded(
          child: TextField(
            onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
            controller: widget.controller.titleController,
            decoration: const InputDecoration(border: OutlineInputBorder()),
          ),
        ),
      ],
    );
  }

  Widget _priceField() {
    return Row(
      children: [
        const Text('Price'),
        const SizedBox(width: 10),
        Expanded(
          child: TextField(
            onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
            controller: widget.controller.priceController,
            decoration: const InputDecoration(border: OutlineInputBorder()),
            keyboardType: TextInputType.number,
          ),
        ),
      ],
    );
  }

  Widget _descriptionField() {
    return Row(
      children: [
        const Text('Description'),
        const SizedBox(width: 10),
        Expanded(
          child: TextField(
            onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
            controller: widget.controller.descriptionController,
            decoration: const InputDecoration(border: OutlineInputBorder()),
            minLines: 2,
            maxLines: 4,
          ),
        ),
      ],
    );
  }
}
