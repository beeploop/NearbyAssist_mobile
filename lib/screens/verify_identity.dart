import 'dart:io';
import 'package:flutter/material.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/model/auth_model.dart';
import 'package:nearby_assist/services/custom_file_picker.dart';
import 'package:nearby_assist/services/verify_identity_service.dart';
import 'package:nearby_assist/widgets/custom_drawer.dart';
import 'package:nearby_assist/widgets/input_box.dart';
import 'package:nearby_assist/widgets/listenable_loading_button.dart';
import 'package:nearby_assist/config/constants.dart' as constants;

class VerifyIdentity extends StatefulWidget {
  const VerifyIdentity({super.key});

  @override
  State<StatefulWidget> createState() => _VerifyIdentity();
}

class _VerifyIdentity extends State<VerifyIdentity> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _idSelectController = TextEditingController();
  final TextEditingController _idNumberController = TextEditingController();
  final filePicker = CustomFilePicker();
  bool _isChecked = false;
  File? _frontIdImage;
  File? _backIdImage;
  File? _faceImage;

  @override
  void initState() {
    try {
      final user = getIt.get<AuthModel>().getUser();
      _nameController.text = user.name;
    } catch (e) {
      _nameController.text = '';
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Identity Verification',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      drawer: const CustomDrawer(),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          InputBox(
            controller: _nameController,
            hintText: 'Full name',
          ),
          InputBox(
            controller: _addressController,
            hintText: 'Address',
          ),
          DropdownMenu(
            dropdownMenuEntries: [
              ...createDropDownEntries(constants.validId),
            ],
            hintText: 'Select ID',
            controller: _idSelectController,
            expandedInsets: EdgeInsets.zero,
          ),
          InputBox(
            controller: _idNumberController,
            hintText: 'ID Number',
          ),
          Column(
            children: [
              const Text('Upload ID back-to-back'),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      final file = await filePicker.pickFile();

                      if (file == null) {
                        return;
                      }

                      setState(() {
                        _frontIdImage = file;
                      });
                    },
                    child: const Text('Front ID'),
                  ),
                  _frontIdImage == null
                      ? const SizedBox()
                      : Image.memory(
                          _frontIdImage!.readAsBytesSync(),
                          width: 100,
                          height: 100,
                        ),
                ],
              ),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      final file = await filePicker.pickFile();

                      if (file == null) {
                        return;
                      }

                      setState(() {
                        _backIdImage = file;
                      });
                    },
                    child: const Text('Back ID'),
                  ),
                  _backIdImage == null
                      ? const SizedBox()
                      : Image.memory(
                          _backIdImage!.readAsBytesSync(),
                          width: 100,
                          height: 100,
                        ),
                ],
              ),
            ],
          ),
          Column(
            children: [
              const Text('Upload face image'),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      final file = await filePicker.pickFile();

                      if (file == null) {
                        return;
                      }

                      setState(() {
                        _faceImage = file;
                      });
                    },
                    child: const Text('Face Image'),
                  ),
                  _faceImage == null
                      ? const SizedBox()
                      : Image.memory(
                          _faceImage!.readAsBytesSync(),
                          width: 100,
                          height: 100,
                        ),
                ],
              ),
            ],
          ),
          Flex(
            direction: Axis.horizontal,
            children: [
              Checkbox(
                value: _isChecked,
                onChanged: (bool? value) => setState(() => _isChecked = value!),
              ),
              const Text('I agree to the terms and conditions.'),
            ],
          ),
          ListenableLoadingButton(
            listenable: getIt.get<VerifyIdentityService>(),
            onPressed: () async {
              if (getIt.get<VerifyIdentityService>().isLoading()) {
                return;
              }

              if (_nameController.text.isEmpty ||
                  _addressController.text.isEmpty ||
                  _idSelectController.text.isEmpty ||
                  _idNumberController.text.isEmpty ||
                  _frontIdImage == null ||
                  _backIdImage == null ||
                  _faceImage == null ||
                  !_isChecked) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text(
                      'Please fill all fields and agree to the terms and conditions.'),
                ));
                return;
              }

              try {
                await getIt.get<VerifyIdentityService>().verifyIdentity(
                      name: _nameController.text,
                      address: _addressController.text,
                      idType: _idSelectController.text,
                      idNumber: _idNumberController.text,
                      frontId: _frontIdImage!,
                      backId: _backIdImage!,
                      face: _faceImage!,
                    );

                _nameController.clear();
                _addressController.clear();
                _idSelectController.clear();
                _idNumberController.clear();
                _frontIdImage = null;
                _backIdImage = null;
                _faceImage = null;

                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Submitted verification request'),
                    ),
                  );
                }
              } catch (err) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(err.toString())),
                  );
                }
              }
            },
            isLoadingFunction: () =>
                getIt.get<VerifyIdentityService>().isLoading(),
          ),
        ],
      ),
    );
  }

  List<DropdownMenuEntry> createDropDownEntries(List<String> ids) {
    return ids.map((id) {
      return DropdownMenuEntry(value: id, label: id);
    }).toList();
  }
}
