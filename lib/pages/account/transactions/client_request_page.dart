import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ClientRequestPage extends StatelessWidget {
  const ClientRequestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Client Request',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: const Center(
        child: Column(
          children: [
            Icon(CupertinoIcons.arrow_down_circle),
            Text('Client Request Page'),
          ],
        ),
      ),
    );
  }
}
