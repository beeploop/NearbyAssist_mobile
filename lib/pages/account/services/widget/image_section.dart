import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/models/service_image_model.dart';

class ImageSection extends StatelessWidget {
  const ImageSection({super.key, required this.images});

  final List<ServiceImageModel> images;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.width * 0.8;

    return SizedBox(
      height: height,
      child: ListView.separated(
        shrinkWrap: true,
        separatorBuilder: (context, _) => const SizedBox(width: 10),
        scrollDirection: Axis.horizontal,
        itemCount: images.length,
        itemBuilder: (context, idx) => Container(
          width: height,
          height: height,
          decoration: BoxDecoration(
            border: Border.all(),
          ),
          child: CachedNetworkImage(
            imageUrl: '${endpoint.resource}/${images[idx].url}',
            fit: BoxFit.cover,
            progressIndicatorBuilder: (context, url, downloadProgress) {
              return Padding(
                padding: const EdgeInsets.all(8),
                child: CircularProgressIndicator(
                  value: downloadProgress.progress,
                ),
              );
            },
            errorWidget: (context, url, error) => const Icon(
              CupertinoIcons.photo,
            ),
          ),
        ),
      ),
    );
  }
}
