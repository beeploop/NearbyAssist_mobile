import 'package:dio/dio.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nearby_assist/providers/expertise_provider.dart';
import 'package:nearby_assist/providers/search_provider.dart';
import 'package:nearby_assist/providers/service_provider.dart';
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
    final tags = context.watch<ExpertiseProvider>().getAllTags();

    return Consumer<SearchProvider>(
      builder: (context, search, child) {
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
                items: (filter, props) => tags.map((tag) => tag.title).toList(),
                selectedItems: search.queries,
                onChanged: (tags) => search.setQueries(tags),
              ),
            ),
            FilledButton.icon(
              onPressed: _handleSearch,
              icon: search.searching
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
      },
    );
  }

  Future<void> _handleSearch() async {
    try {
      final serviceProvider = context.read<ServiceProvider>();
      final services = await context.read<SearchProvider>().search();

      serviceProvider.replaceAll(services);

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
