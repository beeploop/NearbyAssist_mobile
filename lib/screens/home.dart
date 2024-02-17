import 'package:flutter/material.dart';
import 'package:nearby_assist/controller/auth_controller.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/model/auth_model.dart';
import 'package:nearby_assist/widgets/search_service.dart';

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
      drawer: SafeArea(
        child: Drawer(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            children: [
              _drawerHeader(),
              ..._drawerItems(),
            ],
          ),
        ),
      ),
      body: const Center(
        child: Column(
          children: [
            ServiceSearch(),
          ],
        ),
      ),
    );
  }

  List<Widget> _drawerItems() {
    List<Widget> items = [];

    for (var item in drawerItems) {
      items.add(ListTile(
        onTap: () {
          debugPrint('clicked ${item['title']}');
        },
        title: Text(item['title']),
        leading: Icon(item['icon'] as IconData, size: 20),
      ));
    }

    items.add(const Divider());
    items.add(
      ListTile(
        onTap: () {
          debugPrint('logout');
          AuthController.logout();
        },
        leading: const Icon(Icons.logout_outlined, color: Colors.red),
        title: const Text(
          'Logout',
          style: TextStyle(color: Colors.red),
        ),
      ),
    );

    return items;
  }

  Widget _drawerHeader() {
    return DrawerHeader(
      child: Column(
        children: [
          const CircleAvatar(
            radius: 30,
            child: Icon(Icons.person),
          ),
          Text(
            getIt.get<AuthModel>().getUser()!.name,
            style: const TextStyle(fontSize: 20),
          )
        ],
      ),
    );
  }
}
