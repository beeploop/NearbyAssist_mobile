import 'package:flutter/material.dart';

class RatingCountBar extends StatelessWidget {
  const RatingCountBar({
    super.key,
    required this.rating,
    this.gap = 24,
    this.spacing = 2,
  });

  final List<int> rating;
  final double gap;
  final double spacing;

  @override
  Widget build(BuildContext context) {
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
