import 'package:flutter/material.dart';
import 'package:nearby_assist/models/rating_count_model.dart';

class RatingCountBar extends StatelessWidget {
  const RatingCountBar({
    super.key,
    required this.rating,
    this.gap = 24,
  });

  final RatingCountModel rating;
  final double gap;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _ratingRow('5⭐', rating.five),
        _ratingRow('4⭐', rating.four),
        _ratingRow('3⭐', rating.three),
        _ratingRow('2⭐', rating.two),
        _ratingRow('1⭐', rating.one),
      ],
    );
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
