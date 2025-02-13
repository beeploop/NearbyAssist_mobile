import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nearby_assist/models/add_extra_model.dart';
import 'package:nearby_assist/services/manage_services_service.dart';

class AddExtraPage extends StatefulWidget {
  const AddExtraPage({super.key, required this.serviceId});

  final String serviceId;

  @override
  State<AddExtraPage> createState() => _AddExtraPageState();
}

class _AddExtraPageState extends State<AddExtraPage> {
  bool _isLoading = false;
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text(
              'Create Extra',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          body: _body(),
        ),

        // Show loading overlay
        if (_isLoading)
          const Opacity(
            opacity: 0.8,
            child: ModalBarrier(dismissible: false, color: Colors.black),
          ),
        if (_isLoading)
          const Center(
            child: CircularProgressIndicator(),
          ),
      ],
    );
  }

  Widget _body() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            const Text('Title'),
            const SizedBox(height: 10),
            TextFormField(
              controller: _titleController,
              onTapOutside: (_) =>
                  FocusManager.instance.primaryFocus?.unfocus(),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            // Description
            const Text('Description'),
            const SizedBox(height: 10),
            TextFormField(
              controller: _descriptionController,
              onTapOutside: (_) =>
                  FocusManager.instance.primaryFocus?.unfocus(),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
              maxLines: 6,
              minLines: 3,
            ),
            const SizedBox(height: 20),

            // Price
            const Text('Price'),
            TextFormField(
              keyboardType: TextInputType.number,
              controller: _priceController,
              onTapOutside: (_) =>
                  FocusManager.instance.primaryFocus?.unfocus(),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            // Save button
            FilledButton(
              style: const ButtonStyle(
                minimumSize: WidgetStatePropertyAll(Size.fromHeight(50)),
              ),
              onPressed: _handleSave,
              child: const Text('Save'),
            ),

            // Bottom padding
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Future<void> _handleSave() async {
    try {
      _toggleLoader(true);

      final navigator = Navigator.of(context);

      final data = AddExtraModel(
        serviceId: widget.serviceId,
        title: _titleController.text,
        description: _descriptionController.text,
        price: double.parse(_priceController.text),
      );

      await ManageServicesService().addExtra(data);

      navigator.pop();
      navigator.pop();
    } on DioException catch (error) {
      _onError(error.response?.data['message']);
    } catch (error) {
      _onError(error.toString());
    } finally {
      _toggleLoader(false);
    }
  }

  void _toggleLoader(bool state) {
    setState(() {
      _isLoading = state;
    });
  }

  void _onError(String error) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          icon: const Icon(
            CupertinoIcons.xmark_circle_fill,
            color: Colors.red,
            size: 40,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: const Text('Failed'),
          content: Text(
            error,
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
