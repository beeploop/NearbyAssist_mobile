import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OngoingTransactionPage extends StatelessWidget {
  const OngoingTransactionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Ongoing Transaction',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: const Center(
        child: Column(
          children: [
            Icon(CupertinoIcons.arrow_clockwise_circle),
            Text('Ongoing Transaction Page'),
          ],
        ),
      ),
    );
  }
}
