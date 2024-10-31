import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nearby_assist/utils/random_color.dart';

class ServiceItem extends StatelessWidget {
  const ServiceItem({
    super.key,
    this.paddingBottom = false,
    required this.description,
    required this.serviceId,
  });

  final bool paddingBottom;
  final String description;
  final String serviceId;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: paddingBottom ? 80 : 0),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: ListTile(
          title: Text(
            description,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          leading: Container(
            width: 2,
            decoration: BoxDecoration(
              color: getRandomColor(),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onTap: () {
            context.pushNamed(
              "detail",
              queryParameters: {'serviceId': serviceId},
            );
          },
        ),
      ),
    );
  }
}
