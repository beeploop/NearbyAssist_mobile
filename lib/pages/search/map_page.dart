import 'package:flutter/material.dart';
import 'package:nearby_assist/pages/search/widget/custom_map.dart';
import 'package:nearby_assist/pages/search/widget/custom_searchbar.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Stack(
          children: [
            const CustomMap(),
            Positioned(
              top: 20,
              left: 20,
              right: 20,
              child: CustomSearchbar(
                onSearchFinished: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
