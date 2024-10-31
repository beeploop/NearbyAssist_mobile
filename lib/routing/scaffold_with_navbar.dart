import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ScaffoldWithNavBar extends StatelessWidget {
  const ScaffoldWithNavBar({
    required this.navigationShell,
    Key? key,
  }) : super(key: key ?? const ValueKey<String>('ScaffoldWithNavBar'));

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
            ),
          ],
        ),
        child: BottomNavigationBar(
          unselectedItemColor: Colors.black54,
          selectedItemColor: Colors.green,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              activeIcon: Icon(CupertinoIcons.house_fill),
              icon: Icon(CupertinoIcons.house),
              label: 'home',
            ),
            BottomNavigationBarItem(
              activeIcon: Icon(CupertinoIcons.compass_fill),
              icon: Icon(CupertinoIcons.compass),
              label: 'search',
            ),
            BottomNavigationBarItem(
              activeIcon: Icon(CupertinoIcons.text_bubble_fill),
              icon: Icon(CupertinoIcons.text_bubble),
              label: 'message',
            ),
            BottomNavigationBarItem(
              activeIcon: Icon(CupertinoIcons.person_fill),
              icon: Icon(CupertinoIcons.person),
              label: 'account',
            ),
          ],
          currentIndex: navigationShell.currentIndex,
          onTap: (int index) => _onTap(context, index),
        ),
      ),
    );
  }

  // Navigate to initial route if the current index is already active
  void _onTap(BuildContext context, int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}
