import 'package:flutter/material.dart';
import 'package:nearby_assist/pages/search/widget/custom_map.dart';
import 'package:nearby_assist/pages/search/widget/dropdown_search_bar.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
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
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("clicked search")),
    );
  }
}
