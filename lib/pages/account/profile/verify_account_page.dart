import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nearby_assist/config/valid_id.dart';
import 'package:nearby_assist/pages/account/profile/widget/fillable_image_container.dart';
import 'package:nearby_assist/pages/account/profile/widget/fillable_image_container_controller.dart';
import 'package:nearby_assist/pages/account/profile/widget/verify_account_input_field.dart';
import 'package:nearby_assist/providers/user_provider.dart';
import 'package:nearby_assist/services/verify_account_service.dart';
import 'package:nearby_assist/utils/custom_snackbar.dart';
import 'package:provider/provider.dart';

class VerifyAccountPage extends StatefulWidget {
  const VerifyAccountPage({super.key});

  @override
  State<VerifyAccountPage> createState() => _VerifyAccountPageState();
}

class _VerifyAccountPageState extends State<VerifyAccountPage> {
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _idNumberController = TextEditingController();
  final _frontIdController = FillableImageContainerController();
  final _faceController = FillableImageContainerController();
  final _backIdController = FillableImageContainerController();
  ValidID _selectedID = ValidID.none;

  @override
  void initState() {
    super.initState();
    _initialValues();
  }

  void _initialValues() {
    final user = context.read<UserProvider>().user;
    setState(() {
      _nameController.text = user.name;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Verify Account',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              VerifyAccountInputField(
                controller: _nameController,
                labelText: 'Complete name',
              ),
              const SizedBox(height: 20),
              VerifyAccountInputField(
                controller: _addressController,
                labelText: 'Address',
              ),
              const SizedBox(height: 20),
              DropdownSearch<ValidID>(
                decoratorProps: const DropDownDecoratorProps(
                  decoration: InputDecoration(labelText: 'ID Type'),
                ),
                items: (filter, props) => ValidID.values,
                itemAsString: (id) => id.value,
                compareFn: (id, selectedID) => id == selectedID,
                selectedItem: _selectedID,
                onChanged: (id) => setState(
                  () => id != null ? _selectedID = id : ValidID.none,
                ),
              ),
              const SizedBox(height: 20),
              VerifyAccountInputField(
                controller: _idNumberController,
                labelText: 'ID Number',
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  FillableImageContainer(
                    controller: _frontIdController,
                    labelText: 'ID Front Side',
                    icon: CupertinoIcons.photo,
                  ),
                  const SizedBox(width: 20),
                  FillableImageContainer(
                    controller: _backIdController,
                    labelText: 'ID Back Side',
                    icon: CupertinoIcons.photo_fill,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 20),
              Row(
                children: [
                  FillableImageContainer(
                    controller: _faceController,
                    labelText: 'Face',
                    hintText: 'Tap to open camera',
                    icon: CupertinoIcons.camera_viewfinder,
                    source: ImageSource.camera,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              FilledButton(
                style: const ButtonStyle(
                  minimumSize: WidgetStatePropertyAll(Size.fromHeight(50)),
                ),
                onPressed: _submit,
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submit() async {
    final name = _nameController.text;
    final address = _addressController.text;
    final idType = _selectedID;
    final idNumber = _idNumberController.text;
    final frontId = _frontIdController.image;
    final backId = _backIdController.image;
    final face = _faceController.image;

    try {
      final service = VerifyAccountService();
      await service.verify(
        name: name,
        address: address,
        idType: idType,
        idNumber: idNumber,
        frontId: frontId,
        backId: backId,
        face: face,
      );

      _showSuccessModal();
    } catch (error) {
      _showErrorModal(error.toString());
    }
  }

  void _showSuccessModal() {
    showCustomSnackBar(
      context,
      'Request submitted. We are reviewing your request and will get back to you',
      duration: const Duration(seconds: 5),
      backgroundColor: Colors.green,
      textColor: Colors.white,
      closeIconColor: Colors.white,
    );

    context.pop();
  }

  void _showErrorModal(String error) {
    showCustomSnackBar(
      context,
      error,
      duration: const Duration(seconds: 5),
      backgroundColor: Colors.red,
      textColor: Colors.white,
      closeIconColor: Colors.white,
    );
  }
}
