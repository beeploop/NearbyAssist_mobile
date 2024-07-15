import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/model/auth_model.dart';
import 'package:nearby_assist/model/settings_model.dart';
import 'package:nearby_assist/model/tag_model.dart';
import 'package:nearby_assist/request/dio_request.dart';
import 'package:nearby_assist/services/storage_service.dart';
import 'package:nearby_assist/widgets/custom_drawer.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _Settings();
}

class _Settings extends State<Settings> {
  final TextEditingController _addrController = TextEditingController();
  Timer? _debounce;
  final Duration _debounceDuration = const Duration(seconds: 2);

  @override
  void initState() {
    super.initState();
    _addrController.text = getIt.get<SettingsModel>().getBackendUrl();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: const CustomDrawer(),
      body: ListView(
        children: [
          ListTile(
            dense: true,
            leading: const Icon(Icons.computer_outlined),
            title: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    decoration:
                        const InputDecoration(labelText: 'Backend Hostname'),
                    controller: _addrController,
                    onTapOutside: (event) {
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    onChanged: (value) async {
                      if (_debounce != null && _debounce!.isActive) {
                        _debounce?.cancel();
                      }

                      _debounce = Timer(_debounceDuration, () {
                        if (value.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Backend URL cannot be empty'),
                            ),
                          );

                          return;
                        }

                        getIt.get<SettingsModel>().updateBackendUrl(value).then(
                          (_) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Backend URL updated'),
                              ),
                            );
                          },
                        );
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            dense: true,
            leading: const Icon(Icons.update_outlined),
            title: const Text('Update service tags'),
            subtitle: const Text('Force update service tags'),
            onTap: () async {
              try {
                final request = DioRequest();
                final response = await request.get("/backend/v1/public/tags");
                List data = response.data['tags'];
                final tags = data.map((element) {
                  return TagModel.fromJson(element);
                }).toList();

                await getIt.get<StorageService>().saveTags(tags);
                await getIt.get<StorageService>().loadData();

                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Service tags updated')),
                  );
                }
              } catch (e) {
                debugPrint(e.toString());
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                          'Error occurred while trying to update service tags'),
                    ),
                  );
                }
              }
            },
          ),
          ListTile(
            dense: true,
            leading: const Icon(Icons.feedback_outlined),
            title: const Text('Feedback And Issue'),
            subtitle: const Text('Report a bug encountered in the app'),
            onTap: () {
              context.goNamed('report-issue');
            },
          ),
          ListTile(
            dense: true,
            leading: const Icon(Icons.question_answer_outlined),
            title: const Text('Test Page'),
            subtitle: const Text('Placeholder page for testing'),
            onTap: () {
              context.goNamed('example');
            },
          ),
          ListTile(
            dense: true,
            textColor: Colors.red,
            iconColor: Colors.red,
            leading: const Icon(Icons.delete_outline),
            onTap: () async {
              try {
                await getIt.get<AuthModel>().logout();
              } catch (e) {
                debugPrint(e.toString());
              }
            },
            title: const Text('Clear Data'),
            subtitle: const Text('Clear all data and logout'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
