import 'package:flutter/material.dart';

class ServiceExtraController {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  String get title => titleController.text;
  String get description => descriptionController.text;
  double get price => double.tryParse(priceController.text) ?? 0;
}
