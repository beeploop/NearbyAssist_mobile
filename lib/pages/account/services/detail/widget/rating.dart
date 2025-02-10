import 'package:flutter/material.dart';
import 'package:nearby_assist/models/rating_count_model.dart';
import 'package:nearby_assist/pages/account/services/widget/rating_count_bar.dart';

class Rating extends StatelessWidget {
  const Rating({super.key, required this.rating});

  final RatingCountModel rating;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Total
            Text(
              'Total reviews: ${rating.total()}',
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 20),

            // Rating bar
            RatingCountBar(rating: rating),
            const SizedBox(height: 20),

            // Bottom padding
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
