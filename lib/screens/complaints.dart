import 'package:flutter/material.dart';
import 'package:nearby_assist/widgets/custom_drawer.dart';

class Complaints extends StatelessWidget {
  const Complaints({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: const CustomDrawer(),
      body: const Center(
        child: Text('complaints'),
      ),
    );
  }
}
