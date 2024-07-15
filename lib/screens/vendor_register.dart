import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/request/dio_request.dart';
import 'package:nearby_assist/services/vendor_register_service.dart';
import 'package:nearby_assist/widgets/custom_drawer.dart';
import 'package:nearby_assist/widgets/listenable_loading_button.dart';
import 'package:nearby_assist/widgets/popup.dart';
import 'package:nearby_assist/widgets/text_heading.dart';

class VendorRegister extends StatefulWidget {
  const VendorRegister({super.key});

  @override
  State createState() => _VendorRegisterState();
}

class _VendorRegisterState extends State<VendorRegister> {
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: const CustomDrawer(),
      body: FutureBuilder(
        future: _checkVerification(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text('An error occurred. Try again later.'),
            );
          }

          final verified = snapshot.data!;

          if (!verified) {
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
              const TextHeading(title: "Vendor Registration"),
              const Divider(),
              const Text('Form goes here'),
              Flex(
                direction: Axis.horizontal,
                children: [
                  Checkbox(
                    value: _isChecked,
                    onChanged: (bool? value) =>
                        setState(() => _isChecked = value!),
                  ),
                  const Text('I agree to the terms and conditions.'),
                ],
              ),
              ListenableLoadingButton(
                listenable: getIt.get<VendorRegisterService>(),
                onPressed: () {},
                isLoadingFunction: () =>
                    getIt.get<VendorRegisterService>().isLoading(),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<bool> _checkVerification() async {
    try {
      const url = "/backend/v1/public/users";

      final request = DioRequest();
      final response = await request.get(url);
      if (kDebugMode) {
        print(response.data);
      }

      return response.data['verified'];
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      rethrow;
    }
  }
}
