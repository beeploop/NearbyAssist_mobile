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
  final TextEditingController _addrController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _addrController.text = getIt.get<SettingsModel>().getBackendUrl();
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
                onTapOutside: (event) {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                controller: _addrController,
                decoration:
                    const InputDecoration(labelText: 'Backend Hostname'),
              ),
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: () async {
                FocusManager.instance.primaryFocus?.unfocus();

                if (_addrController.text.isEmpty) {
                  return;
                }

                await getIt
                    .get<SettingsModel>()
                    .updateBackendUrl(_addrController.text);

                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Backend URL updated'),
                    ),
                  );
                }
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
