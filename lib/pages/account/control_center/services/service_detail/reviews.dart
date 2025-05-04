import 'package:flutter/material.dart';
import 'package:nearby_assist/providers/control_center_provider.dart';
import 'package:provider/provider.dart';

class Reviews extends StatelessWidget {
  const Reviews({super.key, required this.serviceId});

  final String serviceId;

  @override
  Widget build(BuildContext context) {
    return Consumer<ControlCenterProvider>(
      builder: (context, serviceProvider, _) {
        return const SingleChildScrollView(
          child: Column(
            children: [],
          ),
        );
      },
    );
  }
}
