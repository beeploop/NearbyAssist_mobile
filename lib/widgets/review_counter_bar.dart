import 'package:flutter/material.dart';
import 'package:nearby_assist/model/count_per_rating_model.dart';

class ReviewCounterBar extends StatefulWidget {
  const ReviewCounterBar({super.key, required this.countPerRating});

  final CountPerRatingModel countPerRating;

  @override
  State<ReviewCounterBar> createState() => _ReviewCounterBar();
}

class _ReviewCounterBar extends State<ReviewCounterBar> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const SizedBox(width: 20, child: Text('5')),
            Expanded(
              child: LinearProgressIndicator(
                value: computeEquivalence(widget.countPerRating.five),
                minHeight: 8,
              ),
            )
          ],
        ),
        Row(
          children: [
            const SizedBox(width: 20, child: Text('4')),
            Expanded(
              child: LinearProgressIndicator(
                value: computeEquivalence(widget.countPerRating.four),
                minHeight: 8,
              ),
            )
          ],
        ),
        Row(
          children: [
            const SizedBox(width: 20, child: Text('3')),
            Expanded(
              child: LinearProgressIndicator(
                value: computeEquivalence(widget.countPerRating.three),
                minHeight: 8,
              ),
            )
          ],
        ),
        Row(
          children: [
            const SizedBox(width: 20, child: Text('2')),
            Expanded(
              child: LinearProgressIndicator(
                value: computeEquivalence(widget.countPerRating.two),
                minHeight: 8,
              ),
            )
          ],
        ),
        Row(
          children: [
            const SizedBox(width: 20, child: Text('1')),
            Expanded(
              child: LinearProgressIndicator(
                value: computeEquivalence(widget.countPerRating.one),
                minHeight: 8,
              ),
            )
          ],
        ),
      ],
    );
  }

  double computeEquivalence(int reviewCount) {
    return reviewCount * 1.0 / 5.0;
  }
}
