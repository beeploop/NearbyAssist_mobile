import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Menu extends StatelessWidget {
  const Menu({super.key, required this.vendorId});

  final String vendorId;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon: const Icon(CupertinoIcons.ellipsis),
      itemBuilder: (context) => [
        _popupItem(
          context,
          onTap: () => context.pushNamed(
            'vendorPage',
            queryParameters: {'vendorId': vendorId},
          ),
          icon: CupertinoIcons.person,
          text: 'View profile',
        ),
        _popupItem(
          context,
          onTap: () {},
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
