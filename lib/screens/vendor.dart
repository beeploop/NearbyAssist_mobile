import 'package:flutter/material.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/services/vendor_service.dart';
import 'package:nearby_assist/widgets/review_counter_bar.dart';
import 'package:nearby_assist/widgets/vendor_header.dart';
import 'package:nearby_assist/widgets/vendor_photos.dart';

class Vendor extends StatefulWidget {
  const Vendor({super.key, required this.serviceId});

  final String serviceId;

  @override
  State<Vendor> createState() => _Vendor();
}

class _Vendor extends State<Vendor> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder(
        future: getIt.get<VendorService>().fetchServiceInfo(widget.serviceId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            final error = snapshot.error!;

            return Center(
              child: Text('Error occurred: $error'),
            );
          }

          final data = snapshot.data!;

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              VendorHeader(
                vendorInfo: data.vendorInfo,
                serviceId: data.serviceInfo.id,
              ),
              const SizedBox(height: 20),
              const SizedBox(height: 20),
              VendorPhotos(
                photos: data.serviceImages,
              ),
              const SizedBox(height: 20),
              Wrap(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Description',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      Text(data.serviceInfo.description),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Wrap(
                children: [
                  const Text(
                    'Reviews',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  ReviewCounterBar(
                    countPerRating: data.countPerRating,
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
