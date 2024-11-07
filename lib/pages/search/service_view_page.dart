import 'package:flutter/material.dart';
import 'package:nearby_assist/pages/account/services/widget/detail_tab_section.dart';
import 'package:nearby_assist/pages/account/services/widget/floating_cta.dart';
import 'package:nearby_assist/pages/account/services/widget/image_section.dart';
import 'package:nearby_assist/pages/account/services/widget/service_actions.dart';
import 'package:nearby_assist/pages/account/services/widget/vendor_info_section.dart';
import 'package:nearby_assist/providers/saves_provider.dart';
import 'package:nearby_assist/providers/services_provider.dart';
import 'package:provider/provider.dart';

class ServiceViewPage extends StatefulWidget {
  const ServiceViewPage({
    super.key,
    required this.serviceId,
  });

  final String serviceId;

  @override
  State<ServiceViewPage> createState() => _ServiceViewPageState();
}

class _ServiceViewPageState extends State<ServiceViewPage> {
  @override
  Widget build(BuildContext context) {
    final vendorId =
        context.watch<ServicesProvider>().getById(widget.serviceId).vendor;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detail',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Stack(
          children: [
            Column(
              children: [
                const VendorInfoSection(name: 'vendor name', rating: 0),
                const SizedBox(height: 10),
                Consumer<SavesProvider>(
                  builder: (context, saves, child) => ServiceActions(
                    serviceId: widget.serviceId,
                    saved: saves.includes(widget.serviceId),
                  ),
                ),
                const SizedBox(height: 10),
                const ImageSection(),
                const SizedBox(height: 10),
                const DetailTabSection(),
              ],
            ),
            FloatingCTA(recipient: vendorId, recipientId: vendorId),
          ],
        ),
      ),
    );
  }
}
