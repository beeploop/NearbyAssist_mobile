import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:nearby_assist/request/dio_request.dart';
import 'package:nearby_assist/services/logger_service.dart';

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
                  final response =
                      await request.get("/api/v1/health/protected");

                  setState(() {
                    _response = getPrettyJSONString(response.data);
                  });
                } catch (e) {
                  ConsoleLogger().log(e.toString());
                }
              },
              child: const Text('Run'),
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
