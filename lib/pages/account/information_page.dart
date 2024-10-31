import 'package:flutter/material.dart';
import 'package:nearby_assist/config/constants.dart';
import 'package:nearby_assist/pages/account/widget/info_tile_widget.dart';

class InformationPage extends StatefulWidget {
  const InformationPage({super.key});

  @override
  State<InformationPage> createState() => _InformationPageState();
}

class _InformationPageState extends State<InformationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "App Information",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const InfoTileWidget(
              title: "Version",
              subtitle: appVersion,
              icon: Icons.tag_outlined,
            ),
            _changelog(),
          ],
        ),
      ),
    );
  }

  Widget _changelog() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          const ListTile(
            title: Text("Changelog:"),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            child: const Text("Changelog will appear here"),
          ),
        ],
      ),
    );
  }
}
