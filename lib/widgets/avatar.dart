import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/model/auth_model.dart';
import 'package:nearby_assist/model/settings_model.dart';
import 'package:nearby_assist/services/logger_service.dart';

class Avatar extends StatelessWidget {
  const Avatar({super.key});

  @override
  Widget build(BuildContext context) {
    final user = getIt.get<AuthModel>().getUser();
    final addr = getIt.get<SettingsModel>().getServerAddr();

    return Padding(
        padding: const EdgeInsets.only(right: 20),
        child: Row(
          children: [
            Text(user.name),
            const SizedBox(width: 10),
            CircleAvatar(
              radius: 16,
              foregroundImage: CachedNetworkImageProvider(
                user.imageUrl.startsWith("http")
                    ? user.imageUrl
                    : '$addr/resource/${user.imageUrl}',
              ),
              onForegroundImageError: (object, stacktrace) {
                ConsoleLogger().log(
                  'Error loading network image for user avatar',
                );
              },
              backgroundImage: const AssetImage('assets/images/avatar.png'),
            ),
          ],
        ));
  }
}
