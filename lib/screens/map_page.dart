import 'package:flutter/material.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/model/auth_model.dart';
import 'package:nearby_assist/widgets/avatar.dart';
import 'package:nearby_assist/widgets/map.dart';
import 'package:nearby_assist/widgets/search_bar.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPage();
}

class _MapPage extends State<MapPage> {
  final userInfo = getIt.get<AuthModel>().getUser();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [Avatar(user: userInfo!.name)],
      ),
      body: const Stack(
        children: [
          CustomMap(),
          Align(
            alignment: Alignment.topLeft,
            child: ServiceSearchBar(),
          ),
        ],
      ),
    );
  }
}
