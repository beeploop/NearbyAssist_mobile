import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nearby_assist/request/dio_request.dart';

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
      body: Center(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            FilledButton(
              onPressed: () async {
                try {
                  final response = await request.get("/backend/v1/health");
                  setState(() {
                    _response = getPrettyJSONString(response.data);
                  });
                } catch (e) {
                  debugPrint(e.toString());
                }
              },
              child: const Text('Backend Connection Check'),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
              child: Text(_response),
            ),
          ],
        ),
      ),
    );
  }

  String getPrettyJSONString(jsonObject) {
    var encoder = const JsonEncoder.withIndent("     ");
    return encoder.convert(jsonObject);
  }
}
