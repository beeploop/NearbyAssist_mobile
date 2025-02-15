import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nearby_assist/models/detailed_service_model.dart';
import 'package:nearby_assist/models/service_extra_model.dart';
import 'package:nearby_assist/pages/account/services/widget/floating_cta.dart';
import 'package:nearby_assist/pages/account/services/widget/image_section.dart';
import 'package:nearby_assist/pages/account/services/widget/rating_count_bar.dart';
import 'package:nearby_assist/pages/account/services/widget/service_actions.dart';
import 'package:nearby_assist/pages/account/services/widget/vendor_info_section.dart';
import 'package:nearby_assist/providers/service_provider.dart';
import 'package:nearby_assist/utils/money_formatter.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detail',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: FutureBuilder(
        future: context.read<ServiceProvider>().getService(widget.serviceId),
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
                  'An error occurred while fetching the details of this service. Please try again later.',
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
    return Stack(
      children: [
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ImageSection(images: details.images),
                const SizedBox(height: 10),

                // Vendor info
                VendorInfoSection(
                  vendor: details.vendor,
                ),
                const SizedBox(height: 20),

                // Actions
                ServiceActions(service: details),
                const SizedBox(height: 20),

                // Extras
                const Divider(),
                ListTile(
                  onTap: () => _viewExtras(details.service.extras),
                  title: const Text('Add-ons'),
                  trailing: const Icon(CupertinoIcons.chevron_right, size: 20),
                ),
                const SizedBox(height: 10),

                // Details
                const Text(
                  'Description',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(details.service.description),
                const SizedBox(height: 20),

                // Rating
                Text(
                  'Total Reviews: ${details.ratingCount.total()}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  height: 160,
                  child: RatingCountBar(rating: details.ratingCount),
                ),
                const SizedBox(height: 20),

                // Divider
                const Divider(),
                const SizedBox(height: 20),

                // Bottom padding
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),

        // Action Button
        FloatingCTA(details: details),
      ],
    );
  }

  void _viewExtras(List<ServiceExtraModel> extras) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.60,
        width: double.infinity,
        child: Container(
          padding: const EdgeInsets.all(10),
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: extras.length,
            separatorBuilder: (context, _) => const Divider(),
            itemBuilder: (context, idx) {
              return ListTile(
                leading: Icon(
                  CupertinoIcons.tags_solid,
                  color: Colors.green.shade900,
                ),
                title: Text(
                  extras[idx].title,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  extras[idx].description,
                ),
                trailing: Text(
                  formatCurrency(extras[idx].price),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
