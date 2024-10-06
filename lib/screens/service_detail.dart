import 'package:flutter/material.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/services/vendor_service.dart';

class ServiceDetail extends StatefulWidget {
  const ServiceDetail({super.key, required this.serviceId});

  final String serviceId;

  @override
  State<ServiceDetail> createState() => _ServiceDetail();
}

class _ServiceDetail extends State<ServiceDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Details',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: FutureBuilder(
        future: getIt.get<VendorService>().getServiceInfo(widget.serviceId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            final err = snapshot.error.toString();
            return Center(child: Text(err));
          }

          if (!snapshot.hasData) {
            return const Center(
              child: Text('Unexpected behavior, no error but has no data'),
            );
          }

          final data = snapshot.data!;

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Text(data.serviceInfo.id),
            ],
          );
        },
      ),
    );
  }
}
