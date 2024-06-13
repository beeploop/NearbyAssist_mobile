import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:nearby_assist/model/vendor_info_model.dart';

class VendorHeader extends StatefulWidget {
  const VendorHeader({super.key, required this.vendorInfo});

  final VendorInfoModel vendorInfo;

  @override
  State<VendorHeader> createState() => _VendorHeader();
}

class _VendorHeader extends State<VendorHeader> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Wrap(
            children: [
              Image.network(widget.vendorInfo.imageUrl),
              const SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.vendorInfo.vendor),
                  Text(widget.vendorInfo.job),
                  RatingBar.builder(
                    initialRating: widget.vendorInfo.rating,
                    allowHalfRating: true,
                    itemSize: 20,
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: Colors.yellow,
                    ),
                    onRatingUpdate: (_) {
                      debugPrint('rating update not allowed');
                    },
                    ignoreGestures: true,
                  ),
                ],
              ),
            ],
          ),
          IconButton(
            onPressed: () {
              context.pushNamed(
                'chat',
                pathParameters: {'userId': '${widget.vendorInfo.vendorId}'},
                queryParameters: {'vendorName': widget.vendorInfo.vendor},
              );
            },
            icon: const Icon(
              Icons.message,
              size: 40,
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }

  int totalReviews(Map<int, int> reviewCountMap) {
    int total = 0;
    for (var count in reviewCountMap.values) {
      total += count;
    }
    return total;
  }
}
