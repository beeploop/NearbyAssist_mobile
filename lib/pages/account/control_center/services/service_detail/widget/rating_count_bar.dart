import 'package:flutter/material.dart';
import 'package:nearby_assist/models/service_review_model.dart';

class RatingCountBar extends StatelessWidget {
  const RatingCountBar({
    super.key,
    required this.reviews,
    this.gap = 24,
    this.spacing = 2,
  });

  final List<ServiceReviewModel> reviews;
  final double gap;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    final rating = _buildRatingList();

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _ratingRow('5 ⭐', rating[4]),
        SizedBox(height: spacing),
        _ratingRow('4 ⭐', rating[3]),
        SizedBox(height: spacing),
        _ratingRow('3 ⭐', rating[2]),
        SizedBox(height: spacing),
        _ratingRow('2 ⭐', rating[1]),
        SizedBox(height: spacing),
        _ratingRow('1 ⭐', rating[0]),
        SizedBox(height: spacing),
      ],
    );
  }

  List<int> _buildRatingList() {
    final ratings = List<int>.filled(5, 0, growable: false);

    for (final review in reviews) {
      switch (review.rating) {
        case 5:
          ratings[4]++;
        case 4:
          ratings[3]++;
        case 3:
          ratings[2]++;
        case 2:
          ratings[1]++;
        case 1:
          ratings[0]++;
      }
    }

    return ratings;
  }

  Widget _ratingRow(String title, int rating) {
    return Row(
      children: [
        Text(title),
        const SizedBox(width: 10),
        Expanded(
          child: LinearProgressIndicator(
            value: _computeEquivalence(rating),
            minHeight: 16,
          ),
        )
      ],
    );
  }

  double _computeEquivalence(int reviewCount) {
    return reviewCount * 1.0 / 5.0;
  }
}
