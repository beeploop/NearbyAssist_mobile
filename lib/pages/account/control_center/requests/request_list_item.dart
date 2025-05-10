import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nearby_assist/models/booking_model.dart';
import 'package:nearby_assist/utils/date_formatter.dart';

class RequestListItem extends StatelessWidget {
  const RequestListItem({
    super.key,
    required this.booking,
    required this.onTap,
    this.backgroundColor,
  });

  final BookingModel booking;
  final void Function() onTap;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        titleAlignment: ListTileTitleAlignment.top,
        leading: CachedNetworkImage(
          imageUrl: booking.client.imageUrl,
          fit: BoxFit.contain,
          progressIndicatorBuilder: (context, url, downloadProgress) {
            return CircularProgressIndicator(value: downloadProgress.progress);
          },
          errorWidget: (context, url, error) => const Icon(
            CupertinoIcons.photo,
          ),
        ),
        title: Text(
          booking.client.name,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          booking.service.title,
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
        ),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              DateFormatter.monthAndDateFromDT(booking.createdAt),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            OutlinedButton(
              onPressed: onTap,
              style: ButtonStyle(
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                visualDensity: VisualDensity.compact,
              ),
              child: const Text('Details'),
            ),
          ],
        ),
      ),
    );
  }
}
