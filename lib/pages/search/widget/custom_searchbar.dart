import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nearby_assist/providers/expertise_provider.dart';
import 'package:nearby_assist/providers/search_provider.dart';
import 'package:nearby_assist/providers/service_provider.dart';
import 'package:nearby_assist/utils/custom_snackbar.dart';
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
          barBackgroundColor: const WidgetStatePropertyAll(Colors.white),
          viewBackgroundColor: Colors.white,
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
              : const Icon(
                  CupertinoIcons.search,
                  size: 20,
                ),
          suggestionsBuilder: (context, controller) {
            final input = controller.value.text;

            return expertiseProvider
                .getAllTags()
                .where((tag) => tag.title.contains(input))
                .map((filteredItem) => GestureDetector(
                      onTap: () {
                        _searchController.closeView(filteredItem.title);
                      },
                      child: ListTile(
                        leading: const Icon(CupertinoIcons.tag),
                        title: Text(filteredItem.title),
                      ),
                    ));
          },
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
    } on DioException catch (error) {
      _showErrorModal(error.response?.data['message']);
    } on LocationServiceDisabledException catch (_) {
      _showLocationServiceDisabledDialog();
    } catch (error) {
      _showErrorModal(error.toString());
    }
  }

  void _showLocationServiceDisabledDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Location Services Disabled'),
          content: const Text(
            'Please enable location services to use this feature.',
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                await Geolocator.openLocationSettings();
              },
              child: const Text('Open Settings'),
            ),
          ],
        );
      },
    );
  }

  void _showErrorModal(String error) {
    showCustomSnackBar(
      context,
      error,
      duration: const Duration(seconds: 5),
      backgroundColor: Colors.red,
      closeIconColor: Colors.white,
      textColor: Colors.white,
    );
  }
}
