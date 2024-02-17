import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nearby_assist/controller/auth_controller.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/model/auth_model.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawer();
}

class _CustomDrawer extends State<CustomDrawer> {
  List<Map> drawerItems = [
    {'title': 'search', 'dist': 'home', 'icon': Icons.search},
    {'title': 'messages', 'dist': 'messages', 'icon': Icons.message_outlined},
    {
      'title': 'in-progress',
      'dist': 'in-progress',
      'icon': Icons.av_timer_outlined
    },
    {'title': 'history', 'dist': 'history', 'icon': Icons.history},
    {
      'title': 'complaints',
      'dist': 'complaints',
      'icon': Icons.feedback_outlined
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          children: [
            _drawerHeader(),
            ..._drawerItems(),
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
          context.goNamed(item['dist']);
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
          AuthController.logout(context);
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
