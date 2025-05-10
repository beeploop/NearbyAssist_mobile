import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nearby_assist/pages/account/report/report_user_reason_page.dart';
import 'package:nearby_assist/providers/user_provider.dart';
import 'package:nearby_assist/utils/show_unverified_account_modal.dart';
import 'package:provider/provider.dart';

class Menu extends StatelessWidget {
  const Menu({super.key, required this.vendorId});

  final String vendorId;

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, provider, _) {
        return PopupMenuButton(
          icon: const Icon(CupertinoIcons.ellipsis_vertical),
          itemBuilder: (context) => [
            _popupItem(
              context,
              onTap: () {
                if (!provider.user.isVerified) {
                  showUnverifiedAccountModal(context);
                  return;
                }

                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) =>
                        ReportUserReasonPage(userId: vendorId),
                  ),
                );
              },
              icon: CupertinoIcons.nosign,
              text: 'Report user',
            ),
          ],
        );
      },
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
