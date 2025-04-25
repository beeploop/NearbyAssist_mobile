import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:nearby_assist/config/service_tag_icon.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/models/detailed_vendor_model.dart';
import 'package:nearby_assist/models/service_model.dart';
import 'package:nearby_assist/models/vendor_model.dart';
import 'package:nearby_assist/pages/vendor/widget/menu.dart';
import 'package:nearby_assist/providers/vendor_provider.dart';
import 'package:nearby_assist/utils/url_icon_generator.dart';
import 'package:provider/provider.dart';

class VendorPage extends StatefulWidget {
  const VendorPage({super.key, required this.vendorId});

  final String vendorId;

  @override
  State<VendorPage> createState() => _VendorPageState();
}

class _VendorPageState extends State<VendorPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Vendor',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          Menu(vendorId: widget.vendorId),
          const SizedBox(width: 10),
        ],
      ),
      body: FutureBuilder(
        future: context.read<VendorProvider>().getVendor(widget.vendorId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return const Center(
              child: AlertDialog(
                icon: Icon(CupertinoIcons.exclamationmark_triangle),
                title: Text('Something went wrong'),
                content: Text(
                  'An error occurred while fetching data of this vendor. Please try again later',
                ),
              ),
            );
          }

          final model = snapshot.data!;
          return _content(model);
        },
      ),
    );
  }

  Widget _content(DetailedVendorModel model) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Vendor info
          _header(model.vendor),
          const SizedBox(height: 10),

          // Contacts
          const AutoSizeText(
            'Contact',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),

          // Mail
          Row(
            children: [
              const Icon(CupertinoIcons.mail, size: 20),
              const SizedBox(width: 10),
              AutoSizeText(
                model.vendor.email,
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Phone
          Row(
            children: [
              const Icon(CupertinoIcons.phone, size: 20),
              const SizedBox(width: 10),
              AutoSizeText(
                model.vendor.phone,
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Socials
          const AutoSizeText(
            'Socials',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),

          ...model.vendor.socials.map((social) => Row(
                children: [
                  Icon(iconFromURL(social), size: 20),
                  const SizedBox(width: 10),
                  AutoSizeText(
                    social,
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              )),

          // Divider
          const Divider(),
          const SizedBox(height: 10),

          // More services
          const AutoSizeText(
            'More Services',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          _moreServices(model.services),
        ],
      ),
    );
  }

  Widget _header(VendorModel vendor) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.green.shade200,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          SizedBox(
            height: 80,
            width: 80,
            child: Image.network(vendor.imageUrl),
          ),
          const SizedBox(width: 10),
          SizedBox(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AutoSizeText(
                  vendor.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                RatingBar.builder(
                  initialRating: vendor.rating,
                  allowHalfRating: true,
                  itemSize: 20,
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: Colors.yellow,
                  ),
                  onRatingUpdate: (_) {},
                  ignoreGestures: true,
                ),
                Wrap(
                  runSpacing: 6,
                  spacing: 6,
                  children: vendor.expertise
                      .map((e) => Chip(
                            label: Text(e),
                            labelStyle: const TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            visualDensity: VisualDensity.compact,
                            padding: const EdgeInsets.all(2),
                            backgroundColor: Colors.green.shade800,
                            shape: const RoundedRectangleBorder(
                              side: BorderSide(color: Colors.transparent),
                              borderRadius: BorderRadius.all(
                                Radius.circular(20),
                              ),
                            ),
                          ))
                      .toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _moreServices(List<ServiceModel> services) {
    final displayable = services.where((service) => !service.disabled).toList();

    return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: displayable.length,
        separatorBuilder: (context, _) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final service = displayable[index];

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
                      imageUrl:
                          '${endpoint.publicResource}/${service.images[0].url}',
                      fit: BoxFit.fitHeight,
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) {
                        return CircularProgressIndicator(
                            value: downloadProgress.progress);
                      },
                      errorWidget: (context, url, error) => const Icon(
                        CupertinoIcons.photo,
                      ),
                    )
                  : Icon(
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
                maxLines: 2,
              ),
              trailing: const Icon(CupertinoIcons.arrow_right),
            ),
          );
        });
  }

  IconData _icon(String key) {
    if (!tagIconMap.containsKey(key)) {
      return CupertinoIcons.wrench;
    }

    return tagIconMap[key]!;
  }
}
