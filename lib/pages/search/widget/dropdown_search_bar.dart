import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nearby_assist/config/constants.dart';
import 'package:nearby_assist/pages/search/widget/dropdown_search_bar_controller.dart';
import 'package:nearby_assist/providers/location_provider.dart';
import 'package:nearby_assist/utils/custom_snackbar.dart';
import 'package:provider/provider.dart';

class DropdownSearchBar extends StatefulWidget {
  const DropdownSearchBar({
    super.key,
    required this.onSearchFinished,
    required this.controller,
  });

  final void Function() onSearchFinished;
  final DropdownSearchBarController controller;

  @override
  State<DropdownSearchBar> createState() => _DropdownSearchBarState();
}

class _DropdownSearchBarState extends State<DropdownSearchBar> {
  @override
  Widget build(BuildContext context) {
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
            selectedItems: widget.controller.selectedTags,
            onChanged: (items) => widget.controller.replaceAll(items),
          ),
        ),
        FilledButton.icon(
          onPressed: _handleSearch,
          icon: widget.controller.isSearching
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

  Future<void> _handleSearch() async {
    if (widget.controller.isSearching) {
      showCustomSnackBar(context, 'still searching');
      return;
    }

    setState(() {
      widget.controller.toggleSearching();
    });

    try {
      await context.read<LocationProvider>().getLocation();

      widget.onSearchFinished();
    } catch (error) {
      if (error == LocationServiceDisabledException) {
        _showLocationServiceDisabledDialog();
        return;
      }

      _showErrorSnackbar(error.toString());
    } finally {
      setState(() {
        widget.controller.toggleSearching();
      });
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
