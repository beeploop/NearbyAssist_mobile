import 'package:flutter/material.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/services/search_service.dart';

class ServiceSearchBar extends StatefulWidget {
  const ServiceSearchBar({super.key});

  @override
  State<ServiceSearchBar> createState() => _ServiceSearchBar();
}

class _ServiceSearchBar extends State<ServiceSearchBar> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _searchController.text = getIt.get<SearchingService>().lastSearch();

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
                getIt.get<SearchingService>().searchService(
                      context,
                      _searchController.text,
                    );
              },
              child: const Text('search'),
            ),
          ],
        ));
  }
}
