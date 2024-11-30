import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyRequestPage extends StatelessWidget {
  const MyRequestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'My Request',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: const Center(
        child: Column(
          children: [
            Icon(CupertinoIcons.arrow_up_circle),
            Text('My Request Page'),
          ],
        ),
      ),
    );
  }
}
