import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nearby_assist/models/recommendation_model.dart';
import 'package:nearby_assist/pages/search/widget/custom_searchbar.dart';
import 'package:nearby_assist/pages/search/widget/popular_search_chip.dart';
import 'package:nearby_assist/pages/search/widget/recommendation_item.dart';
import 'package:nearby_assist/pages/widget/notification_bell.dart';
import 'package:nearby_assist/providers/recommendation_provider.dart';
import 'package:nearby_assist/providers/search_provider.dart';
import 'package:provider/provider.dart';

class SearchPageV1 extends StatefulWidget {
  const SearchPageV1({super.key});

  @override
  State<SearchPageV1> createState() => _SearchPageV1State();
}

class _SearchPageV1State extends State<SearchPageV1> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Remove focus from the searchbar
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          actions: const [
            NotificationBell(),
            SizedBox(width: 10),
          ],
        ),
        body: Consumer<RecommendationProvider>(
          builder: (context, provider, _) {
            return FutureBuilder(
              future: provider.fetchRecommendations(),
              builder: (context, snapshot) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomSearchbar(
                          onSearchFinished: () => context.pushNamed('map'),
                        ),
                        const SizedBox(height: 20),

                        // Searches
                        const AutoSizeText(
                          'Popular Searches',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        _popularSearches(provider.popularSearches),
                        const SizedBox(height: 20),

                        // Services
                        const AutoSizeText(
                          'Services',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),

                        snapshot.connectionState == ConnectionState.waiting
                            ? const Center(child: CircularProgressIndicator())
                            : GridView(
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 10,
                                  crossAxisSpacing: 10,
                                ),
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                padding: const EdgeInsets.all(4),
                                children: _buildRecommendations(
                                    provider.recommendations),
                              ),

                        // Bottom padding
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  List<Widget> _buildRecommendations(
      List<RecommendationModel> recommendations) {
    return recommendations
        .map((recommendation) => RecommendationItem(
              data: recommendation,
              onPressed: () => context.pushNamed(
                'viewService',
                queryParameters: {'serviceId': recommendation.id},
              ),
            ))
        .toList();
  }

  Widget _popularSearches(List<String> popularSearches) {
    final searchProvider = context.read<SearchProvider>();

    return Wrap(
      spacing: 6,
      children: popularSearches
          .map((item) => PopularSearchChip(
                label: item,
                onPressed: () {
                  searchProvider.search(item);
                  context.pushNamed('map');
                },
              ))
          .toList(),
    );
  }
}
