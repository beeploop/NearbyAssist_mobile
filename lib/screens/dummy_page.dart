import 'package:flutter/material.dart';

class DummyPage extends StatelessWidget {
  const DummyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Dummy Page',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: const [
            Text('Dummy Page'),
          ],
        ),
      ),
    );
  }
}
