import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nearby_assist/models/service_extra_model.dart';
import 'package:nearby_assist/models/service_model.dart';
import 'package:nearby_assist/pages/account/services/detail/add_extra_page.dart';
import 'package:nearby_assist/pages/account/services/detail/view_extra_page.dart';
import 'package:nearby_assist/providers/managed_service_provider.dart';
import 'package:nearby_assist/utils/money_formatter.dart';
import 'package:provider/provider.dart';

class Extras extends StatefulWidget {
  const Extras({super.key, required this.serviceId});

  final String serviceId;

  @override
  State<Extras> createState() => _ExtrasState();
}

class _ExtrasState extends State<Extras> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ManagedServiceProvider>(
      builder: (context, provider, child) {
        final details = provider.getServiceUnsafe(widget.serviceId);

        return _mainContent(details.service);
      },
    );
  }

  Stack _mainContent(ServiceModel service) {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...service.extras.map((extra) => _serviceExtra(extra)),
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
                  serviceId: service.id,
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
            serviceId: widget.serviceId,
            extra: extra,
          ),
        ),
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
