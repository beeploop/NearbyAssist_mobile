import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nearby_assist/models/booking_model.dart';
import 'package:nearby_assist/pages/account/report/report_user_reason_page.dart';

class Menu extends StatelessWidget {
  const Menu({super.key, required this.booking});

  final BookingModel booking;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon: const Icon(CupertinoIcons.ellipsis),
      itemBuilder: (context) => [
        _popupItem(
          context,
          onTap: () {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => ReportUserReasonPage(
                  userId: booking.vendor.id,
                  bookingId: booking.id,
                ),
              ),
            );
          },
          icon: CupertinoIcons.nosign,
          text: 'Report user',
        ),
      ],
    );
  }

  PopupMenuItem _popupItem(
    BuildContext context, {
    required IconData icon,
    required String text,
    required void Function() onTap,
  }) {
    return PopupMenuItem(
      onTap: onTap,
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.3,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Icon(icon, size: 18),
            const SizedBox(width: 10),
            Text(text),
          ],
        ),
      ),
    );
  }
}
