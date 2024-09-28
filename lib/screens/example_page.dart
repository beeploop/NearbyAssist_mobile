import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:nearby_assist/request/dio_request.dart';
import 'package:nearby_assist/services/diffie_hellman.dart';

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
                  //final response = await request.get("/api/v1/health/protected");
                  final dh = DiffieHellman();
                  final pubKey = await dh.getPublicKey("uGVlglh3uiISb4y_HgdER");
                  final secret = await dh.computeSharedSecret(pubKey);
                  setState(() {
                    //_response = getPrettyJSONString(response.data);
                    _response = secret.toString();
                  });
                } catch (e) {
                  debugPrint(e.toString());
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
