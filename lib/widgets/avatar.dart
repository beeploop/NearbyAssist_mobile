import 'package:flutter/material.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/model/auth_model.dart';

class Avatar extends StatelessWidget {
  const Avatar({super.key, required this.user});

  final String user;

  @override
  Widget build(BuildContext context) {
    final avatarUrl = getIt.get<AuthModel>().getUser()?.image;

    return Padding(
        padding: const EdgeInsets.only(right: 20),
        child: Row(
          children: [
            Text(user),
            const SizedBox(width: 10),
            CircleAvatar(
              radius: 16,
              foregroundImage: NetworkImage(avatarUrl ?? ''),
              backgroundImage: const AssetImage('assets/images/avatar.png'),
            ),
          ],
        ));
  }
}
