import 'package:flutter/material.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/model/service_image_model.dart';
import 'package:nearby_assist/model/settings_model.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
                    final photo = widget.photos[index];

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: InstaImageViewer(
                        child: CachedNetworkImage(
                          imageUrl: photo.url.startsWith("http")
                              ? photo.url
                              : '$addr/resource/${photo.url}',
                          progressIndicatorBuilder: (_, url, download) {
                            if (download.progress != null) {
                              final percent = download.progress! * 100;
                              return Text('$percent% done loading');
                            }

                            return Text('Loaded $url');
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
