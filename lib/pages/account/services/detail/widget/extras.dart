import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nearby_assist/models/service_extra_model.dart';

class Extras extends StatelessWidget {
  const Extras({super.key, required this.extras});

  final List<ServiceExtraModel> extras;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...extras.map(
              (extra) => ListTile(
                leading: const Icon(CupertinoIcons.tags, color: Colors.green),
                title: Text(extra.title),
                subtitle: Text(extra.description),
                trailing: Text(
                  '₱ ${extra.price}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
