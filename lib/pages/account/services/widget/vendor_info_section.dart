import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:nearby_assist/models/vendor_model.dart';
import 'package:nearby_assist/providers/user_provider.dart';
import 'package:provider/provider.dart';

class VendorInfoSection extends StatelessWidget {
  const VendorInfoSection({
    super.key,
    required this.vendor,
    this.height,
  });

  final VendorModel vendor;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;

    return GestureDetector(
      onTap: () {
        if (vendor.id == user.id) {
          context.pushNamed('manage');
          return;
        }

        context.pushNamed(
          'vendorPage',
          queryParameters: {'vendorId': vendor.id},
        );
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.green[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            SizedBox(
              height: height ?? 80,
              width: 80,
              child: Image.network(
                vendor.imageUrl,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, chunk) {
                  if (chunk == null) {
                    return child;
                  }

                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
            const SizedBox(width: 10),
            SizedBox(
              height: height ?? 80,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    vendor.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    vendor.email,
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 5),
                  RatingBar.builder(
                    initialRating: vendor.rating,
                    allowHalfRating: true,
                    itemSize: 20,
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: Colors.yellow,
                    ),
                    onRatingUpdate: (_) {},
                    ignoreGestures: true,
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
