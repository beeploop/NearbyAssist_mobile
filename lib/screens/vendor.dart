import 'package:flutter/material.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/services/vendor_service.dart';

class Vendor extends StatefulWidget {
  const Vendor({super.key, required this.vendorId});

  final String vendorId;

  @override
  State<Vendor> createState() => _Vendor();
}

class _Vendor extends State<Vendor> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: ListenableBuilder(
          listenable: getIt.get<VendorService>(),
          builder: (context, child) {
            final isVisible = !getIt.get<VendorService>().isLoading();

            return Visibility(
              replacement: const CircularProgressIndicator(),
              visible: isVisible,
              child: Text('vendor data: ${widget.vendorId}'),
            );
          },
        ),
      ),
    );
  }
}
