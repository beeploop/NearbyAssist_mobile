import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nearby_assist/config/theme/app_colors.dart';
import 'package:nearby_assist/providers/expertise_provider.dart';
import 'package:nearby_assist/providers/search_provider.dart';
import 'package:nearby_assist/providers/service_provider.dart';
import 'package:nearby_assist/utils/show_generic_error_modal.dart';
import 'package:nearby_assist/utils/show_location_disabled_modal.dart';
import 'package:provider/provider.dart';

class CustomSearchbar extends StatefulWidget {
  const CustomSearchbar({super.key, required this.onSearchFinished});

  final void Function() onSearchFinished;

  @override
  State<CustomSearchbar> createState() => _CustomSearchbarState();
}

class _CustomSearchbarState extends State<CustomSearchbar> {
  final _searchController = SearchController();

  @override
  Widget build(BuildContext context) {
    return Consumer2<SearchProvider, ExpertiseProvider>(
      builder: (context, searchProvider, expertiseProvider, child) {
        _searchController.text = searchProvider.latestSearchTerm;

        return SearchAnchor.bar(
          searchController: _searchController,
          isFullScreen: false,
          barHintText: 'search service',
          barElevation: const WidgetStatePropertyAll(4),
          barBackgroundColor: const WidgetStatePropertyAll(AppColors.white),
          viewBackgroundColor: AppColors.white,
          textInputAction: TextInputAction.search,
          onSubmitted: (input) {
            FocusManager.instance.primaryFocus?.unfocus();

            if (_searchController.isOpen) {
              _searchController.closeView(input);
            }

            _handleSearch(input);
          },
          barLeading: searchProvider.searching
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      strokeCap: StrokeCap.round,
                    ),
                  ),
                )
              : Container(),
          suggestionsBuilder: (context, controller) {
            final input = controller.value.text;

            return expertiseProvider.tags
                .where((tag) => tag.contains(input))
                .map((filteredItem) => GestureDetector(
                      onTap: () {
                        _searchController.closeView(filteredItem);
                      },
                      child: ListTile(
                        leading: const Icon(CupertinoIcons.tag),
                        title: Text(filteredItem),
                      ),
                    ));
          },
          barTrailing: [
            IconButton(
              onPressed: () {
                if (_searchController.text.isEmpty) return;

                _handleSearch(_searchController.text);
              },
              icon: const Icon(CupertinoIcons.search),
            ),
          ],
        );
      },
    );
  }

  Future<void> _handleSearch(String searchTerm) async {
    try {
      final serviceProvider = context.read<ServiceProvider>();
      final results = await context.read<SearchProvider>().search(searchTerm);

      serviceProvider.replaceAll(results);

      widget.onSearchFinished();
    } on LocationServiceDisabledException catch (_) {
      if (!mounted) return;
      showLocationDisabledModal(context);
    } on DioException catch (error) {
      if (!mounted) return;
      showGenericErrorModal(context, message: error.response?.data['message']);
    } catch (error) {
      if (!mounted) return;
      showGenericErrorModal(context, message: error.toString());
    }
  }
}
