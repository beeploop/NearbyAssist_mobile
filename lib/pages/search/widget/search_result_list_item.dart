import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:nearby_assist/config/service_tag_icon.dart';
import 'package:nearby_assist/config/theme/app_colors.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/models/search_result_model.dart';
import 'package:nearby_assist/utils/money_formatter.dart';

class SearchResultListItem extends StatelessWidget {
  const SearchResultListItem({super.key, required this.result});

  final SearchResultModel result;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => context.pushNamed(
        'viewService',
        queryParameters: {'serviceId': result.id},
      ),
      titleAlignment: ListTileTitleAlignment.top,
      leading: result.service!.images.isNotEmpty
          ? CachedNetworkImage(
              imageUrl:
                  '${endpoint.publicResource}/${result.service!.images[0].url}',
              fit: BoxFit.fitHeight,
              progressIndicatorBuilder: (context, url, downloadProgress) {
                return CircularProgressIndicator(
                    value: downloadProgress.progress);
              },
              errorWidget: (context, url, error) => const Icon(
                CupertinoIcons.photo,
              ),
            )
          : Icon(
              _icon(result.service!.tags.first),
              size: 26,
              grade: 10,
            ),
      title: Text(
        result.vendorName,
        style: Theme.of(context)
            .textTheme
            .bodySmall
            ?.copyWith(fontWeight: FontWeight.bold),
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        result.service!.title,
        style: Theme.of(context)
            .textTheme
            .bodySmall
            ?.copyWith(color: AppColors.greyDarker),
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
      ),
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          RatingBar.builder(
            initialRating: result.rating,
            allowHalfRating: true,
            itemSize: 16,
            itemBuilder: (context, _) => const Icon(
              Icons.star,
              color: AppColors.amber,
            ),
            onRatingUpdate: (_) {},
            ignoreGestures: true,
          ),
          const SizedBox(height: 4),
          Text(
            formatCurrency(result.price),
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  IconData _icon(String key) {
    if (!tagIconMap.containsKey(key)) {
      return CupertinoIcons.wrench;
    }

    return tagIconMap[key]!;
  }
}
