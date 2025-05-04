import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:nearby_assist/models/service_model.dart';
import 'package:nearby_assist/pages/account/control_center/services/service_detail/add_ons.dart';
import 'package:nearby_assist/pages/account/control_center/services/service_detail/images.dart';
import 'package:nearby_assist/pages/account/control_center/services/service_detail/overview.dart';
import 'package:nearby_assist/pages/account/control_center/services/service_detail/reviews.dart';
import 'package:nearby_assist/pages/account/control_center/services/service_detail/widget/menu.dart';

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
    return LoaderOverlay(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Detail',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          actions: [
            Icon(
              CupertinoIcons.circle_fill,
              color: widget.service.disabled ? Colors.red : Colors.green,
              size: 10,
            ),
            Menu(service: widget.service),
          ],
        ),
        body: DefaultTabController(
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
                  Tab(child: Text('Reviews')),
                ],
              ),
              const SizedBox(height: 10),
              Flexible(
                child: TabBarView(
                  children: [
                    Overview(serviceId: widget.service.id),
                    Images(serviceId: widget.service.id),
                    AddOns(serviceId: widget.service.id),
                    Reviews(serviceId: widget.service.id),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
