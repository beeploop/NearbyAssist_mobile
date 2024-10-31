import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Profile',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: CircleAvatar(
                  radius: 70,
                  foregroundImage: const NetworkImage(""),
                  backgroundImage: const AssetImage('assets/images/avatar.png'),
                  backgroundColor: Colors.green[800],
                ),
              ),
            ),
            IconButton(
              icon: const Icon(CupertinoIcons.checkmark_seal),
              onPressed: () => context.pushNamed('verifyAccount'),
            ),
            const Text("user name"),
          ],
        ),
      ),
    );
  }
}
