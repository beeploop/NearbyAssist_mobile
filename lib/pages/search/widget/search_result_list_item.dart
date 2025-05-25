import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:nearby_assist/config/service_tag_icon.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/models/search_result_model.dart';
import 'package:nearby_assist/utils/money_formatter.dart';

class SearchResultListItem extends StatelessWidget {
  const SearchResultListItem({super.key, required this.result});

  final SearchResultModel result;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: ListTile(
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
          style: const TextStyle(fontWeight: FontWeight.bold),
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          result.service!.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            RatingBar.builder(
              initialRating: result.rating,
              allowHalfRating: true,
              itemSize: 20,
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: Colors.yellow,
              ),
              onRatingUpdate: (_) {},
              ignoreGestures: true,
            ),
            const SizedBox(height: 4),
            Text(
              formatCurrency(result.price),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.black,
              ),
            ),
          ],
        ),
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
