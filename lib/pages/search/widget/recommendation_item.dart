import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nearby_assist/config/theme/app_colors.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/models/recommendation_model.dart';
import 'package:nearby_assist/utils/format_pricing_with_pricing_type.dart';

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
          color: AppColors.primaryLighter,
          borderRadius: BorderRadius.circular(4),
        ),
        padding: const EdgeInsets.all(2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: data.thumbnail.isEmpty
                  ? Container(
                      decoration: const BoxDecoration(color: AppColors.grey),
                    )
                  : CachedNetworkImage(
                      imageUrl: '${endpoint.publicResource}/${data.thumbnail}',
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        )),
                      ),
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoSizeText(
                    data.title,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      AutoSizeText(
                        formatPriceWithPricingType(
                          data.price,
                          data.pricingType,
                        ),
                      ),
                      const Spacer(),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '${data.rating} ',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            const WidgetSpan(
                              child: Icon(
                                CupertinoIcons.star_fill,
                                color: AppColors.amber,
                                size: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
