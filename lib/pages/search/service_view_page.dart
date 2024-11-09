import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nearby_assist/pages/account/services/widget/detail_tab_section.dart';
import 'package:nearby_assist/pages/account/services/widget/floating_cta.dart';
import 'package:nearby_assist/pages/account/services/widget/image_section.dart';
import 'package:nearby_assist/pages/account/services/widget/service_actions.dart';
import 'package:nearby_assist/pages/account/services/widget/vendor_info_section.dart';
import 'package:nearby_assist/providers/search_provider.dart';
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
    final detailsProvider = Provider.of<SearchProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detail',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: detailsProvider.hasDetails(widget.serviceId)
          ? _showContent(detailsProvider.getDetails(widget.serviceId))
          : FutureBuilder(
              future: detailsProvider.fetchDetails(widget.serviceId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasError) {
                  return const Center(
                    child: AlertDialog(
                      icon: Icon(CupertinoIcons.exclamationmark_triangle),
                      title: Text('Something went wrong'),
                      content: Text(
                        'An error occurred while fetching te details of this service. Please try again later.',
                      ),
                    ),
                  );
                }

                final details = snapshot.data!;
                return _showContent(details);
              },
            ),
    );
  }

  Widget _showContent(DetailedServiceModel details) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Stack(
        children: [
          Column(
            children: [
              VendorInfoSection(
                name: details.vendor.name,
                rating: details.vendor.rating,
              ),
              const SizedBox(height: 10),
              ServiceActions(
                serviceId: widget.serviceId,
                saved: false,
              ),
              const SizedBox(height: 10),
              const ImageSection(),
              const SizedBox(height: 10),
              DetailTabSection(
                service: details.service,
                rating: details.ratingCount,
              ),
            ],
          ),
          FloatingCTA(
              recipient: details.vendor.name, recipientId: details.vendor.id),
        ],
      ),
    );
  }
}
