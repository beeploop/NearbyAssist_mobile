import 'package:flutter/material.dart';

class ServiceSearch extends StatefulWidget {
  const ServiceSearch({super.key});

  @override
  State<ServiceSearch> createState() => _ServiceSearch();
}

class _ServiceSearch extends State<ServiceSearch> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Form(
              child: TextFormField(
                controller: _searchController,
                decoration: const InputDecoration(hintText: 'search service'),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                FocusManager.instance.primaryFocus?.unfocus();
                _handleSearch();
              },
              child: const Text('search'),
            ),
          ],
        ));
  }

  void _handleSearch() {
    if (_searchController.text.isEmpty) {
      return;
    }

    debugPrint(_searchController.value.text);
  }
}
