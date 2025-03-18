import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nearby_assist/main.dart';

class TesterSettingsModal extends StatefulWidget {
  const TesterSettingsModal({super.key});

  @override
  State<TesterSettingsModal> createState() => _TesterSettingsModalState();
}

class _TesterSettingsModalState extends State<TesterSettingsModal> {
  final _urlController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: systemSettings,
      builder: (context, _) {
        _urlController.text = systemSettings.serverURL;

        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _disclaimer(),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _urlController,
                      onTapOutside: (event) => FocusScope.of(context).unfocus(),
                      decoration: const InputDecoration(
                        labelText: 'Server URL',
                        border: OutlineInputBorder(),
                        hintText: 'Server URL',
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  FilledButton.icon(
                    onPressed: () {
                      if (_urlController.text.isEmpty) return;

                      _handleSave();
                    },
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(
                        _urlController.text.isEmpty ? Colors.grey : null,
                      ),
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    icon: const Icon(CupertinoIcons.floppy_disk, size: 20),
                    label: const Text('Save'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
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

  Future<void> _handleSave() async {
    final navigator = Navigator.of(context);
    await systemSettings.changeServerURL(_urlController.text);

    navigator.pop();
  }
}
