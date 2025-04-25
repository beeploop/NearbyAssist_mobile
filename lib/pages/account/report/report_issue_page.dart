import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:nearby_assist/pages/account/widget/input_field.dart';
import 'package:nearby_assist/services/report_issue_service.dart';
import 'package:nearby_assist/utils/custom_snackbar.dart';

class ReportIssuePage extends StatefulWidget {
  const ReportIssuePage({super.key});

  @override
  State<ReportIssuePage> createState() => _ReportIssuePageState();
}

class _ReportIssuePageState extends State<ReportIssuePage> {
  List<Uint8List> _images = [];
  final _titleController = TextEditingController();
  final _detailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'Bug Report',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InputField(
              controller: _titleController,
              labelText: 'Title',
              hintText: 'title of the issue',
            ),
            const SizedBox(height: 10),

            // Details
            InputField(
              controller: _detailController,
              hintText: 'Describe the bug you encountered',
              minLines: 4,
              maxLines: 8,
            ),
            const SizedBox(height: 10),

            // Images
            const SizedBox(height: 10),
            const Text('Images'),
            const SizedBox(height: 6),
            _buildImages(),
            const SizedBox(height: 20),

            // Submit Button
            FilledButton(
              style: const ButtonStyle(
                minimumSize: WidgetStatePropertyAll(Size.fromHeight(50)),
              ),
              onPressed: _submit,
              child: const Text('Submit'),
            ),

            // Bottom padding
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildImages() {
    return _images.isEmpty ? _imagesEmptyState() : _imagesFilledState();
  }

  Widget _imagesFilledState() {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        ..._images.map(
          (image) => LayoutBuilder(
            builder: (context, constraint) {
              return Container(
                height: constraint.maxWidth * 0.4,
                decoration: BoxDecoration(border: Border.all()),
                child: Image.memory(image, fit: BoxFit.contain),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _imagesEmptyState() {
    return Row(
      children: [
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) => InkWell(
              overlayColor: WidgetStatePropertyAll(
                Colors.green.shade200,
              ),
              onTap: _pickImageFromGallery,
              child: Ink(
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  border: Border.all(color: Colors.green),
                  borderRadius: BorderRadius.circular(5),
                ),
                width: constraints.maxWidth,
                height: constraints.maxWidth * 0.5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'select image',
                      style: TextStyle(
                        color: Colors.green.shade700,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Icon(
                      CupertinoIcons.photo,
                      color: Colors.green.shade400,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'tap to select',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.green.shade700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _pickImageFromGallery() async {
    final images = await ImagePicker().pickMultiImage();
    if (images.isEmpty) {
      if (mounted) {
        showCustomSnackBar(context, 'No image selected');
      }
      return;
    }

    List<Uint8List> imagesBytes = [];
    for (final image in images) {
      final bytes = await image.readAsBytes();
      imagesBytes.add(bytes);
    }

    setState(() {
      _images = imagesBytes;
    });
  }

  Future<void> _submit() async {
    final loader = context.loaderOverlay;

    try {
      loader.show();

      final service = ReportIssueService();
      await service.reportIssue(
        title: _titleController.text,
        detail: _detailController.text,
        images: _images,
      );

      _showSuccessModal();
    } catch (error) {
      _showErrorModal(error.toString());
    } finally {
      loader.hide();
    }
  }

  void _showSuccessModal() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          icon: const Icon(
            CupertinoIcons.check_mark_circled_solid,
            color: Colors.green,
            size: 40,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: const Text('Submitted'),
          content: const Text(
            'Thank you for your feedback. We will take this into consideration.',
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
              onPressed: () {
                context.pop();
                context.pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showErrorModal(String error) {
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
                context.pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
