import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:nearby_assist/models/service_review_model.dart';
import 'package:nearby_assist/utils/date_formatter.dart';

class ReviewItem extends StatelessWidget {
  const ReviewItem({super.key, required this.review});

  final ServiceReviewModel review;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      titleAlignment: ListTileTitleAlignment.top,
      leading: CachedNetworkImage(
        imageUrl: review.revieweeImage,
        fit: BoxFit.contain,
        progressIndicatorBuilder: (context, url, downloadProgress) {
          return CircularProgressIndicator(value: downloadProgress.progress);
        },
        errorWidget: (context, url, error) => const Icon(
          CupertinoIcons.photo,
        ),
      ),
      title: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(
          children: [
            _stars(),
            const Spacer(),
            Text(
              DateFormatter.monthAndDate(review.createdAt),
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
      subtitle: ExpandableText(
        review.text,
        expandText: 'Read more',
        collapseText: 'Show less',
        maxLines: 3,
        linkColor: Colors.blue,
      ),
    );
  }

  Widget _stars() {
    return RatingBar.builder(
      initialRating: review.rating.toDouble(),
      allowHalfRating: true,
      itemSize: 20,
      itemBuilder: (context, _) => const Icon(
        Icons.star,
        color: Colors.amber,
      ),
      onRatingUpdate: (_) {},
      ignoreGestures: true,
    );
  }
}
