import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nearby_assist/models/detailed_service_model.dart';
import 'package:nearby_assist/pages/account/services/detail/widget/extras.dart';
import 'package:nearby_assist/pages/account/services/detail/widget/images.dart';
import 'package:nearby_assist/pages/account/services/detail/widget/overview.dart';
import 'package:nearby_assist/pages/account/services/detail/widget/rating.dart';
import 'package:nearby_assist/providers/managed_service_provider.dart';
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
      ),
      body: FutureBuilder(
        future:
            context.read<ManagedServiceProvider>().getService(widget.serviceId),
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

          final data = snapshot.data!;
          return _content(data);
        },
      ),
    );
  }

  Widget _content(DetailedServiceModel detail) {
    return DefaultTabController(
      initialIndex: 0,
      length: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TabBar(
            unselectedLabelColor: Colors.grey,
            overlayColor: WidgetStatePropertyAll(Colors.transparent),
            dividerColor: Colors.transparent,
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorPadding: EdgeInsets.all(10),
            tabs: [
              Tab(child: Text('Overview')),
              Tab(child: Text('Images')),
              Tab(child: Text('Add-ons')),
              Tab(child: Text('Rating')),
            ],
          ),
          Flexible(
            child: TabBarView(
              children: [
                Overview(serviceId: detail.service.id),
                Images(serviceId: detail.service.id),
                Extras(serviceId: detail.service.id),
                Rating(rating: detail.ratingCount),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
