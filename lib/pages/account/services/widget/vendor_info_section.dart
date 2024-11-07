import 'package:flutter/material.dart';

class VendorInfoSection extends StatelessWidget {
  const VendorInfoSection({
    super.key,
    required this.name,
    required this.rating,
    this.height,
  });

  final String name;
  final double rating;
  final double? height;

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
            height: height ?? 80,
            width: 80,
            child: Container(
              decoration: BoxDecoration(color: Colors.grey[300]),
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            height: height ?? 80,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Text(
                  'rating: $rating',
                  style: TextStyle(fontSize: 14, color: Colors.grey[800]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
