import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nearby_assist/config/service_tag_icon.dart';
import 'package:nearby_assist/models/service_model.dart';

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
        color: Colors.green[100],
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(10),
      child: ListTile(
        onTap: () {
          context.pushNamed(
            "detail",
            queryParameters: {'serviceId': service.id},
          );
        },
        leading: Icon(
          tagIconMap[service.tags[0]],
          size: 26,
          grade: 10,
        ),
        title: Text(
          service.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(service.description),
        trailing: const Icon(CupertinoIcons.arrow_right),
      ),
    );
  }
}
