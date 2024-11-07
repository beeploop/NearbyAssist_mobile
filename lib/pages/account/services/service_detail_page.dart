import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nearby_assist/pages/account/services/widget/detail_tab_section.dart';
import 'package:nearby_assist/pages/account/services/widget/floating_cta.dart';
import 'package:nearby_assist/pages/account/services/widget/image_section.dart';
import 'package:nearby_assist/pages/account/services/widget/service_actions.dart';
import 'package:nearby_assist/pages/account/services/widget/vendor_info_section.dart';
import 'package:nearby_assist/providers/saves_provider.dart';
import 'package:nearby_assist/providers/services_provider.dart';
import 'package:provider/provider.dart';

class ServiceDetailPage extends StatefulWidget {
  const ServiceDetailPage({
    super.key,
    required this.serviceId,
    this.edittable = false,
  });

  final String serviceId;
  final bool edittable;

  @override
  State<ServiceDetailPage> createState() => _ServiceDetailPageState();
}

class _ServiceDetailPageState extends State<ServiceDetailPage> {
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
        actions: [
          if (widget.edittable)
            IconButton(
              icon: const Icon(CupertinoIcons.gear),
              onPressed: () => context.pushNamed(
                'editService',
                queryParameters: {'serviceId': widget.serviceId},
              ),
            ),
          const SizedBox(width: 10),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Stack(
          children: [
            Column(
              children: [
                VendorInfoSection(serviceId: widget.serviceId),
                const SizedBox(height: 10),
                if (!widget.edittable)
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
            if (!widget.edittable)
              FloatingCTA(recipient: vendorId, recipientId: vendorId),
          ],
        ),
      ),
    );
  }
}
