import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nearby_assist/models/add_extra_model.dart';
import 'package:nearby_assist/providers/managed_service_provider.dart';
import 'package:provider/provider.dart';

class AddExtraPage extends StatefulWidget {
  const AddExtraPage({super.key, required this.serviceId});

  final String serviceId;

  @override
  State<AddExtraPage> createState() => _AddExtraPageState();
}

class _AddExtraPageState extends State<AddExtraPage> {
  bool _isLoading = false;
  bool _fieldsHasValues = false;
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
              'Create Add-on',
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
              onChanged: _listenToInput,
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
              onChanged: _listenToInput,
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
              onChanged: _listenToInput,
              onTapOutside: (_) =>
                  FocusManager.instance.primaryFocus?.unfocus(),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            // Save button
            FilledButton(
              style: ButtonStyle(
                minimumSize: const WidgetStatePropertyAll(Size.fromHeight(50)),
                backgroundColor: WidgetStatePropertyAll(
                  !_fieldsHasValues ? Colors.grey : null,
                ),
              ),
              onPressed: _fieldsHasValues ? _handleSave : () {},
              child: const Text('Save'),
            ),

            // Bottom padding
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _listenToInput(String v) {
    if (_titleController.text.isNotEmpty &&
        _descriptionController.text.isNotEmpty &&
        _priceController.text.isNotEmpty) {
      setState(() {
        _fieldsHasValues = true;
      });
    } else {
      setState(() {
        _fieldsHasValues = false;
      });
    }
  }

  Future<void> _handleSave() async {
    try {
      _toggleLoader(true);

      if (_titleController.text.isEmpty ||
          _descriptionController.text.isEmpty ||
          _priceController.text.isEmpty) {
        throw "Don't leave empty fields";
      }

      final navigator = Navigator.of(context);
      final provider = context.read<ManagedServiceProvider>();

      final data = AddExtraModel(
        serviceId: widget.serviceId,
        title: _titleController.text,
        description: _descriptionController.text,
        price: double.parse(_priceController.text),
      );

      await provider.addExtra(data);

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
