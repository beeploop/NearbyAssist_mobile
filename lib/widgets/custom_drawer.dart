import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nearby_assist/services/auth_service.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/model/auth_model.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawer();
}

class _CustomDrawer extends State<CustomDrawer> {
  final avatarUrl = getIt.get<AuthModel>().getUser().image;

  List<Map> drawerItems = [
    {
      'title': 'search',
      'dist': 'home',
      'icon': Icons.search,
    },
    {
      'title': 'messages',
      'dist': 'messages',
      'icon': Icons.message_outlined,
    },
    {
      'title': 'transaction',
      'dist': 'transaction',
      'icon': Icons.av_timer_outlined,
    },
    {
      'title': 'history',
      'dist': 'history',
      'icon': Icons.history,
    },
    {
      'title': 'complaints',
      'dist': 'complaints',
      'icon': Icons.feedback_outlined,
    },
    {
      'title': 'report',
      'dist': 'report',
      'icon': Icons.feedback_outlined,
    },
    {
      'title': 'verify identity',
      'dist': 'verify-identity',
      'icon': Icons.perm_identity_outlined,
    },
    {
      'title': 'offer a service',
      'dist': 'my-services',
      'icon': Icons.hardware_outlined,
    },
    {
      'title': 'settings',
      'dist': 'settings',
      'icon': Icons.settings_outlined,
    },
    {
      'title': 'example',
      'dist': 'example',
      'icon': Icons.question_mark_outlined,
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
            ..._drawerItems(context),
          ],
        ),
      ),
    );
  }

  List<Widget> _drawerItems(BuildContext context) {
    List<Widget> items = [];

    for (var item in drawerItems) {
      items.add(ListTile(
        onTap: () {
          context.goNamed(item['dist']);
        },
        title: Text(item['title']),
        leading: Icon(item['icon'] as IconData, size: 20),
      ));
    }

    items.add(const Divider());
    items.add(
      ListTile(
        onTap: () async {
          try {
            await AuthService.logout();

            if (context.mounted) {
              context.goNamed('login');
            }
          } catch (e) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Error logging out. Error: ${e.toString()}',
                  ),
                ),
              );
            }
          }
        },
        leading: const Icon(Icons.logout_outlined, size: 20, color: Colors.red),
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
          CircleAvatar(
            radius: 30,
            foregroundImage: NetworkImage(avatarUrl),
            onForegroundImageError: (object, stacktrace) {
              debugPrint('Error loading network image for custom drawer');
            },
            backgroundImage: const AssetImage('assets/images/avatar.png'),
          ),
          Text(
            getIt.get<AuthModel>().getUser().name,
            style: const TextStyle(fontSize: 20),
          )
        ],
      ),
    );
  }
}
