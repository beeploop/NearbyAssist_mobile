import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/models/service_extra_model.dart';
import 'package:nearby_assist/models/service_image_model.dart';
import 'package:nearby_assist/models/service_model.dart';
import 'package:nearby_assist/models/service_review_model.dart';
import 'package:nearby_assist/pages/account/control_center/services/edit_add_on/edit_add_on_page.dart';
import 'package:nearby_assist/pages/account/control_center/services/edit_service/edit_service_page.dart';
import 'package:nearby_assist/pages/account/control_center/services/service_detail/add_ons.dart';
import 'package:nearby_assist/pages/account/control_center/services/service_detail/images.dart';
import 'package:nearby_assist/pages/account/control_center/services/service_detail/widget/menu.dart';
import 'package:nearby_assist/pages/account/control_center/services/service_detail/widget/rating_count_bar.dart';
import 'package:nearby_assist/pages/account/control_center/services/service_detail/widget/review_item.dart';
import 'package:nearby_assist/providers/control_center_provider.dart';
import 'package:nearby_assist/utils/format_pricing_with_pricing_type.dart';
import 'package:nearby_assist/utils/money_formatter.dart';
import 'package:provider/provider.dart';

class ServiceDetailPage extends StatefulWidget {
  const ServiceDetailPage({
    super.key,
    required this.service,
  });

  final ServiceModel service;

  @override
  State<ServiceDetailPage> createState() => _ServiceDetailPageState();
}

class _ServiceDetailPageState extends State<ServiceDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detail',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          Icon(
            CupertinoIcons.circle_fill,
            color: widget.service.disabled ? Colors.red : Colors.green,
            size: 10,
          ),
          Menu(service: widget.service),
        ],
      ),
      body: Consumer<ControlCenterProvider>(
        builder: (context, provider, _) {
          final service = provider.services
              .firstWhere((service) => service.id == widget.service.id);

          return FutureBuilder(
            future: provider.getReviews(service.id),
            builder: (context, snapshot) {
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Images
                    _rowTitle('Images', 'Edit', () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => Images(serviceId: service.id),
                        ),
                      );
                    }),
                    const SizedBox(height: 6),
                    _images(widget.service.images),
                    const SizedBox(height: 10),

                    // Service
                    _rowTitle('Service', 'Edit', () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) =>
                              EditServicePage(service: service),
                        ),
                      );
                    }),
                    const SizedBox(height: 6),
                    Text(
                      service.title,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    Text(service.description),
                    const SizedBox(height: 10),
                    Text(
                      formatPriceWithPricingType(
                        service.price,
                        service.pricingType,
                      ),
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Tags
                    Wrap(
                      runSpacing: 4,
                      spacing: 4,
                      children: service.tags
                          .map((tag) => Chip(
                                label: Text(tag),
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
                    const SizedBox(height: 14),

                    // Add-ons
                    _rowTitle('Add-ons', 'Edit', () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => AddOns(serviceId: service.id),
                        ),
                      );
                    }),
                    const SizedBox(height: 6),
                    _addons(service.extras),
                    const SizedBox(height: 20),

                    // Reviews
                    snapshot.connectionState == ConnectionState.waiting
                        ? const Text('Reviews 0',
                            style: TextStyle(fontWeight: FontWeight.w600))
                        : Text(
                            'Reviews ${snapshot.data == null ? 0 : snapshot.data!.length}',
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                    const SizedBox(height: 10),

                    snapshot.connectionState == ConnectionState.waiting
                        ? const RatingCountBar(reviews: [])
                        : RatingCountBar(reviews: snapshot.data ?? []),
                    const SizedBox(height: 20),

                    snapshot.connectionState == ConnectionState.waiting
                        ? const Center(child: CircularProgressIndicator())
                        : _reviews(snapshot.data),

                    const SizedBox(height: 10),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _rowTitle(String title, String label, void Function() onTap) {
    return Row(
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        const Spacer(),
        TextButton(
          onPressed: onTap,
          child: Text(label),
        ),
      ],
    );
  }

  Widget _images(List<ServiceImageModel> images) {
    final height = MediaQuery.of(context).size.width - 40;

    if (images.isEmpty) {
      return Container(
        height: height,
        width: height,
        decoration: BoxDecoration(color: Colors.grey.shade300),
        child: const Center(
          child: Icon(CupertinoIcons.photo),
        ),
      );
    }

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
            imageUrl: '${endpoint.publicResource}/${images[idx].url}',
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

  Widget _addons(List<ServiceExtraModel> addons) {
    return ListView.separated(
      shrinkWrap: true,
      separatorBuilder: (context, _) => const SizedBox(height: 6),
      itemCount: addons.length,
      itemBuilder: (context, index) {
        final addon = addons[index];

        return ListTile(
          dense: true,
          onTap: () => Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => EditAddOnPage(
                serviceId: widget.service.id,
                extra: addon,
              ),
            ),
          ),
          titleAlignment: ListTileTitleAlignment.top,
          leading:
              Icon(CupertinoIcons.tags_solid, color: Colors.green.shade900),
          title: Text(addon.title, overflow: TextOverflow.ellipsis),
          subtitle: Text(
            addon.description,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: Text(
            formatCurrency(addon.price),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        );
      },
    );
  }

  Widget _reviews(List<ServiceReviewModel>? reviews) {
    final displayables = reviews ?? [];

    return ListView.separated(
      shrinkWrap: true,
      separatorBuilder: (context, _) => const SizedBox(height: 6),
      itemCount: displayables.length,
      itemBuilder: (context, index) {
        return ReviewItem(review: displayables[index]);
      },
    );
  }
}
