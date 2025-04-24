import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nearby_assist/models/detailed_service_model.dart';
import 'package:nearby_assist/pages/saves/widget/save_list_item.dart';
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
    final displayable =
        saves.where((model) => !model.service.disabled).toList();

    return ListView.separated(
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemCount: displayable.length,
      itemBuilder: (context, index) {
        final model = displayable[index];
        return SaveListItem(service: model.service);
      },
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
