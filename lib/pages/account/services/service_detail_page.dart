import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ServiceDetailPage extends StatefulWidget {
  const ServiceDetailPage({super.key, required this.serviceId});

  final String serviceId;

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
          IconButton(
            icon: const Icon(CupertinoIcons.gear),
            onPressed: () => context.pushNamed(
              'editService',
              queryParameters: {'serviceId': widget.serviceId},
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text("service id: ${widget.serviceId}"),
          ],
        ),
      ),
    );
  }
}
