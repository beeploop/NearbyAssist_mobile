import 'package:flutter/material.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/model/service_image_model.dart';
import 'package:nearby_assist/model/settings_model.dart';

class VendorPhotos extends StatefulWidget {
  const VendorPhotos({super.key, required this.photos});

  final List<ServiceImageModel> photos;

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
        widget.photos.isEmpty
            ? const SizedBox(
                height: 90,
                child: Center(
                  child: Text('No photos available'),
                ),
              )
            : SizedBox(
                height: 90,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.photos.length,
                  itemBuilder: (context, index) {
                    final addr = getIt.get<SettingsModel>().getServerAddr();

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: InstaImageViewer(
                        child: Image.network(
                          '$addr/resource/${widget.photos[index].url}',
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            }
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Center(
                              child: Image.asset('assets/images/avatar.png'),
                            );
                          },
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
