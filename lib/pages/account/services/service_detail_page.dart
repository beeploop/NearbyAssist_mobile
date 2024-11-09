import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
//import 'package:nearby_assist/pages/account/services/widget/detail_tab_section.dart';
import 'package:nearby_assist/pages/account/services/widget/image_section.dart';
import 'package:nearby_assist/pages/account/services/widget/vendor_info_section.dart';
import 'package:nearby_assist/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class ServiceDetailPage extends StatefulWidget {
  const ServiceDetailPage({
    super.key,
    required this.serviceId,
  });

  final String serviceId;

  @override
  State<ServiceDetailPage> createState() => _ServiceDetailPageState();
}

class _ServiceDetailPageState extends State<ServiceDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detail',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
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
                Consumer<AuthProvider>(
                  builder: (context, auth, child) {
                    return VendorInfoSection(name: auth.user.name, rating: 0);
                  },
                ),
                const SizedBox(height: 10),
                const SizedBox(height: 10),
                const ImageSection(),
                const SizedBox(height: 10),
                //const DetailTabSection(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
