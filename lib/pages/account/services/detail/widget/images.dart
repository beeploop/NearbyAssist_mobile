import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nearby_assist/models/service_image_model.dart';

class Images extends StatefulWidget {
  const Images({super.key, required this.images});

  final List<ServiceImageModel> images;

  @override
  State<Images> createState() => _ImagesState();
}

class _ImagesState extends State<Images> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GridView(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
        ),
        children: [
          ...widget.images.map((image) => _imageWidget(image)),
        ],
      ),
    );
  }

  Widget _imageWidget(ServiceImageModel image) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: CachedNetworkImage(
        imageUrl: image.url,
        fit: BoxFit.cover,
        progressIndicatorBuilder: (context, url, downloadProgress) {
          return CircularProgressIndicator(value: downloadProgress.progress);
        },
        errorWidget: (context, url, error) => const Icon(Icons.error),
      ),
    );
  }
}
