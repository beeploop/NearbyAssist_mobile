import 'package:flutter/material.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/model/auth_model.dart';

class Avatar extends StatelessWidget {
  const Avatar({super.key});

  @override
  Widget build(BuildContext context) {
    final user = getIt.get<AuthModel>().getUser();

    return Padding(
        padding: const EdgeInsets.only(right: 20),
        child: Row(
          children: [
            Text(user.name),
            const SizedBox(width: 10),
            CircleAvatar(
              radius: 16,
              foregroundImage: NetworkImage(user.imageUrl),
              onForegroundImageError: (object, stacktrace) {
                debugPrint('Error loading network image for user avatar');
              },
              backgroundImage: const AssetImage('assets/images/avatar.png'),
            ),
          ],
        ));
  }
}
