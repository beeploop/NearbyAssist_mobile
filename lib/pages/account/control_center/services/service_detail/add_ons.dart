import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nearby_assist/models/service_extra_model.dart';
import 'package:nearby_assist/pages/account/control_center/services/new_add_on/new_addon_page.dart';
import 'package:nearby_assist/pages/account/control_center/services/edit_add_on/edit_add_on_page.dart';
import 'package:nearby_assist/providers/control_center_provider.dart';
import 'package:nearby_assist/providers/user_provider.dart';
import 'package:nearby_assist/utils/money_formatter.dart';
import 'package:nearby_assist/utils/show_generic_error_modal.dart';
import 'package:nearby_assist/utils/show_restricted_account_modal.dart';
import 'package:provider/provider.dart';

class AddOns extends StatefulWidget {
  const AddOns({super.key, required this.serviceId});

  final String serviceId;

  @override
  State<AddOns> createState() => _AddOnsState();
}

class _AddOnsState extends State<AddOns> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ControlCenterProvider>(
      builder: (context, provider, _) {
        final service = provider.services
            .firstWhere((service) => service.id == widget.serviceId);

        return Scaffold(
          appBar: AppBar(),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:
                  service.extras.map((extra) => _serviceAddOn(extra)).toList(),
            ),
          ),
          bottomNavigationBar: Consumer2<UserProvider, ControlCenterProvider>(
            builder: (context, userProvider, ccProvider, _) {
              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: FilledButton(
                  onPressed: () async {
                    if (userProvider.user.isRestricted) {
                      showAccountRestrictedModal(context);
                      return;
                    }

                    if (service.disabled) {
                      showGenericErrorModal(
                        context,
                        message: 'Service is disabled',
                      );
                      return;
                    }

                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) =>
                            NewAddOnPage(serviceId: service.id),
                      ),
                    );
                  },
                  style: ButtonStyle(
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    minimumSize:
                        const WidgetStatePropertyAll(Size.fromHeight(50)),
                  ),
                  child: const Text('New add-on'),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _serviceAddOn(ServiceExtraModel extra) {
    return ListTile(
      onTap: () => Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) => EditAddOnPage(
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
