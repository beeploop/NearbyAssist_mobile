import 'package:flutter/material.dart';
import 'package:nearby_assist/widgets/search_bar.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPage();
}

class _MapPage extends State<MapPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Column(
        children: [
          ServiceSearchBar(),
          Text('Map view'),
        ],
      ),
    );
  }
}
