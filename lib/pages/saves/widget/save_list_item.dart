import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nearby_assist/config/service_tag_icon.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/models/service_model.dart';

class SaveListItem extends StatelessWidget {
  const SaveListItem({super.key, required this.service});

  final ServiceModel service;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.green.shade100,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(6),
      child: ListTile(
        onTap: () => context.pushNamed(
          'viewService',
          queryParameters: {'serviceId': service.id},
        ),
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
        title: Text(
          service.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          service.description,
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
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
