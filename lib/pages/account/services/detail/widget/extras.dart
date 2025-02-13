import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nearby_assist/models/service_extra_model.dart';
import 'package:nearby_assist/pages/account/services/detail/view_extra_page.dart';
import 'package:nearby_assist/utils/money_formatter.dart';

class Extras extends StatefulWidget {
  const Extras({
    super.key,
    required this.extras,
    required this.onDeleteCb,
    required this.onEditCb,
  });

  final List<ServiceExtraModel> extras;
  final void Function(String id) onDeleteCb;
  final void Function(ServiceExtraModel updated) onEditCb;

  @override
  State<Extras> createState() => _ExtrasState();
}

class _ExtrasState extends State<Extras> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...widget.extras.map((extra) => _serviceExtra(extra)),
          ],
        ),
      ),
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
