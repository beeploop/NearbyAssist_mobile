import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nearby_assist/models/service_image_model.dart';

class Images extends StatelessWidget {
  const Images({super.key, required this.images});

  final List<ServiceImageModel> images;

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
          ...images.map(
            (image) => Container(
              decoration: BoxDecoration(
                color: Colors.green.shade200,
                border: Border.all(color: Colors.green.shade800),
              ),
              child: CachedNetworkImage(imageUrl: image.url, fit: BoxFit.cover),
            ),
          ),
        ],
      ),
    );
  }
}
