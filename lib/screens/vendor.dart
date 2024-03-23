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
  void initState() {
    super.initState();

    getIt.get<VendorService>().fetchServiceInfo(widget.serviceId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 20),
        children: [
          Center(
            child: ListenableBuilder(
              listenable: getIt.get<VendorService>(),
              builder: (context, child) {
                final isVisible = !getIt.get<VendorService>().isLoading();
                final serviceData = getIt.get<VendorService>().getServiceInfo();

                return Visibility(
                  replacement: const CircularProgressIndicator(),
                  visible: isVisible,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        VendorHeader(
                          vendorId: serviceData != null ? serviceData.id : 1,
                        ),
                        const SizedBox(height: 20),
                        Text(
                            serviceData != null
                                ? serviceData.title
                                : 'Untitled Service',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            )),
                        const SizedBox(height: 20),
                        VendorPhotos(
                          photos: serviceData != null ? serviceData.photos : [],
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
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                                Text(serviceData != null
                                    ? serviceData.description
                                    : 'No description'),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        const Wrap(
                          children: [
                            Text(
                              'Reviews',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            ReviewCounterBar(),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
