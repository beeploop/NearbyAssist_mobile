import 'package:flutter/material.dart';

class VerifyAccountInputField extends StatefulWidget {
  const VerifyAccountInputField({
    super.key,
    required this.controller,
    required this.labelText,
  });

  final TextEditingController controller;
  final String labelText;

  @override
  State<VerifyAccountInputField> createState() =>
      _VerifyAccountInputFieldState();
}

class _VerifyAccountInputFieldState extends State<VerifyAccountInputField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      onTapOutside: (event) => FocusScope.of(context).unfocus(),
      decoration: InputDecoration(
        labelText: widget.labelText,
      ),
    );
  }
}
