import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nearby_assist/models/service_extra_model.dart';
import 'package:nearby_assist/utils/money_formatter.dart';

class Extras extends StatelessWidget {
  const Extras({super.key, required this.extras});

  final List<ServiceExtraModel> extras;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...extras.map((extra) => _serviceExtra(extra)),
          ],
        ),
      ),
    );
  }

  Widget _serviceExtra(ServiceExtraModel extra) {
    return ListTile(
      leading: const Icon(CupertinoIcons.tags, color: Colors.green),
      title: Text(
        extra.title,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        formatCurrency(extra.price),
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      trailing: PopupMenuButton(
        itemBuilder: (context) => [
          const PopupMenuItem(
            value: 'delete',
            child: Text('delete'),
          ),
        ],
        onSelected: (value) {
          //
        },
      ),
    );
  }
}
