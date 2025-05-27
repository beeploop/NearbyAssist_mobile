import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nearby_assist/config/assets.dart';
import 'package:nearby_assist/models/recommendation_model.dart';
import 'package:nearby_assist/pages/search/widget/custom_searchbar.dart';
import 'package:nearby_assist/pages/search/widget/popular_search_chip.dart';
import 'package:nearby_assist/pages/search/widget/recommendation_item.dart';
import 'package:nearby_assist/pages/widget/notification_bell.dart';
import 'package:nearby_assist/providers/message_provider.dart';
import 'package:nearby_assist/providers/recommendation_provider.dart';
import 'package:nearby_assist/providers/search_provider.dart';
import 'package:nearby_assist/providers/service_provider.dart';
import 'package:nearby_assist/utils/custom_snackbar.dart';
import 'package:provider/provider.dart';

class SearchPageV2 extends StatefulWidget {
  const SearchPageV2({super.key});

  @override
  State<SearchPageV2> createState() => _SearchPageV2State();
}

class _SearchPageV2State extends State<SearchPageV2> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MessageProvider>(context, listen: false).refreshInbox();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Remove focus from the searchbar
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        body: SafeArea(
          child: Consumer<RecommendationProvider>(
            builder: (context, provider, _) {
              return FutureBuilder(
                future: provider.fetchRecommendations(),
                builder: (context, snapshot) {
                  return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),

                        // Welcome message
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Hello!',
                              style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green.shade900),
                            ),
                            const NotificationBell(),
                          ],
                        ),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Welcome to NearbyAssist',
                                style: TextStyle(color: Colors.green.shade900),
                              ),
                              const WidgetSpan(
                                child: Icon(
                                  CupertinoIcons.location_solid,
                                  color: Colors.red,
                                  size: 16,
                                ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),

                        CustomSearchbar(
                          onSearchFinished: () {
                            final services =
                                context.read<ServiceProvider>().services;
                            if (services.isEmpty) {
                              showCustomSnackBar(
                                context,
                                '0 services found',
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                closeIconColor: Colors.white,
                                dismissable: true,
                                duration: const Duration(seconds: 3),
                              );
                            }
                            context.pushNamed('map');
                          },
                        ),
                        const SizedBox(height: 30),

                        // Searches
                        const AutoSizeText(
                          'Popular Searches',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        _popularSearches(provider.popularSearches),
                        const SizedBox(height: 20),

                        // Banner
                        _banner(),
                        const SizedBox(height: 20),

                        // Services
                        const AutoSizeText(
                          'Recommended Services',
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
                  );
                },
              );
            },
          ),
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

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: popularSearches
            .map((item) => PopularSearchChip(
                  label: item,
                  onPressed: () {
                    searchProvider.search(item);
                    context.pushNamed('map');
                  },
                ))
            .toList(),
      ),
    );
  }

  Widget _banner() {
    const height = 130.0;

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Colors.green.shade700,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(14),
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.6,
              child: const Text(
                'What service are you looking for today?',
                style: TextStyle(
                  fontSize: 28,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 8,
            right: 8,
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.2,
              child: Image.asset(
                Assets.visualization,
                width: MediaQuery.of(context).size.width * 0.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
