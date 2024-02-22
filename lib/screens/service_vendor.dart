import 'package:flutter/material.dart';

class ServiceVendor extends StatefulWidget {
  const ServiceVendor({super.key, required this.vendorId});

  final String vendorId;

  @override
  State<ServiceVendor> createState() => _ServiceVendor();
}

class _ServiceVendor extends State<ServiceVendor> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Text('service vendor: ${widget.vendorId}'),
      ),
    );
  }
}
