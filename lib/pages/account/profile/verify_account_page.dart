import 'package:auto_size_text/auto_size_text.dart';
import 'package:dio/dio.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:nearby_assist/config/constants.dart';
import 'package:nearby_assist/config/valid_id.dart';
import 'package:nearby_assist/models/user_model.dart';
import 'package:nearby_assist/models/verify_account_model.dart';
import 'package:nearby_assist/pages/account/profile/widget/fillable_image_container.dart';
import 'package:nearby_assist/pages/account/profile/widget/fillable_image_container_controller.dart';
import 'package:nearby_assist/pages/account/profile/widget/identity_capture.dart';
import 'package:nearby_assist/pages/account/profile/widget/verify_account_input_field.dart';
import 'package:nearby_assist/providers/user_provider.dart';
import 'package:nearby_assist/services/location_service.dart';
import 'package:nearby_assist/services/verify_account_service.dart';
import 'package:nearby_assist/utils/show_generic_error_modal.dart';
import 'package:nearby_assist/utils/show_generic_success_modal.dart';
import 'package:nearby_assist/utils/show_location_disabled_modal.dart';
import 'package:provider/provider.dart';

class VerifyAccountPage extends StatefulWidget {
  const VerifyAccountPage({super.key});

  @override
  State<VerifyAccountPage> createState() => _VerifyAccountPageState();
}

class _VerifyAccountPageState extends State<VerifyAccountPage> {
  bool _submittable = false;
  UserModel? _user;
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _idNumberController = TextEditingController();
  final _frontIdController = FillableImageContainerController();
  final _seflieController = FillableImageContainerController();
  final _backIdController = FillableImageContainerController();
  ValidID _selectedIDType = ValidID.none;

  @override
  void initState() {
    super.initState();
    _user = Provider.of<UserProvider>(context, listen: false).user;
    if (_user == null) return;

    setState(() {
      _nameController.text = _user!.name;
      _phoneController.text = _user!.phone;
      _addressController.text = _user!.address;
      _nameController.addListener(_inputListener);
      _phoneController.addListener(_inputListener);
      _addressController.addListener(_inputListener);
      _idNumberController.addListener(_inputListener);
      _frontIdController.addListener(_inputListener);
      _backIdController.addListener(_inputListener);
      _seflieController.addListener(_inputListener);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.removeListener(_inputListener);
    _phoneController.removeListener(_inputListener);
    _addressController.removeListener(_inputListener);
    _idNumberController.removeListener(_inputListener);
    _frontIdController.removeListener(_inputListener);
    _backIdController.removeListener(_inputListener);
    _seflieController.removeListener(_inputListener);
  }

  void _inputListener() {
    if (_nameController.text.trim().isNotEmpty &&
        _phoneController.text.trim().isNotEmpty &&
        _phoneController.text.length == phoneNumberLength &&
        _addressController.text.trim().isNotEmpty &&
        _selectedIDType != ValidID.none &&
        _idNumberController.text.trim().isNotEmpty &&
        _frontIdController.hasImage &&
        _backIdController.hasImage &&
        _seflieController.hasImage) {
      setState(() {
        _submittable = true;
      });
    } else {
      setState(() {
        _submittable = false;
      });
    }
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
          crossAxisAlignment: CrossAxisAlignment.start,
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
            VerifyAccountInputField(
              controller: _addressController,
              labelText: 'Address',
              inputType: TextInputType.streetAddress,
            ),
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
              selectedItem: _selectedIDType,
              onChanged: (id) => setState(() {
                _selectedIDType = id ?? ValidID.none;
                _inputListener();
              }),
            ),
            const SizedBox(height: 20),

            // ID Number
            VerifyAccountInputField(
              controller: _idNumberController,
              labelText: 'ID Number',
            ),
            const SizedBox(height: 20),

            // Front ID
            const AutoSizeText('Front ID'),
            const SizedBox(height: 10),
            IdentityCapture(
              controller: _frontIdController,
              labelText: 'Front ID',
              hintText: 'Tap to capture',
              icon: CupertinoIcons.photo,
            ),
            const SizedBox(height: 10),

            // Back ID
            const AutoSizeText('Back ID'),
            const SizedBox(height: 10),
            IdentityCapture(
              controller: _backIdController,
              labelText: 'Back ID',
              hintText: 'Tap to capture',
              icon: CupertinoIcons.photo,
            ),
            const SizedBox(height: 20),

            // Divider
            const Divider(),
            const SizedBox(height: 20),

            // Selfie
            const AutoSizeText('Selfie'),
            Row(
              children: [
                FillableImageContainer(
                  controller: _seflieController,
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
              style: ButtonStyle(
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                backgroundColor: WidgetStatePropertyAll(
                  !_submittable ? Colors.grey : null,
                ),
                minimumSize: const WidgetStatePropertyAll(
                  Size.fromHeight(50),
                ),
              ),
              onPressed: _submittable ? _submit : () {},
              child: const Text('Submit'),
            ),

            // Bottom padding
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _submit() async {
    final loader = context.loaderOverlay;

    try {
      loader.show();

      final userProvider = context.read<UserProvider>();
      final location = await LocationService().getLocation();

      final data = VerifyAccountModel(
        name: _nameController.text,
        phone: _phoneController.text,
        address: _addressController.text,
        latitude: location.latitude,
        longitude: location.longitude,
        idType: _selectedIDType,
        referenceNumber: _idNumberController.text,
        frontId: _frontIdController.imageBytes!,
        backId: _backIdController.imageBytes!,
        selfie: _seflieController.imageBytes!,
      );

      data.selfValidate();

      await VerifyAccountService().verify(data);
      final updatedUser = userProvider.user.copyWith(
        name: data.name,
        phone: data.phone,
        address: data.address,
        hasPendingVerification: true,
      );
      await userProvider.updateUser(updatedUser);

      if (!mounted) return;
      showGenericSuccessModal(
        context,
        message:
            'Request submitted. We are reviewing your request and will get back to you',
      );
    } on LocationServiceDisabledException catch (_) {
      if (!mounted) return;
      showLocationDisabledModal(context);
    } on DioException catch (error) {
      if (!mounted) return;
      showGenericErrorModal(context, message: error.response?.data['message']);
    } catch (error) {
      if (!mounted) return;
      showGenericErrorModal(context, message: error.toString());
    } finally {
      loader.hide();
    }
  }
}
