import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPage();
}

class _SearchPage extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(CupertinoIcons.bell),
            onPressed: () {},
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            _searchBar(),
            Expanded(
              child: Image.asset(
                'assets/images/visualization.png',
                width: 200,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _searchBar() {
    return Row(children: [
      Expanded(
        child: TextField(
          onTapOutside: (event) {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          decoration: const InputDecoration(
            hintText: 'Search',
            border: OutlineInputBorder(),
          ),
        ),
      ),
      IconButton(
        icon: const Icon(CupertinoIcons.search),
        onPressed: () => context.pushNamed('map'),
      ),
    ]);
  }
}
