import 'package:flutter/material.dart';
import 'package:nearby_assist/main.dart';

class TesterSettingsModal extends StatelessWidget {
  const TesterSettingsModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _disclaimer(),
          Text('API Endpoint: ${endpoint.baseUrl}'),
        ],
      ),
    );
  }

  Widget _disclaimer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Tester Settings",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          "This option is only available in test flavors of the app. Features and functionality are subject to change and may not be available in the final release.",
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}
