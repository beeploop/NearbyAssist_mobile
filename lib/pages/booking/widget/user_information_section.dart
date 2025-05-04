import 'package:flutter/material.dart';
import 'package:nearby_assist/pages/booking/widget/input_field.dart';
import 'package:nearby_assist/providers/user_provider.dart';
import 'package:provider/provider.dart';

class UserInformationSection extends StatefulWidget {
  const UserInformationSection({
    super.key,
    required this.addressController,
  });

  final TextEditingController addressController;

  @override
  State<UserInformationSection> createState() => _UserInformationSectionState();
}

class _UserInformationSectionState extends State<UserInformationSection> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final user = Provider.of<UserProvider>(context, listen: false).user;

    nameController.text = user.name;
    emailController.text = user.email;
    addressController.text = user.address;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'User Information',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        InputField(
          readOnly: true,
          controller: nameController,
          hintText: 'your name',
          labelText: 'Full Name',
        ),
        const SizedBox(height: 20),
        InputField(
          readOnly: true,
          controller: emailController,
          hintText: 'client@email.com',
          labelText: 'Email',
        ),
        const SizedBox(height: 20),
        InputField(
          readOnly: true,
          controller: addressController,
          hintText: 'purok, brgy, city, province',
          labelText: 'Address',
        ),
      ],
    );
  }
}
