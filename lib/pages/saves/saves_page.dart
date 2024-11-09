import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nearby_assist/models/detailed_service_model.dart';
import 'package:nearby_assist/pages/widget/notification_bell.dart';
import 'package:nearby_assist/providers/saved_service_provider.dart';
import 'package:nearby_assist/utils/random_color.dart';
import 'package:provider/provider.dart';

class SavesPage extends StatefulWidget {
  const SavesPage({super.key});

  @override
  State<SavesPage> createState() => _SavesPageState();
}

class _SavesPageState extends State<SavesPage> {
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
      body: Consumer<SavedServiceProvider>(
        builder: (context, saves, child) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: saves.getSaves().isEmpty
                ? _buildEmptySaves()
                : _buildSaves(saves.getSaves()),
          );
        },
      ),
    );
  }

  Widget _buildSaves(List<DetailedServiceModel> saves) {
    return ListView.builder(
      itemCount: saves.length,
      itemBuilder: (context, index) => ListTile(
        onTap: () => context.pushNamed(
          'viewService',
          queryParameters: {'serviceId': saves[index].service.id},
        ),
        leading: CircleAvatar(
          backgroundColor: getRandomColor(),
          radius: 30,
          child: CircleAvatar(
            radius: 27,
            backgroundImage: NetworkImage(saves[index].vendor.imageUrl),
          ),
        ),
        title: Text(saves[index].vendor.name),
        subtitle: Text(saves[index].service.description),
      ),
    );
  }

  Widget _buildEmptySaves() {
    return const Center(
      child: Text('No saved items'),
    );
  }
}
