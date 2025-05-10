import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:nearby_assist/models/signup_model.dart';
import 'package:nearby_assist/models/third_party_login_payload_model.dart';
import 'package:nearby_assist/pages/login/verification/widget/input_field.dart';
import 'package:nearby_assist/providers/user_provider.dart';
import 'package:nearby_assist/services/auth_service.dart';
import 'package:nearby_assist/services/google_auth_service.dart';
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
      _phoneController = TextEditingController();

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
  void dispose() {
    super.dispose();
    GoogleAuthService().logout();
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

                // Signup button

                // Bottom padding
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: FilledButton(
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
