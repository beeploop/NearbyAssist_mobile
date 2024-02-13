import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/models/auth_model.dart';

class Homapage extends ConsumerStatefulWidget {
  const Homapage({super.key});

  @override
  ConsumerState<Homapage> createState() => _Homepage();
}

class _Homepage extends ConsumerState<Homapage> {
  @override
  void initState() {
    super.initState();

    final isLoggedIn = ref.read(authProvider).getLoginStatus();

    if (isLoggedIn == false) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    UserInfo userInfo = ref.watch(authProvider).getUserInfo();

    return Scaffold(
      appBar: AppBar(title: const Text('Main Page')),
      body: Center(
        child: Column(
          children: [
            const Text('main page'),
            Text(userInfo.name),
            ElevatedButton(
              onPressed: () {
                ref.invalidate(authProvider);
                Navigator.pushReplacementNamed(context, '/login');
              },
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
