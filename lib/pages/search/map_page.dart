import 'package:flutter/material.dart';
import 'package:nearby_assist/pages/search/widget/custom_map.dart';
import 'package:nearby_assist/pages/search/widget/dropdown_search_bar.dart';
import 'package:nearby_assist/utils/custom_snackbar.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            const CustomMap(),
            Positioned(
              top: 20,
              left: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: DropdownSearchBar(
                  onSearchFinished: () => _handleSearch(context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleSearch(BuildContext context) {
    showCustomSnackBar(
      context,
      'showing new results',
    );
  }
}
