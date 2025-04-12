import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:nearby_assist/models/detailed_service_model.dart';
import 'package:nearby_assist/models/service_extra_model.dart';
import 'package:nearby_assist/pages/account/services/widget/image_section.dart';
import 'package:nearby_assist/pages/account/services/widget/rating_count_bar.dart';
import 'package:nearby_assist/pages/account/services/widget/service_actions.dart';
import 'package:nearby_assist/pages/account/services/widget/vendor_info_section.dart';
import 'package:nearby_assist/pages/booking/booking_page.dart';
import 'package:nearby_assist/pages/search/widget/service_review_item.dart';
import 'package:nearby_assist/providers/service_provider.dart';
import 'package:nearby_assist/providers/user_provider.dart';
import 'package:nearby_assist/utils/money_formatter.dart';
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
              ImageSection(images: details.service.images),
              const SizedBox(height: 10),

              // Vendor info
              VendorInfoSection(
                vendor: details.vendor,
              ),
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

              // Details
              const Text(
                'Description',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(details.service.description),
              const SizedBox(height: 20),

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
                formatCurrency(details.service.rate),
                style: const TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ),
        )
      ],
    );
  }
}
