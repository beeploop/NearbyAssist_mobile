import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nearby_assist/models/service_extra_model.dart';
import 'package:nearby_assist/pages/account/services/detail/add_extra_page.dart';
import 'package:nearby_assist/pages/account/services/detail/view_extra_page.dart';
import 'package:nearby_assist/providers/control_center_provider.dart';
import 'package:nearby_assist/providers/user_provider.dart';
import 'package:nearby_assist/utils/money_formatter.dart';
import 'package:nearby_assist/utils/show_restricted_account_modal.dart';
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
    return Consumer2<UserProvider, ControlCenterProvider>(
      builder: (context, userProvider, ccProvider, child) {
        final service = ccProvider.services
            .firstWhere((service) => service.id == widget.serviceId);

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
                onPressed: () {
                  if (userProvider.user.isRestricted) {
                    showAccountRestrictedModal(context);
                    return;
                  }

                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => AddExtraPage(
                        serviceId: service.id,
                      ),
                    ),
                  );
                },
                child: const Text('New add-on'),
              ),
            ),
          ],
        );
      },
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
      titleAlignment: ListTileTitleAlignment.top,
      leading: Icon(CupertinoIcons.tags_solid, color: Colors.green.shade900),
      title: Text(extra.title, overflow: TextOverflow.ellipsis),
      subtitle: Text(
        extra.description,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Text(
        formatCurrency(extra.price),
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}
