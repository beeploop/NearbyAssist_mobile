import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nearby_assist/models/service_model.dart';
import 'package:nearby_assist/pages/widget/notification_bell.dart';
import 'package:nearby_assist/providers/saves_provider.dart';
import 'package:provider/provider.dart';

class SavesPage extends StatefulWidget {
  const SavesPage({super.key});

  @override
  State<SavesPage> createState() => _SavesPageState();
}

class _SavesPageState extends State<SavesPage> {
  @override
  Widget build(BuildContext context) {
    final saves = context.watch<SavesProvider>().saves;

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
        child: saves.isEmpty ? _buildEmptySaves() : _buildSaves(saves),
      ),
    );
  }

  Widget _buildSaves(List<ServiceModel> saves) {
    return ListView.builder(
      itemCount: saves.length,
      itemBuilder: (context, index) => ListTile(
        onTap: () => context.pushNamed(
          'viewService',
          queryParameters: {'serviceId': saves[index].id},
        ),
        title: Text(saves[index].description),
      ),
    );
  }

  Widget _buildEmptySaves() {
    return const Center(
      child: Text('No saved items'),
    );
  }
}
