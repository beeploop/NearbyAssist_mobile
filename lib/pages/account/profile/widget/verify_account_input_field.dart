import 'package:flutter/material.dart';

class VerifyAccountInputField extends StatefulWidget {
  const VerifyAccountInputField({
    super.key,
    required this.controller,
    required this.labelText,
    this.inputType = TextInputType.text,
    this.maxLength,
  });

  final TextEditingController controller;
  final String labelText;
  final TextInputType inputType;
  final int? maxLength;

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
      keyboardType: widget.inputType,
      decoration: InputDecoration(
        labelText: widget.labelText,
        border: const OutlineInputBorder(),
      ),
      maxLength: widget.maxLength,
    );
  }
}
