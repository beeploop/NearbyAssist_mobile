import 'package:flutter/material.dart';

class InputField extends StatefulWidget {
  const InputField({
    super.key,
    required this.hintText,
    this.controller,
    this.labelText,
    this.minLines = 1,
    this.maxLines = 2,
    this.readOnly = false,
  });

  final TextEditingController? controller;
  final String hintText;
  final String? labelText;
  final int? minLines;
  final int? maxLines;
  final bool readOnly;

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: widget.readOnly,
      controller: widget.controller,
      onTapOutside: (event) => FocusScope.of(context).unfocus(),
      decoration: InputDecoration(
        labelText: widget.labelText,
        border: const OutlineInputBorder(),
        hintText: widget.hintText,
      ),
      minLines: widget.minLines,
      maxLines: widget.maxLines,
    );
  }
}
