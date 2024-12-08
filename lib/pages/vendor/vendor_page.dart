import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:nearby_assist/config/service_tag_icon.dart';
import 'package:nearby_assist/models/detailed_vendor_model.dart';
import 'package:nearby_assist/models/vendor_model.dart';
import 'package:nearby_assist/providers/vendor_provider.dart';
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
      ),
      body: FutureBuilder(
        future: Provider.of<VendorProvider>(context).getVendor(widget.vendorId),
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

          final data = snapshot.data!;
          return _content(data);
        },
      ),
    );
  }

  Widget _content(DetailedVendorModel data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ListView(
        children: [
          _header(data.vendor),
          const SizedBox(height: 10),
          const Divider(),
          const SizedBox(height: 10),
          const Text(
            'More Services',
            style: TextStyle(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          ...data.services.map(
            (service) => Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.green[100],
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                onTap: () => context.pushNamed(
                  'viewService',
                  queryParameters: {'serviceId': service.id},
                ),
                leading: Icon(
                  tagIconMap[service.tags[0]],
                  size: 26,
                  grade: 10,
                ),
                title: Text(service.description),
                trailing: const Icon(CupertinoIcons.arrow_right),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _header(VendorModel vendor) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.green[200],
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
                Text(
                  vendor.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Text(
                  vendor.email,
                  style: const TextStyle(fontSize: 14),
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
}
