import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nearby_assist/pages/search/widget/dropdown_search_bar.dart';
import 'package:nearby_assist/pages/widget/notification_bell.dart';

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
        actions: const [
          NotificationBell(),
          SizedBox(width: 10),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            DropdownSearchBar(
              onSearch: () => context.pushNamed('map'),
            ),
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
}