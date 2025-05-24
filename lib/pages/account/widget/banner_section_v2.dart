import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nearby_assist/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:nearby_assist/config/assets.dart';

class BannerSectionV2 extends StatelessWidget {
  const BannerSectionV2({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, provider, _) {
        return Container(
          decoration: const BoxDecoration(color: Colors.green),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () => context.pushNamed("profile"),
                  child: CircleAvatar(
                    radius: 40,
                    foregroundImage:
                        CachedNetworkImageProvider(provider.user.imageUrl),
                    backgroundImage: const AssetImage(Assets.profile),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  provider.user.name,
                  style: const TextStyle(color: Colors.white),
                ),
                Text(
                  provider.user.email,
                  style: const TextStyle(color: Colors.white),
                ),
                OutlinedButton.icon(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                    iconColor: Colors.blue.shade600,
                    backgroundColor: Colors.white,
                    side: BorderSide(color: Colors.blue.shade600),
                  ),
                  icon: const Icon(CupertinoIcons.checkmark_seal),
                  label: Text(
                    'unverified',
                    style: TextStyle(color: Colors.blue.shade600),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }
}
