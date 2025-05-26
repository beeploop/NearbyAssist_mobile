import 'package:flutter/material.dart';

class InputField extends StatefulWidget {
  const InputField({
    super.key,
    required this.controller,
    required this.labelText,
    this.inputType = TextInputType.text,
    this.validInputListenerCallback,
    this.maxLength,
  });

  final TextEditingController controller;
  final String labelText;
  final TextInputType inputType;
  final void Function(bool)? validInputListenerCallback;
  final int? maxLength;

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_inputListener);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_inputListener);
    super.dispose();
  }

  void _inputListener() {
    if (widget.validInputListenerCallback == null) return;

    if (widget.controller.text.isNotEmpty) {
      widget.validInputListenerCallback!(true);
    } else {
      widget.validInputListenerCallback!(false);
    }
  }

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
