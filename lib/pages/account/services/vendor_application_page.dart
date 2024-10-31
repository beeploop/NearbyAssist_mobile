import 'package:flutter/material.dart';

class VendorApplicationPage extends StatefulWidget {
  const VendorApplicationPage({super.key});

  @override
  State<VendorApplicationPage> createState() => _VendorApplicationPageState();
}

class _VendorApplicationPageState extends State<VendorApplicationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Vendor Application',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: const Center(
        child: Text('Vendor Application'),
      ),
    );
  }
}
