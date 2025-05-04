import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nearby_assist/pages/account/control_center/services/edit_service/edit_service_page.dart';
import 'package:nearby_assist/providers/control_center_provider.dart';
import 'package:nearby_assist/providers/user_provider.dart';
import 'package:nearby_assist/utils/money_formatter.dart';
import 'package:nearby_assist/utils/show_generic_error_modal.dart';
import 'package:nearby_assist/utils/show_restricted_account_modal.dart';
import 'package:provider/provider.dart';

class Overview extends StatefulWidget {
  const Overview({super.key, required this.serviceId});

  final String serviceId;

  @override
  State<Overview> createState() => _OverviewState();
}

class _OverviewState extends State<Overview> {
  @override
  Widget build(BuildContext context) {
    return Consumer2<UserProvider, ControlCenterProvider>(
      builder: (context, userProvider, ccProvider, _) {
        final service = ccProvider.services
            .firstWhere((service) => service.id == widget.serviceId);

        return Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  _label('Title'),
                  Text(service.title),
                  const SizedBox(height: 20),

                  // Description
                  _label('Description'),
                  Text(service.description),
                  const SizedBox(height: 20),

                  // Rate
                  _label('Rate'),
                  Text(
                    formatCurrency(service.rate),
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 20),

                  // Tags
                  _label('Tags'),
                  Wrap(
                    spacing: 4,
                    runSpacing: 4,
                    children:
                        service.tags.map((tag) => _tagChip(tag.title)).toList(),
                  ),

                  // Bottom padding
                  const SizedBox(height: 20),
                ],
              ),
            ),

            // Edit Button
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
                      builder: (context) => EditServicePage(service: service),
                    ),
                  );
                },
                child: const Text('Update'),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _label(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _tagChip(String label) {
    return Chip(
      label: Text(label),
      labelStyle: const TextStyle(
        fontSize: 12,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      backgroundColor: Colors.green.shade600,
      visualDensity: VisualDensity.compact,
      padding: const EdgeInsets.all(2),
      shape: const RoundedRectangleBorder(
        side: BorderSide(color: Colors.transparent),
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
    );
  }
}
