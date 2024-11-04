import 'package:flutter/material.dart';
import 'package:nearby_assist/config/constants.dart';
import 'package:nearby_assist/pages/search/widget/custom_map.dart';
import 'package:nearby_assist/pages/search/widget/dropdown_search_bar.dart';
import 'package:nearby_assist/utils/custom_snackbar.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            const CustomMap(
              coordinates: [testLocation],
            ),
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
                  onSearch: _handleSearch,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleSearch() {
    showCustomSnackBar(
      context,
      "clicked search",
      textColor: Colors.white,
      backgroundColor: Colors.green[400],
      closeIconColor: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }
}
