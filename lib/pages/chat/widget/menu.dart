import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nearby_assist/pages/account/report/report_user_reason_page.dart';

class Menu extends StatelessWidget {
  const Menu({super.key, required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon: const Icon(CupertinoIcons.ellipsis_vertical),
      itemBuilder: (context) => [
        _popupItem(
          context,
          onTap: () => context.pushNamed(
            'vendorPage',
            queryParameters: {'vendorId': userId},
          ),
          icon: CupertinoIcons.person,
          text: 'View profile',
        ),
        _popupItem(
          context,
          onTap: () {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => ReportUserReasonPage(userId: userId),
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
