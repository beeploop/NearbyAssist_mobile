import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/pages/account/services/publish_service/widget/service_extra.dart';
import 'package:nearby_assist/pages/account/services/publish_service/widget/service_extra_controller.dart';

class ServicePricing extends StatefulWidget {
  const ServicePricing({
    super.key,
    required this.basePriceController,
    required this.serviceExtras,
  });

  final TextEditingController basePriceController;
  final List<ServiceExtra> serviceExtras;

  @override
  State<ServicePricing> createState() => _ServicePricingState();
}

class _ServicePricingState extends State<ServicePricing> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Pricing',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        _basePriceField(),
        const Divider(),
        TextButton.icon(
          onPressed: _addField,
          icon: const Icon(CupertinoIcons.add_circled),
          label: const Text('Add Extra'),
        ),
        const SizedBox(height: 10),
        ...widget.serviceExtras,
      ],
    );
  }

  Widget _basePriceField() {
    return Row(
      children: [
        const Text('Base Price:'),
        const SizedBox(width: 10),
        Expanded(
          child: TextFormField(
            controller: widget.basePriceController,
            onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  }

  void _addField() {
    logger.log('Adding field');
    setState(() {
      if (widget.serviceExtras.isNotEmpty) {
        final lastField = widget.serviceExtras.last;
        widget.serviceExtras[widget.serviceExtras.length - 1] = ServiceExtra(
          removeable: false,
          onRemoveFn: _removeField,
          controller: lastField.controller,
        );
      }

      final controller = ServiceExtraController();
      widget.serviceExtras.add(ServiceExtra(
        removeable: true,
        onRemoveFn: _removeField,
        controller: controller,
      ));
    });
  }

  void _removeField() {
    logger.log('Removing field');
    setState(() {
      widget.serviceExtras.removeLast();

      if (widget.serviceExtras.isNotEmpty) {
        final lastField = widget.serviceExtras.last;
        widget.serviceExtras[widget.serviceExtras.length - 1] = ServiceExtra(
          removeable: true,
          onRemoveFn: _removeField,
          controller: lastField.controller,
        );
      }
    });
  }
}
