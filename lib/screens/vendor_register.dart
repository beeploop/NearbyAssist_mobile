import 'package:flutter/material.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/services/vendor_register_service.dart';
import 'package:nearby_assist/widgets/custom_drawer.dart';
import 'package:nearby_assist/widgets/listenable_loading_button.dart';

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
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text('Vendor Registration'),
          const Text('Form goes here'),
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
            listenable: getIt.get<VendorRegisterService>(),
            onPressed: () {},
            isLoadingFunction: () =>
                getIt.get<VendorRegisterService>().isLoading(),
          ),
        ],
      ),
    );
  }
}
