import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nearby_assist/config/service_tag_icon.dart';
import 'package:nearby_assist/models/service_model.dart';
import 'package:nearby_assist/pages/account/services/detail/service_detail_page.dart';

class ServiceItem extends StatelessWidget {
  const ServiceItem({
    super.key,
    this.paddingBottom = false,
    required this.service,
  });

  final bool paddingBottom;
  final ServiceModel service;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.green.shade100,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(10),
      child: ListTile(
        onTap: () {
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => ServiceDetailPage(service: service),
            ),
          );
        },
        leading: Icon(
          _icon(service.tags.first.title),
          size: 26,
          grade: 10,
        ),
        title: Text(
          service.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          service.description,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: const Icon(CupertinoIcons.arrow_right),
      ),
    );
  }

  IconData _icon(String key) {
    if (!tagIconMap.containsKey(key)) {
      return CupertinoIcons.wrench;
    }

    return tagIconMap[key]!;
  }
}
