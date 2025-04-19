import 'package:auto_size_text/auto_size_text.dart';
import 'package:dio/dio.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:nearby_assist/config/valid_id.dart';
import 'package:nearby_assist/models/signup_model.dart';
import 'package:nearby_assist/models/third_party_login_payload_model.dart';
import 'package:nearby_assist/pages/account/profile/widget/fillable_image_container.dart';
import 'package:nearby_assist/pages/account/profile/widget/fillable_image_container_controller.dart';
import 'package:nearby_assist/pages/account/profile/widget/identity_capture.dart';
import 'package:nearby_assist/pages/login/verification/widget/input_field.dart';
import 'package:nearby_assist/providers/user_provider.dart';
import 'package:nearby_assist/services/auth_service.dart';
import 'package:nearby_assist/services/location_service.dart';
import 'package:nearby_assist/utils/show_generic_error_modal.dart';
import 'package:nearby_assist/utils/show_location_disabled_modal.dart';
import 'package:provider/provider.dart';

class VerificationPage extends StatefulWidget {
  const VerificationPage({
    super.key,
    required this.user,
    required this.onSuccessCallback,
  });

  final ThirdPartyLoginPayloadModel user;
  final void Function() onSuccessCallback;

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  bool _submittable = false;
  final _nameController = TextEditingController(),
      _addressController = TextEditingController(),
      _phoneController = TextEditingController(),
      _idNumberController = TextEditingController(),
      _frontIdController = FillableImageContainerController(),
      _backIdController = FillableImageContainerController(),
      _selfieController = FillableImageContainerController();
  ValidID _selectedIDType = ValidID.none;

  void _initializeValues() {
    setState(() {
      _nameController.text = widget.user.name;
    });
  }

  @override
  void initState() {
    super.initState();
    _initializeValues();
  }

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      child: Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                // Name
                InputField(
                  controller: _nameController,
                  labelText: 'Complete name',
                  inputType: TextInputType.name,
                  validInputListenerCallback: (valid) =>
                      setState(() => _submittable = valid),
                ),
                const SizedBox(height: 20),

                // Address
                InputField(
                  controller: _addressController,
                  labelText: 'Address',
                  inputType: TextInputType.streetAddress,
                  validInputListenerCallback: (valid) =>
                      setState(() => _submittable = valid),
                ),
                const SizedBox(height: 20),

                // Phone number
                InputField(
                  controller: _phoneController,
                  labelText: 'Phone Number',
                  inputType: TextInputType.phone,
                  validInputListenerCallback: (valid) =>
                      setState(() => _submittable = valid),
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
                  onChanged: (validID) => setState(
                    () => validID != null
                        ? _selectedIDType = validID
                        : ValidID.none,
                  ),
                ),
                const SizedBox(height: 20),

                // ID Number
                InputField(
                  controller: _idNumberController,
                  labelText: 'ID Number',
                  validInputListenerCallback: (valid) =>
                      setState(() => _submittable = valid),
                ),
                const SizedBox(height: 20),

                // Front ID
                const AutoSizeText('ID Front'),
                const SizedBox(height: 10),
                IdentityCapture(
                  controller: _frontIdController,
                  labelText: 'Front ID',
                  hintText: 'Tap to capture',
                  icon: CupertinoIcons.photo,
                ),
                const SizedBox(height: 10),

                // Back ID
                const AutoSizeText('ID Back'),
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
                const SizedBox(height: 10),
                Row(
                  children: [
                    FillableImageContainer(
                      controller: _selfieController,
                      labelText: 'Face',
                      hintText: 'Tap to open camera',
                      icon: CupertinoIcons.camera_viewfinder,
                      source: ImageSource.camera,
                      validInputListenerCallback: (valid) =>
                          setState(() => _submittable = valid),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Signup button
                FilledButton(
                  onPressed: _handleSignup,
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(
                      !_submittable ? Colors.grey : null,
                    ),
                    minimumSize: const WidgetStatePropertyAll(
                      Size.fromHeight(50),
                    ),
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  child: const Text('Sign up'),
                ),

                // Bottom padding
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleSignup() async {
    if (!_submittable) return;

    final loader = context.loaderOverlay;

    try {
      loader.show();

      final userProvider = context.read<UserProvider>();
      final location = await LocationService().getLocation();

      final data = SignupModel(
        name: _nameController.text,
        email: widget.user.email,
        imageURL: widget.user.imageUrl,
        phone: _phoneController.text,
        address: _addressController.text,
        latitude: location.latitude,
        longitude: location.longitude,
        idType: _selectedIDType,
        referenceNumber: _idNumberController.text,
        frontId: _frontIdController.imageBytes!,
        backId: _backIdController.imageBytes!,
        selfie: _selfieController.imageBytes!,
      );

      data.selfValidate();

      final user = await AuthService().signup(data);
      userProvider.login(user);

      widget.onSuccessCallback();
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
