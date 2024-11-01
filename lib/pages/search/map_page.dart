import 'package:flutter/material.dart';
import 'package:nearby_assist/pages/search/widget/custom_map.dart';
import 'package:nearby_assist/pages/search/widget/dropdown_search_bar.dart';
import 'package:nearby_assist/pages/widget/notification_bell.dart';
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
      appBar: AppBar(
        actions: const [
          NotificationBell(),
          SizedBox(width: 10),
        ],
      ),
      body: Stack(
        children: [
          const CustomMap(),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(color: Colors.white60),
              child: DropdownSearchBar(
                onSearch: _handleSearch,
              ),
            ),
          ),
        ],
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
