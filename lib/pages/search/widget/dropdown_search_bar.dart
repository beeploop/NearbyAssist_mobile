import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nearby_assist/config/constants.dart';
import 'package:nearby_assist/providers/location_provider.dart';
import 'package:nearby_assist/providers/search_provider.dart';
import 'package:nearby_assist/services/search_service.dart';
import 'package:nearby_assist/utils/custom_snackbar.dart';
import 'package:provider/provider.dart';

class DropdownSearchBar extends StatefulWidget {
  const DropdownSearchBar({
    super.key,
    required this.onSearchFinished,
  });

  final void Function() onSearchFinished;

  @override
  State<DropdownSearchBar> createState() => _DropdownSearchBarState();
}

class _DropdownSearchBarState extends State<DropdownSearchBar> {
  @override
  Widget build(BuildContext context) {
    final locationProvider = context.watch<LocationProvider>();
    final searchProvider = context.watch<SearchProvider>();

    return Row(
      children: [
        Expanded(
          child: DropdownSearch<String>.multiSelection(
            decoratorProps: const DropDownDecoratorProps(
              decoration: InputDecoration(
                hintText: 'select tags',
              ),
            ),
            popupProps: PopupPropsMultiSelection.modalBottomSheet(
              containerBuilder: (context, child) {
                return Padding(
                  padding: const EdgeInsets.all(10),
                  child: child,
                );
              },
              modalBottomSheetProps: const ModalBottomSheetProps(
                showDragHandle: true,
              ),
              showSearchBox: true,
              showSelectedItems: true,
              searchFieldProps: const TextFieldProps(
                  decoration: InputDecoration(
                hintText: 'filter tags',
              )),
              searchDelay: const Duration(milliseconds: 500),
            ),
            autoValidateMode: AutovalidateMode.always,
            items: (filter, props) => serviceTags,
            selectedItems: searchProvider.tags,
            onChanged: (items) => searchProvider.setTags(items),
          ),
        ),
        FilledButton.icon(
          onPressed: () => _handleSearch(
            locationProvider,
            searchProvider,
          ),
          icon: Provider.of<SearchProvider>(context).isSearching
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                      strokeCap: StrokeCap.round,
                    ),
                  ),
                )
              : const Icon(
                  CupertinoIcons.search,
                  color: Colors.white,
                  size: 18,
                ),
          label: const Text('search'),
        ),
      ],
    );
  }

  Future<void> _handleSearch(
    LocationProvider location,
    SearchProvider searchProvider,
  ) async {
    if (searchProvider.tags.isEmpty) {
      showCustomSnackBar(
        context,
        'select at least 1 service tag',
        backgroundColor: Colors.red,
        textColor: Colors.white,
        closeIconColor: Colors.white,
      );
      return;
    }

    if (searchProvider.isSearching) {
      showCustomSnackBar(context, 'still searching');
      return;
    }

    searchProvider.searching = true;

    try {
      final position = await location.getLocation();

      final service = SearchService();
      final result = await service.findServices(
        userPos: position,
        tags: searchProvider.tags,
      );

      searchProvider.replaceResults(result);

      widget.onSearchFinished();
    } catch (error) {
      if (error == LocationServiceDisabledException) {
        _showLocationServiceDisabledDialog();
        return;
      }

      _showErrorSnackbar(error.toString());
    } finally {
      searchProvider.searching = false;
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

  void _showErrorSnackbar(String error) {
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
