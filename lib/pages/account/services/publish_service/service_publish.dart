import 'package:flutter/material.dart';

class ServicePublish extends StatefulWidget {
  const ServicePublish({super.key});

  @override
  State<ServicePublish> createState() => _ServicePublishState();
}

class _ServicePublishState extends State<ServicePublish> {
  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Text(
          'Publish Service',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        Text('Click the button below to publish your service.'),
        SizedBox(height: 10),
      ],
    );
  }
}
