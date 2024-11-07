import 'dart:math';

import 'package:flutter/material.dart';
import 'package:nearby_assist/config/constants.dart';
import 'package:nearby_assist/models/service_model.dart';
import 'package:nearby_assist/pages/search/widget/custom_map.dart';
import 'package:nearby_assist/pages/search/widget/dropdown_search_bar.dart';
import 'package:nearby_assist/pages/search/widget/dropdown_search_bar_controller.dart';
import 'package:nearby_assist/providers/services_provider.dart';
import 'package:nearby_assist/utils/custom_snackbar.dart';
import 'package:provider/provider.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final _searchController = DropdownSearchBarController();

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
                  controller: _searchController,
                  onSearchFinished: _handleSearch,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleSearch() {
    final List<ServiceModel> newServices = [
      testLocations[Random().nextInt(testLocations.length - 1)],
      testLocations[Random().nextInt(testLocations.length - 1)],
    ];

    context.read<ServicesProvider>().replaceAll(newServices);

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
