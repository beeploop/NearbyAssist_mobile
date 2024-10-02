import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/model/auth_model.dart';
import 'package:nearby_assist/services/custom_file_picker.dart';
import 'package:nearby_assist/services/search_service.dart';
import 'package:nearby_assist/services/vendor_register_service.dart';
import 'package:nearby_assist/widgets/custom_drawer.dart';
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
        title: const Text(
          'Vendor Registration',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      drawer: const CustomDrawer(),
      body: ListenableBuilder(
        listenable: getIt.get<AuthModel>(),
        builder: (context, child) {
          final isVerified = getIt.get<AuthModel>().isUserVerified();

          if (!isVerified) {
            return PopUp(
              title: "Account not verified",
              subtitle:
                  'You need to verify your account first before you can offer services',
              actions: [
                TextButton(
                  onPressed: () {
                    context.goNamed('verify-identity');
                  },
                  child: const Text('Verify'),
                ),
                TextButton(
                  onPressed: () {
                    context.goNamed('home');
                  },
                  child: const Text('Cancel'),
                ),
              ],
            );
          }

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
              Flex(
                direction: Axis.horizontal,
                children: [
                  Checkbox(
                    value: _isTermsAndConditionsChecked,
                    onChanged: (bool? value) =>
                        setState(() => _isTermsAndConditionsChecked = value!),
                  ),
                  const Text('I agree to the terms and conditions.'),
                ],
              ),
              const SizedBox(height: 20),
              ListenableLoadingButton(
                listenable: getIt.get<VendorRegisterService>(),
                onPressed: () {
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

                  if (kDebugMode) {
                    print('police clearance: $_policeClearance');
                    print('service certificate: $_serviceCertificate');
                    print('job: ${_jobController.text}');
                  }

                  getIt.get<VendorRegisterService>().registerVendor(
                        job: _jobController.text,
                        policeClearance: _policeClearance!,
                        supportingDocument: _serviceCertificate!,
                      );
                },
                isLoadingFunction: () =>
                    getIt.get<VendorRegisterService>().isLoading(),
              ),
            ],
          );
        },
      ),
    );
  }

  List<DropdownMenuEntry> generateDropdownEntries() {
    return _serviceTags.map((job) {
      return DropdownMenuEntry(value: job, label: job);
    }).toList();
  }
}
