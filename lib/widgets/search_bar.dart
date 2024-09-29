import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/services/search_service.dart';

class ServiceSearchBar extends StatefulWidget {
  const ServiceSearchBar({super.key});

  @override
  State<ServiceSearchBar> createState() => _ServiceSearchBar();
}

class _ServiceSearchBar extends State<ServiceSearchBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white.withOpacity(0.8),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            Expanded(
              child: ListenableBuilder(
                listenable: getIt.get<SearchingService>(),
                builder: (context, widget) {
                  final tags = getIt.get<SearchingService>().getTags();

                  return Form(
                    child: DropdownSearch<String>.multiSelection(
                      dropdownDecoratorProps: const DropDownDecoratorProps(
                        dropdownSearchDecoration: InputDecoration(
                          hintText: 'search service tag',
                        ),
                      ),
                      items: [...tags],
                      onChanged: getIt.get<SearchingService>().addSelectedTag,
                      selectedItems: [
                        ...getIt.get<SearchingService>().getSelectedTags()
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 10),
            ListenableBuilder(
              listenable: getIt.get<SearchingService>(),
              builder: (context, _) {
                final searching = getIt.get<SearchingService>().isSearching();

                return SizedBox(
                  child: FilledButton(
                    onPressed: () async {
                      FocusManager.instance.primaryFocus?.unfocus();
                      try {
                        await getIt.get<SearchingService>().searchService();
                        if (context.mounted) {
                          context.goNamed('map');
                        }
                      } catch (err) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(err.toString()),
                            ),
                          );
                        }
                      }
                    },
                    child: searching
                        ? const Center(
                            widthFactor: 0,
                            child: SizedBox(
                              width: 14,
                              height: 14,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            ),
                          )
                        : const Text('Search'),
                  ),
                );
              },
            ),
          ],
        ));
  }
}
