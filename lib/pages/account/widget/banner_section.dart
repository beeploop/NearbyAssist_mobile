import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nearby_assist/config/assets.dart';
import 'package:nearby_assist/providers/user_provider.dart';
import 'package:provider/provider.dart';

class BannerSection extends StatelessWidget {
  const BannerSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, provider, _) {
        return Container(
          height: 200,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
            color: Colors.green,
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CircleAvatar(
                  radius: 40,
                  foregroundImage:
                      CachedNetworkImageProvider(provider.user.imageUrl),
                  backgroundImage: const AssetImage(Assets.profile),
                ),
                const SizedBox(height: 10),
                Text(
                  provider.user.name,
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
                Text(
                  provider.user.email,
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
