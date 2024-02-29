import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/model/settings_model.dart';

class BottomModalSetting extends StatefulWidget {
  const BottomModalSetting({super.key});

  @override
  State<BottomModalSetting> createState() => _BottomModalSetting();
}

class _BottomModalSetting extends State<BottomModalSetting> {
  final TextEditingController _serverController = TextEditingController();
  final TextEditingController _websocketController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final serverAddr = getIt.get<SettingsModel>().getServerAddr();
    final websocketAddr = getIt.get<SettingsModel>().getWebsocketAddr();

    _serverController.text = serverAddr;
    _websocketController.text = websocketAddr;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Form(
              child: TextFormField(
                controller: _serverController,
                decoration: const InputDecoration(labelText: 'Server Address'),
              ),
            ),
            Form(
              child: TextFormField(
                controller: _websocketController,
                decoration:
                    const InputDecoration(labelText: 'Websocket Address'),
              ),
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: () {
                if (_serverController.text.isEmpty ||
                    _websocketController.text.isEmpty) {
                  return;
                }

                getIt.get<SettingsModel>().setServer(_serverController.text);
                getIt
                    .get<SettingsModel>()
                    .setWebsocket(_websocketController.text);
              },
              child: const Text('Save'),
            ),
            FilledButton(
              onPressed: () {
                context.pop();
              },
              child: const Text('Close'),
            ),
          ],
        ),
      ),
    );
  }
}
