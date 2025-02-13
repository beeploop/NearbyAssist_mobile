import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nearby_assist/models/detailed_service_model.dart';
import 'package:nearby_assist/models/service_extra_model.dart';
import 'package:nearby_assist/pages/account/services/detail/add_extra_page.dart';
import 'package:nearby_assist/pages/account/services/detail/view_extra_page.dart';
import 'package:nearby_assist/utils/money_formatter.dart';

class Extras extends StatefulWidget {
  const Extras({
    super.key,
    required this.service,
    required this.onDeleteCb,
    required this.onEditCb,
  });

  final DetailedServiceModel service;
  final void Function(String id) onDeleteCb;
  final void Function(ServiceExtraModel updated) onEditCb;

  @override
  State<Extras> createState() => _ExtrasState();
}

class _ExtrasState extends State<Extras> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...widget.service.service.extras
                    .map((extra) => _serviceExtra(extra)),
                const SizedBox(height: 70),
              ],
            ),
          ),
        ),

        //
        Positioned(
          bottom: 20,
          left: 20,
          right: 20,
          child: FilledButton(
            style: const ButtonStyle(
              minimumSize: WidgetStatePropertyAll(Size.fromHeight(50)),
            ),
            onPressed: () => Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => AddExtraPage(
                  serviceId: widget.service.service.id,
                ),
              ),
            ),
            child: const Text('Add Extra'),
          ),
        ),
      ],
    );
  }

  Widget _serviceExtra(ServiceExtraModel extra) {
    return ListTile(
      onTap: () => Navigator.push(
        context,
        CupertinoPageRoute(
            builder: (context) => ViewExtraPage(
                  extra: extra,
                  onDeleteCb: widget.onDeleteCb,
                  onEditCb: widget.onEditCb,
                )),
      ),
      leading: const Icon(CupertinoIcons.tags, color: Colors.green),
      title: Text(
        extra.title,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        extra.description,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Text(
        formatCurrency(extra.price),
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
