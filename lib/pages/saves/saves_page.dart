import 'package:flutter/material.dart';
import 'package:nearby_assist/pages/widget/notification_bell.dart';

class SavesPage extends StatefulWidget {
  const SavesPage({super.key});

  @override
  State<SavesPage> createState() => _SavesPageState();
}

class _SavesPageState extends State<SavesPage> {
  final List<String> _saves = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Saves',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: const [
          NotificationBell(),
          SizedBox(width: 10),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: _saves.isEmpty ? _buildEmptySaves() : _buildSaves(),
      ),
    );
  }

  Widget _buildSaves() {
    return const Column(
      children: [
        Text('bookmark page'),
      ],
    );
  }

  Widget _buildEmptySaves() {
    return const Center(
      child: Text('No saved items'),
    );
  }
}
