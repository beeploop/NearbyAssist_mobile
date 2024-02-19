import 'package:flutter/material.dart';
import 'package:nearby_assist/widgets/custom_drawer.dart';

class MyServices extends StatefulWidget {
  const MyServices({super.key});

  @override
  State<MyServices> createState() => _MyServices();
}

class _MyServices extends State<MyServices> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: const CustomDrawer(),
      body: const Center(
        child: Text('services'),
      ),
    );
  }
}
