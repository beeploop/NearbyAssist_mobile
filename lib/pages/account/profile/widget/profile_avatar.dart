import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nearby_assist/providers/user_provider.dart';
import 'package:provider/provider.dart';

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, provider, _) {
        return Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.3,
              height: MediaQuery.of(context).size.width * 0.3,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.green.shade800,
                  width: 4,
                ),
                shape: BoxShape.circle,
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: CachedNetworkImageProvider(
                    provider.user.imageUrl,
                  ),
                ),
              ),
            ),

            //
            Positioned(
              bottom: -10,
              right: -10,
              child: IconButton(
                icon: Icon(
                  provider.user.isVerified
                      ? CupertinoIcons.checkmark_seal_fill
                      : CupertinoIcons.checkmark_seal,
                  size: 30,
                  color: Colors.blue,
                ),
                onPressed: () {
                  if (provider.user.isVerified) return;
                  context.pushNamed('verifyAccount');
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
