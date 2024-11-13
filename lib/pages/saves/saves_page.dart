import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nearby_assist/models/detailed_service_model.dart';
import 'package:nearby_assist/pages/widget/notification_bell.dart';
import 'package:nearby_assist/providers/saves_provider.dart';
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
    final saves = context.watch<SavesProvider>().getSaves();

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
      body: RefreshIndicator(
        onRefresh: context.read<SavesProvider>().refetchSaves,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: saves.isEmpty ? _emptyState() : _buildSaves(saves),
        ),
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

  Widget _emptyState() {
    return ListView(
      children: [
        SingleChildScrollView(
          child: Container(
            alignment: Alignment.center,
            height: MediaQuery.of(context).size.height,
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  CupertinoIcons.tray,
                  color: Colors.grey,
                ),
                SizedBox(height: 10),
                Text(
                  'No saves',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
