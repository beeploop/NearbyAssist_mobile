import 'package:flutter/material.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';

class VendorPhotos extends StatefulWidget {
  const VendorPhotos({super.key, required this.vendorId});

  final String vendorId;

  @override
  State<VendorPhotos> createState() => _VendorPhotos();
}

class _VendorPhotos extends State<VendorPhotos> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Photos',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        SizedBox(
          height: 90,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 6,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: InstaImageViewer(
                  child: Image.asset(
                    'assets/images/avatar.png',
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
