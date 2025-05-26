import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nearby_assist/config/service_tag_icon.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/models/service_model.dart';
import 'package:nearby_assist/pages/account/control_center/services/service_detail/service_detail_page.dart';
import 'package:nearby_assist/pages/account/widget/service_status_chip.dart';

class ServiceItem extends StatelessWidget {
  const ServiceItem({
    super.key,
    required this.service,
  });

  final ServiceModel service;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: service.disabled ? Colors.green.shade50 : Colors.green.shade100,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        onTap: () {
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => ServiceDetailPage(service: service),
            ),
          );
        },
        leading: service.images.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: '${endpoint.publicResource}/${service.images[0].url}',
                fit: BoxFit.fitHeight,
                progressIndicatorBuilder: (context, url, downloadProgress) {
                  return CircularProgressIndicator(
                      value: downloadProgress.progress);
                },
                errorWidget: (context, url, error) => const Icon(
                  CupertinoIcons.photo,
                ),
              )
            : Icon(
                _icon(service.tags.first),
                size: 26,
                grade: 10,
              ),
        titleAlignment: ListTileTitleAlignment.top,
        title: Text(
          service.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          service.description,
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
        ),
        trailing: ServiceStatusChip(status: service.status),
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
