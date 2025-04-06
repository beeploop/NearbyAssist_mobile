import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:nearby_assist/pages/account/widget/account_tile_widget.dart';
import 'package:nearby_assist/providers/user_provider.dart';
import 'package:provider/provider.dart';

class AccountSection extends StatelessWidget {
  const AccountSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, provider, _) {
        return Container(
          padding: const EdgeInsetsDirectional.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Account Settings", style: TextStyle(fontSize: 20)),
              AccountTileWidget(
                  title: "Profile",
                  icon: CupertinoIcons.person,
                  onPress: () => context.pushNamed("profile")),
              if (provider.user.isVendor)
                AccountTileWidget(
                    title: "Manage Services",
                    icon: CupertinoIcons.tray_full,
                    onPress: () => context.pushNamed("manage")),
              AccountTileWidget(
                  title: "Bookings",
                  icon: CupertinoIcons.arrow_right_arrow_left_square,
                  onPress: () => context.pushNamed("bookings")),
              AccountTileWidget(
                  title: "Settings",
                  icon: CupertinoIcons.gear,
                  onPress: () => context.pushNamed("settings")),
            ],
          ),
        );
      },
    );
  }
}
