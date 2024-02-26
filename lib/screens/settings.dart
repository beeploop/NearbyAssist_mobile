import 'package:flutter/material.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/model/settings_model.dart';
import 'package:nearby_assist/widgets/custom_drawer.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _Settings();
}

class _Settings extends State<Settings> {
  final TextEditingController _serverController = TextEditingController();
  final TextEditingController _websocketController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final serverAddr = getIt.get<SettingsModel>().getServerAddr();
    final wsAddr = getIt.get<SettingsModel>().getWebsocketAddr();

    _serverController.text = serverAddr;
    _websocketController.text = wsAddr;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: const CustomDrawer(),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Form(
              child: TextFormField(
                onTapOutside: (event) {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                controller: _serverController,
                decoration: const InputDecoration(labelText: 'Server Address'),
              ),
            ),
            Form(
              child: TextFormField(
                onTapOutside: (event) {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                controller: _websocketController,
                decoration:
                    const InputDecoration(labelText: 'Websocket Address'),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            FilledButton(
              onPressed: () {
                FocusManager.instance.primaryFocus?.unfocus();

                if (_serverController.text.isEmpty ||
                    _websocketController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('fields cannot be empty'),
                    ),
                  );

                  return;
                }

                getIt.get<SettingsModel>().setServer(_serverController.text);
                getIt
                    .get<SettingsModel>()
                    .setWebsocket(_websocketController.text);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Settings updated'),
                  ),
                );
              },
              child: const Text('Save'),
            )
          ],
        ),
      ),
    );
  }
}
