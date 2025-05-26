import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:nearby_assist/config/constants.dart';
import 'package:nearby_assist/models/user_model.dart';
import 'package:nearby_assist/providers/user_provider.dart';
import 'package:nearby_assist/utils/show_generic_error_modal.dart';
import 'package:nearby_assist/utils/show_location_disabled_modal.dart';
import 'package:provider/provider.dart';

class ChangePhonePage extends StatefulWidget {
  const ChangePhonePage({super.key});

  @override
  State<ChangePhonePage> createState() => _ChangePhonePageState();
}

class _ChangePhonePageState extends State<ChangePhonePage> {
  bool _submittable = false;
  final _phoneController = TextEditingController();
  late UserModel user;

  @override
  void initState() {
    super.initState();
    user = Provider.of<UserProvider>(context, listen: false).user;
    _phoneController.text = user.phone;
    _phoneController.addListener(_inputListener);
  }

  @override
  void dispose() {
    super.dispose();
    _phoneController.removeListener(_inputListener);
  }

  void _inputListener() {
    if (user.phone.trim() != _phoneController.text.trim() &&
        _phoneController.text.isNotEmpty &&
        _phoneController.text.length == phoneNumberLength) {
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
          title: const Text('Update Phone'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              TextFormField(
                controller: _phoneController,
                onTapOutside: (event) => FocusScope.of(context).unfocus(),
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  labelText: 'Phone',
                  border: OutlineInputBorder(),
                ),
                maxLength: 11,
              ),
            ],
          ),
        ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: FilledButton(
            onPressed: _submittable ? _showPhoneUpdateConfirmation : () {},
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
            child: const Text('Update Phone'),
          ),
        ),
      ),
    );
  }

  void _showPhoneUpdateConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(
          CupertinoIcons.question_circle,
          color: Colors.amber,
          size: 40,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        title: const Text('Update Phone'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: _handleUpdatePhone,
            style: ButtonStyle(
              backgroundColor: const WidgetStatePropertyAll(Colors.green),
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }

  Future<void> _handleUpdatePhone() async {
    final loader = context.loaderOverlay;

    try {
      loader.show();
      final navigator = Navigator.of(context);
      navigator.pop();

      if (_phoneController.text.isEmpty ||
          _phoneController.text.length != phoneNumberLength) {
        throw "Invalid phone number provided";
      }

      await context.read<UserProvider>().updatePhone(_phoneController.text);

      navigator.pop();
      navigator.pop();
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
