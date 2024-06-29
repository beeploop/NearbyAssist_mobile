import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nearby_assist/request/dio_request.dart';
import 'package:nearby_assist/widgets/custom_drawer.dart';

class ExamplePage extends StatefulWidget {
  const ExamplePage({super.key});

  @override
  State<ExamplePage> createState() => _ExamplePageState();
}

class _ExamplePageState extends State<ExamplePage> {
  String _response = 'response will appear here';
  DioRequest request = DioRequest();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: const CustomDrawer(),
      body: Center(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(_response, style: const TextStyle(fontSize: 20)),
            ElevatedButton(
              onPressed: () async {
                try {
                  final response = await request.get("/backend/health");
                  setState(() {
                    _response = jsonEncode(response.data);
                  });
                } catch (e) {
                  print(e);
                }
              },
              child: const Text('click'),
            ),
          ],
        ),
      ),
    );
  }
}
