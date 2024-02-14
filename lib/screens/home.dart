import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Homapage extends StatefulWidget {
  const Homapage({super.key});

  @override
  State<Homapage> createState() => _Homepage();
}

class _Homepage extends State<Homapage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Main Page')),
      body: Center(
        child: Column(
          children: [
            const Text('main page'),
            ElevatedButton(
              onPressed: () {
                context.goNamed('login');
              },
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
