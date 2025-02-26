import 'package:dio/dio.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:nearby_assist/config/valid_id.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/pages/account/profile/widget/fillable_image_container.dart';
import 'package:nearby_assist/pages/account/profile/widget/fillable_image_container_controller.dart';
import 'package:nearby_assist/pages/account/profile/widget/verify_account_input_field.dart';
import 'package:nearby_assist/pages/widget/address_input.dart';
import 'package:nearby_assist/providers/user_provider.dart';
import 'package:nearby_assist/services/location_service.dart';
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
  final _phoneController = TextEditingController();
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
    return LoaderOverlay(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'Verify Account',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: buildBody(),
      ),
    );
  }

  Widget buildBody() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),

            // Name
            VerifyAccountInputField(
              controller: _nameController,
              labelText: 'Complete name',
              inputType: TextInputType.name,
            ),
            const SizedBox(height: 20),

            // Phone number
            VerifyAccountInputField(
              controller: _phoneController,
              labelText: 'Phone Number',
              inputType: TextInputType.phone,
            ),
            const SizedBox(height: 20),

            // Address
            AddressInput(onLocationPicked: _onLocationPicked),
            const SizedBox(height: 20),

            // ID Type
            DropdownSearch<ValidID>(
              decoratorProps: const DropDownDecoratorProps(
                decoration: InputDecoration(
                  labelText: 'ID Type',
                  border: OutlineInputBorder(),
                ),
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

            // ID Number
            VerifyAccountInputField(
              controller: _idNumberController,
              labelText: 'ID Number',
            ),
            const SizedBox(height: 20),

            // ID Images
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

            // Divider
            const Divider(),
            const SizedBox(height: 20),

            // Selfie
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

            // Submit button
            FilledButton(
              style: const ButtonStyle(
                minimumSize: WidgetStatePropertyAll(Size.fromHeight(50)),
              ),
              onPressed: _submit,
              child: const Text('Submit'),
            ),

            // Bottom padding
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _onLocationPicked(String address) {
    setState(() {
      _addressController.text = address;
    });
  }

  void _submit() async {
    final loader = context.loaderOverlay;
    loader.show();

    final name = _nameController.text;
    final phone = _phoneController.text;
    final address = _addressController.text;
    final idType = _selectedID;
    final idNumber = _idNumberController.text;
    final frontId = _frontIdController.image;
    final backId = _backIdController.image;
    final face = _faceController.image;

    try {
      final location = await LocationService().getLocation();

      final service = VerifyAccountService();
      await service.verify(
        name: name,
        phone: phone,
        address: address,
        latitude: location.latitude,
        longitude: location.longitude,
        idType: idType,
        idNumber: idNumber,
        frontId: frontId,
        backId: backId,
        face: face,
      );

      _onSuccess();
    } on LocationServiceDisabledException catch (error) {
      logger.log('Error on verify account: ${error.toString()}');
      _showLocationServiceDisabledDialog();
    } on DioException catch (error) {
      _onError(error.response?.data['message']);
    } catch (error) {
      _onError(error.toString());
    } finally {
      loader.hide();
    }
  }

  void _onSuccess() {
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

  void _onError(String error) {
    showCustomSnackBar(
      context,
      error,
      duration: const Duration(seconds: 5),
      backgroundColor: Colors.red,
      textColor: Colors.white,
      closeIconColor: Colors.white,
    );
  }

  void _showLocationServiceDisabledDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Location Services Disabled'),
          content: const Text(
            'Please enable location services to use this feature.',
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                await Geolocator.openLocationSettings();
              },
              child: const Text('Open Settings'),
            ),
          ],
        );
      },
    );
  }
}
