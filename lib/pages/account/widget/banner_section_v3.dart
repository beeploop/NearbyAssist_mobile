import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nearby_assist/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:nearby_assist/config/assets.dart';

class BannerSectionV3 extends StatelessWidget {
  const BannerSectionV3({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, provider, _) {
        return Container(
          decoration: const BoxDecoration(color: Colors.green),
          padding: const EdgeInsets.all(20),
          child: GestureDetector(
            onTap: () => context.pushNamed("profile"),
            child: IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 36,
                    foregroundImage:
                        CachedNetworkImageProvider(provider.user.imageUrl),
                    backgroundImage: const AssetImage(Assets.profile),
                  ),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        provider.user.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        provider.user.email,
                        style: const TextStyle(color: Colors.white),
                        overflow: TextOverflow.ellipsis,
                      ),
                      provider.user.isVerified
                          ? _verified()
                          : provider.user.hasPendingVerification
                              ? _pendingVerification(context)
                              : _unverified(context),
                    ],
                  ),
                  Expanded(
                    child: Container(
                      decoration:
                          const BoxDecoration(color: Colors.transparent),
                    ),
                  ),
                  const Icon(CupertinoIcons.chevron_right, color: Colors.white),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _unverified(BuildContext context) {
    return TextButton.icon(
      onPressed: () {
        context.pushNamed('verifyAccount');
      },
      style: OutlinedButton.styleFrom(
        visualDensity: VisualDensity.compact,
        iconColor: Colors.white,
        padding: const EdgeInsets.all(0),
      ),
      icon: const Icon(CupertinoIcons.checkmark_seal, size: 18),
      label: const Text(
        'Unverified',
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _pendingVerification(BuildContext context) {
    return TextButton.icon(
      onPressed: () {},
      style: OutlinedButton.styleFrom(
        visualDensity: VisualDensity.compact,
        iconColor: Colors.white,
        padding: const EdgeInsets.all(0),
      ),
      icon: const Icon(CupertinoIcons.checkmark_seal, size: 18),
      label: const Text(
        'Pending Verification',
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _verified() {
    return TextButton.icon(
      onPressed: () {},
      style: OutlinedButton.styleFrom(
        visualDensity: VisualDensity.compact,
        iconColor: Colors.white,
        padding: const EdgeInsets.all(0),
      ),
      icon: const Icon(CupertinoIcons.checkmark_seal_fill, size: 18),
      label: const Text(
        'Verified',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
