import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class VendorInfoSection extends StatelessWidget {
  const VendorInfoSection({super.key, required this.serviceId});

  final String serviceId;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.green[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          SizedBox(
            height: 80,
            width: 80,
            child: Container(
              decoration: BoxDecoration(color: Colors.grey[300]),
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Vendor Name',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                'Service ID: $serviceId',
                style: TextStyle(fontSize: 14, color: Colors.grey[800]),
              ),
              Text(
                'Ratings',
                style: TextStyle(fontSize: 14, color: Colors.grey[800]),
              ),
            ],
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(
              CupertinoIcons.map_fill,
              size: 30,
              color: Colors.white,
            ),
            onPressed: () => context.pushNamed(
              'route',
              queryParameters: {'serviceId': serviceId},
            ),
          ),
        ],
      ),
    );
  }
}
