import 'package:flutter/material.dart';

class InputBox extends StatelessWidget {
  const InputBox({
    super.key,
    this.hintText,
    required this.controller,
    this.lines,
  });

  final String? hintText;
  final TextEditingController controller;
  final int? lines;

  @override
  Widget build(BuildContext context) {
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
