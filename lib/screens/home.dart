import 'package:flutter/material.dart';
import 'package:nearby_assist/controller/auth_controller.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/model/auth_model.dart';

class Homapage extends StatefulWidget {
  const Homapage({super.key});

  @override
  State<Homapage> createState() => _Homepage();
}

class _Homepage extends State<Homapage> {
  final userInfo = getIt.get<AuthModel>().getUser();
  List<Map> drawerItems = [
    {'title': 'search', 'icon': Icons.search},
    {'title': 'messages', 'icon': Icons.message_outlined},
    {'title': 'in-progress', 'icon': Icons.av_timer_outlined},
    {'title': 'history', 'icon': Icons.history},
    {'title': 'complaints', 'icon': Icons.feedback_outlined},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Row(
                children: [
                  Text(userInfo!.name),
                  const SizedBox(width: 10),
                  const CircleAvatar(
                    radius: 16,
                    child: Icon(Icons.person),
                  ),
                ],
              ))
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          children: _drawerItems(),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            const Text('main page'),
            Text(userInfo!.name),
            ElevatedButton(
              onPressed: () {
                AuthController.logout();
              },
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _drawerItems() {
    List<Widget> items = [];

    for (var item in drawerItems) {
      items.add(GestureDetector(
        onTap: () {
          debugPrint('clicked $item');
        },
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              Icon(item['icon'] as IconData, size: 20),
              const SizedBox(width: 10),
              Text(item['title']),
            ],
          ),
        ),
      ));
    }

    return items;
  }
}
