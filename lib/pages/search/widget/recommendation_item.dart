import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/models/recommendation_model.dart';
import 'package:nearby_assist/utils/money_formatter.dart';

class RecommendationItem extends StatelessWidget {
  const RecommendationItem({
    super.key,
    required this.data,
    required this.onPressed,
  });

  final RecommendationModel data;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onPressed(),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.green.shade200,
          borderRadius: BorderRadius.circular(4),
        ),
        padding: const EdgeInsets.all(2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: data.thumbnail.isEmpty
                  ? Container(
                      decoration: BoxDecoration(color: Colors.grey.shade200),
                    )
                  : CachedNetworkImage(
                      imageUrl: '${endpoint.resource}/${data.thumbnail}',
                      fit: BoxFit.fill,
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RatingBar.builder(
                    initialRating: data.rating,
                    allowHalfRating: true,
                    itemSize: 20,
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (_) {},
                    ignoreGestures: true,
                  ),
                  AutoSizeText(data.title),
                  AutoSizeText(formatCurrency(data.rate)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
