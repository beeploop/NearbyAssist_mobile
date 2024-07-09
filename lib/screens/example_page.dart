import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/model/tag_model.dart';
import 'package:nearby_assist/request/dio_request.dart';
import 'package:nearby_assist/services/storage_service.dart';
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
                  final response =
                      await request.get("/backend/v1/public/example");
                  setState(() {
                    _response = response.data;
                  });
                } catch (e) {
                  debugPrint(e.toString());
                }
              },
              child: const Text('backend health check'),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  final response = await request.get("/backend/v1/public/tags");
                  List data = response.data['tags'];
                  final tags = data.map((element) {
                    return TagModel.fromJson(element);
                  }).toList();

                  getIt.get<StorageService>().saveTags(tags);
                  getIt.get<StorageService>().loadData();
                } catch (e) {
                  debugPrint(e.toString());
                }
              },
              child: const Text('update tags'),
            ),
          ],
        ),
      ),
    );
  }
}
