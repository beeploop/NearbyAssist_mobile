import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/model/auth_model.dart';
import 'package:nearby_assist/services/custom_file_picker.dart';
import 'package:nearby_assist/services/logger_service.dart';
import 'package:nearby_assist/services/search_service.dart';
import 'package:nearby_assist/services/vendor_register_service.dart';
import 'package:nearby_assist/widgets/clickable_text.dart';
import 'package:nearby_assist/widgets/listenable_loading_button.dart';
import 'package:nearby_assist/widgets/popup.dart';

class VendorRegister extends StatefulWidget {
  const VendorRegister({super.key});

  @override
  State createState() => _VendorRegisterState();
}

class _VendorRegisterState extends State<VendorRegister> {
  final TextEditingController _jobController = TextEditingController();
  bool _isTermsAndConditionsChecked = false;
  final _filepicker = CustomFilePicker();
  File? _policeClearance;
  File? _serviceCertificate;
  final _serviceTags = getIt.get<SearchingService>().getTags();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Vendor Registration',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: FutureBuilder(
        future: getIt.get<AuthModel>().isUserVerified(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            final err = snapshot.error.toString();
            return Center(child: Text(err));
          }

          if (!snapshot.hasData) {
            return const Center(
              child: Text('Unexpected behavior, no error but has no data'),
            );
          }

          final isVerified = snapshot.data!;
          if (!isVerified) {
            return PopUp(
              title: "Account not verified",
              subtitle:
                  'You need to verify your account first before you can offer services',
              actions: [
                TextButton(
                  onPressed: () {
                    context.pushNamed('verifyIdentity');
                  },
                  child: const Text('Verify'),
                ),
                TextButton(
                  onPressed: () {
                    context.pop();
                  },
                  child: const Text('Cancel'),
                ),
              ],
            );
          }

          return ListenableBuilder(
            listenable: getIt.get<AuthModel>(),
            builder: (context, child) {
              return ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          final file = await _filepicker.pickFile();

                          if (file == null) {
                            return;
                          }

                          setState(() {
                            _policeClearance = file;
                          });
                        },
                        child: const Text('Police Clearance'),
                      ),
                    ],
                  ),
                  Text(
                    _policeClearance.toString().split('/').last,
                    overflow: TextOverflow.fade,
                  ),
                  const SizedBox(height: 20),
                  DropdownMenu(
                    label: const Text('Select service to offer'),
                    dropdownMenuEntries: generateDropdownEntries(),
                    controller: _jobController,
                    expandedInsets: EdgeInsets.zero,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          final file = await _filepicker.pickFile();

                          if (file == null) {
                            return;
                          }

                          setState(() {
                            _serviceCertificate = file;
                          });
                        },
                        child: const Text('Service Certificate'),
                      ),
                    ],
                  ),
                  Text(
                    _serviceCertificate.toString().split('/').last,
                    overflow: TextOverflow.fade,
                  ),
                  const SizedBox(height: 20),
                  _buildTermsAndConditions(),
                  const SizedBox(height: 20),
                  ListenableLoadingButton(
                    listenable: getIt.get<VendorRegisterService>(),
                    onPressed: () async {
                      if (_policeClearance == null ||
                          _serviceCertificate == null ||
                          _jobController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Please fill out all fields',
                            ),
                          ),
                        );
                        return;
                      }

                      if (_isTermsAndConditionsChecked == false) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'You must agree to the terms and conditions',
                            ),
                          ),
                        );
                        return;
                      }

                      try {
                        await getIt.get<VendorRegisterService>().registerVendor(
                              job: _jobController.text,
                              policeClearance: _policeClearance!,
                              supportingDocument: _serviceCertificate!,
                            );
                      } catch (err) {
                        ConsoleLogger().log('Error registering vendor: $err');
                        if (err.toString().contains('400')) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'You alread submitted an application. Please wait for approval'),
                              ),
                            );

                            return;
                          }
                        }

                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(err.toString())),
                          );
                        }
                      }
                    },
                    isLoadingFunction: () =>
                        getIt.get<VendorRegisterService>().isLoading(),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildTermsAndConditions() {
    return Flex(
      direction: Axis.horizontal,
      children: [
        Checkbox(
          value: _isTermsAndConditionsChecked,
          onChanged: (bool? value) =>
              setState(() => _isTermsAndConditionsChecked = value!),
        ),
        ClickableText(url: Uri.parse("https://192.168.122.1:3000")),
      ],
    );
  }

  List<DropdownMenuEntry> generateDropdownEntries() {
    return _serviceTags.map((job) {
      return DropdownMenuEntry(value: job, label: job);
    }).toList();
  }
}
