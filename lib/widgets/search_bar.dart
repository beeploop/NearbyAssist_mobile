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
        color: Colors.white.withOpacity(0.8),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            Expanded(
              child: Form(
                child: TextFormField(
                  onTapOutside: (_) {
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  controller: _searchController,
                  decoration: const InputDecoration(hintText: 'search service'),
                ),
              ),
            ),
            SizedBox(
              width: 50,
              child: IconButton(
                onPressed: () {
                  FocusManager.instance.primaryFocus?.unfocus();
                  getIt.get<SearchingService>().searchService(
                        context,
                        _searchController.text,
                      );
                },
                icon: const Icon(Icons.search),
              ),
            ),
          ],
        ));
  }
}
