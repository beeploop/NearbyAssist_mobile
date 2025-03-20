import 'package:flutter/material.dart';
import 'package:nearby_assist/models/service_model.dart';
import 'package:nearby_assist/pages/account/services/detail/widget/extras.dart';
import 'package:nearby_assist/pages/account/services/detail/widget/images.dart';
import 'package:nearby_assist/pages/account/services/detail/widget/overview.dart';

class ServiceDetailPage extends StatefulWidget {
  const ServiceDetailPage({
    super.key,
    required this.service,
  });

  final ServiceModel service;

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
      body: DefaultTabController(
        initialIndex: 0,
        length: 3,
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
              ],
            ),
            const SizedBox(height: 10),
            Flexible(
              child: TabBarView(
                children: [
                  Overview(service: widget.service),
                  Images(service: widget.service),
                  Extras(service: widget.service),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
