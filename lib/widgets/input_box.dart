import 'package:flutter/material.dart';

class InputBox extends StatelessWidget {
  const InputBox({
    super.key,
    this.hintText,
    required this.controller,
    this.initialValue,
    this.lines,
  });

  final String? initialValue;
  final String? hintText;
  final TextEditingController controller;
  final int? lines;

  @override
  Widget build(BuildContext context) {
    if (initialValue != null) {
      controller.text = initialValue!;
    }

    return Form(
      child: TextFormField(
        onTapOutside: (event) {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText ?? "Enter text here",
          border: const OutlineInputBorder(),
        ),
        maxLines: lines ?? 1,
      ),
    );
  }
}
