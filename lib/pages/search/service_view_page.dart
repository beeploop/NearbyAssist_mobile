import 'package:flutter/material.dart';
import 'package:nearby_assist/pages/account/services/widget/detail_tab_section.dart';
import 'package:nearby_assist/pages/account/services/widget/floating_cta.dart';
import 'package:nearby_assist/pages/account/services/widget/image_section.dart';
import 'package:nearby_assist/pages/account/services/widget/service_actions.dart';
import 'package:nearby_assist/pages/account/services/widget/vendor_info_section.dart';

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
                ServiceActions(
                  serviceId: widget.serviceId,
                  saved: false,
                ),
                const SizedBox(height: 10),
                const ImageSection(),
                const SizedBox(height: 10),
                const DetailTabSection(),
              ],
            ),
            const FloatingCTA(recipient: '', recipientId: ''),
          ],
        ),
      ),
    );
  }
}
