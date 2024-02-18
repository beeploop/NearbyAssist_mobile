import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  const Avatar({super.key, required this.user});

  final String user;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(right: 20),
        child: Row(
          children: [
            Text(user),
            const SizedBox(width: 10),
            const CircleAvatar(
              radius: 16,
              child: Icon(Icons.person),
            ),
          ],
        ));
  }
}
