import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nearby_assist/config/valid_id.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/pages/account/profile/widget/fillable_image_container.dart';
import 'package:nearby_assist/pages/account/profile/widget/fillable_image_container_controller.dart';
import 'package:nearby_assist/pages/account/profile/widget/verify_account_input_field.dart';
import 'package:nearby_assist/utils/custom_snackbar.dart';

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
  final _backIdController = FillableImageContainerController();
  ValidID _selectedID = ValidID.none;

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
                    labelText: 'Front Side',
                    icon: CupertinoIcons.photo,
                  ),
                  const SizedBox(width: 20),
                  FillableImageContainer(
                    controller: _backIdController,
                    labelText: 'Back Side',
                    icon: CupertinoIcons.photo_fill,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.green,
                  minimumSize: const Size.fromHeight(50),
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

  void _submit() {
    final name = _nameController.text;
    final address = _addressController.text;
    final idType = _selectedID;
    final idNumber = _idNumberController.text;
    final frontId = _frontIdController.image;
    final backId = _backIdController.image;

    if (idType == ValidID.none) {
      showCustomSnackBar(
        context,
        "'none' is not a supported ID",
        duration: const Duration(seconds: 5),
        backgroundColor: Colors.red,
        textColor: Colors.white,
        closeIconColor: Colors.white,
      );
    }

    logger.log('Name: $name');
    logger.log('Address: $address');
    logger.log('ID Type: $idType');
    logger.log('ID Number: $idNumber');
    logger.log('Front ID: $frontId');
    logger.log('Back ID: $backId');
  }
}
