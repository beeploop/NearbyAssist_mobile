import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/models/detailed_service_model.dart';
import 'package:nearby_assist/models/service_extra_model.dart';
import 'package:nearby_assist/models/service_image_model.dart';
import 'package:nearby_assist/pages/booking/booking_page.dart';
import 'package:nearby_assist/pages/widget/rating_count_bar.dart';
import 'package:nearby_assist/pages/search/widget/service_actions.dart';
import 'package:nearby_assist/pages/search/widget/service_review_item.dart';
import 'package:nearby_assist/pages/search/widget/vendor_info_section.dart';
import 'package:nearby_assist/providers/service_provider.dart';
import 'package:nearby_assist/providers/user_provider.dart';
import 'package:nearby_assist/utils/format_pricing_with_pricing_type.dart';
import 'package:nearby_assist/utils/money_formatter.dart';
import 'package:nearby_assist/utils/show_has_pending_verification.dart';
import 'package:nearby_assist/utils/show_restricted_account_modal.dart';
import 'package:nearby_assist/utils/show_unverified_account_modal.dart';
import 'package:provider/provider.dart';

class ServiceViewPage extends StatefulWidget {
  const ServiceViewPage({
    super.key,
    required this.serviceId,
  });

  final String serviceId;

  @override
  State<ServiceViewPage> createState() => _ServiceViewPageState();
}

class _ServiceViewPageState extends State<ServiceViewPage> {
  DetailedServiceModel? _details;
  bool _loading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchService();
    });
  }

  Future<void> _fetchService() async {
    try {
      final res = await Provider.of<ServiceProvider>(context, listen: false)
          .getService(widget.serviceId);

      setState(() {
        _details = res;
        _loading = false;
        _errorMessage = null;
      });
    } catch (error) {
      setState(() {
        _details = null;
        _loading = false;
        _errorMessage = error.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detail',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: _loading
          ? const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(child: CircularProgressIndicator()),
              ],
            )
          : _errorMessage != null
              ? Center(
                  child: AlertDialog(
                    icon: const Icon(CupertinoIcons.exclamationmark_triangle),
                    title: const Text('Something went wrong'),
                    content: Text(_errorMessage!),
                  ),
                )
              : _showContent(_details!),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(color: Colors.white),
        height: MediaQuery.of(context).size.height * 0.05,
        child: _details == null ? Container() : _bottomBar(_details!),
      ),
    );
  }

  Widget _showContent(DetailedServiceModel details) {
    return RefreshIndicator(
      onRefresh: () => context
          .read<ServiceProvider>()
          .getService(widget.serviceId, fresh: true),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _images(details.service.images),
              const SizedBox(height: 10),

              // Vendor info
              VendorInfoSection(vendor: details.vendor),
              const SizedBox(height: 20),

              // Actions
              ServiceActions(service: details),
              const SizedBox(height: 20),

              // Extras
              const Divider(),
              ListTile(
                onTap: () => _viewExtras(details.service.extras),
                title: const Text('Add-ons'),
                trailing: const Icon(CupertinoIcons.chevron_right, size: 20),
              ),
              const SizedBox(height: 10),

              // Title
              const Text(
                'Title',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                details.service.title,
                overflow: TextOverflow.ellipsis,
                maxLines: 3,
              ),
              const SizedBox(height: 20),

              // Details
              const Text(
                'Description',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(details.service.description),
              const SizedBox(height: 20),

              // tags
              Wrap(
                runSpacing: 4,
                spacing: 4,
                children: details.service.tags
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
              const SizedBox(height: 10),

              // Divider
              const Divider(),
              const SizedBox(height: 20),

              // Rating
              Text(
                'Total Reviews: ${details.ratings.reduce((a, b) => a + b)}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 160,
                child: RatingCountBar(rating: details.ratings),
              ),
              const SizedBox(height: 20),

              // Latest reviews
              const Text(
                'Reviews',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                separatorBuilder: (context, _) => const Divider(),
                itemCount: details.reviews.length,
                itemBuilder: (context, index) => ServiceReviewItem(
                  review: details.reviews[index],
                ),
              ),
              const SizedBox(height: 20),

              // Divider
              const Divider(),

              // Bottom padding
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
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

  void _viewExtras(List<ServiceExtraModel> extras) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.60,
        width: double.infinity,
        child: Container(
          padding: const EdgeInsets.all(10),
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: extras.length,
            separatorBuilder: (context, _) => const Divider(),
            itemBuilder: (context, idx) {
              return ListTile(
                titleAlignment: ListTileTitleAlignment.top,
                leading: Icon(
                  CupertinoIcons.tags_solid,
                  color: Colors.green.shade900,
                ),
                title: Text(
                  extras[idx].title,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: ExpandableText(
                  extras[idx].description,
                  expandText: 'Read more',
                  collapseText: 'Show less',
                  maxLines: 2,
                  linkColor: Colors.blue,
                ),
                trailing: Text(
                  formatCurrency(extras[idx].price),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _bottomBar(DetailedServiceModel details) {
    final user = context.watch<UserProvider>().user;

    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () {
                    if (user.id == details.vendor.id) return;

                    if (!user.isVerified) {
                      if (user.hasPendingVerification) {
                        showHasPendingVerification(context);
                        return;
                      }

                      showUnverifiedAccountModal(context);
                      return;
                    }

                    if (user.isRestricted) {
                      showAccountRestrictedModal(context);
                      return;
                    }

                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => BookingPage(details: details),
                      ),
                    );
                  },
                  child: FaIcon(
                    FontAwesomeIcons.handshakeSimple,
                    color: user.id == details.vendor.id ? Colors.grey : null,
                  ),
                ),
              ),
              Expanded(
                child: TextButton(
                  onPressed: () {
                    if (user.id == details.vendor.id) return;

                    if (!user.isVerified) {
                      if (user.hasPendingVerification) {
                        showHasPendingVerification(context);
                        return;
                      }

                      showUnverifiedAccountModal(context);
                      return;
                    }

                    context.pushNamed(
                      'chat',
                      queryParameters: {
                        'recipientId': details.vendor.id,
                        'recipient': details.vendor.name,
                      },
                    );
                  },
                  child: Icon(
                    CupertinoIcons.ellipses_bubble_fill,
                    color: user.id == details.vendor.id ? Colors.grey : null,
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.green.shade800,
            ),
            child: Center(
              child: Text(
                formatPriceWithPricingType(
                  details.service.price,
                  details.service.pricingType,
                ),
                style: const TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ),
        )
      ],
    );
  }
}
