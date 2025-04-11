import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:nearby_assist/config/report.dart';
import 'package:nearby_assist/models/report_user_model.dart';
import 'package:nearby_assist/pages/account/widget/input_field.dart';
import 'package:nearby_assist/services/report_issue_service.dart';
import 'package:nearby_assist/utils/custom_snackbar.dart';

class ReportUserPage extends StatefulWidget {
  const ReportUserPage({
    super.key,
    required this.userId,
    required this.reason,
    required this.category,
    this.bookingId,
  });

  final String userId;
  final String reason;
  final ReportCategory category;
  final String? bookingId; // Include this if category is booking related

  @override
  State<ReportUserPage> createState() => _ReportUserPageState();
}

class _ReportUserPageState extends State<ReportUserPage> {
  List<Uint8List> _images = [];
  final _detailController = TextEditingController();
  bool _submittable = false;

  @override
  void initState() {
    super.initState();

    _detailController.addListener(_inputListener);
  }

  @override
  void dispose() {
    _detailController.removeListener(_inputListener);
    super.dispose();
  }

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
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Reason
                const SizedBox(height: 10),
                AutoSizeText(widget.reason),
                const Divider(),
                const SizedBox(height: 20),

                // Detail
                const AutoSizeText('Reason'),
                const SizedBox(height: 5),
                InputField(
                  controller: _detailController,
                  hintText: 'Further elaborate your selected reason',
                  minLines: 4,
                  maxLines: 8,
                ),
                const SizedBox(height: 20),

                // Images
                const AutoSizeText('Supporting Images'),
                const SizedBox(height: 5),
                _buildImages(),

                // Bottom padding
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: FilledButton(
            onPressed: _submittable ? _handleSubmit : () {},
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(
                !_submittable ? Colors.grey : null,
              ),
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            child: const Text('Submit'),
          ),
        ),
      ),
    );
  }

  void _inputListener() {
    if (_detailController.text.isNotEmpty && _images.isNotEmpty) {
      setState(() {
        _submittable = true;
      });
    } else {
      setState(() {
        _submittable = false;
      });
    }
  }

  Widget _buildImages() {
    return _images.isEmpty ? _imagesEmptyState() : _imagesFilledState();
  }

  Widget _imagesFilledState() {
    return GridView(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
      ),
      shrinkWrap: true,
      children: _images
          .map(
            (image) => Container(
              decoration: BoxDecoration(border: Border.all()),
              child: Image.memory(image, fit: BoxFit.contain),
            ),
          )
          .toList(),
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
                  color: Colors.green[100],
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

    // recheck if submittable
    _inputListener();
  }

  Future<void> _handleSubmit() async {
    final loader = context.loaderOverlay;

    try {
      loader.show();

      if (_detailController.text.trim().isEmpty || _images.isEmpty) {
        throw "Don't leave empty fields";
      }

      final report = ReportUserModel(
        userId: widget.userId,
        category: widget.category,
        bookingId: widget.bookingId,
        reason: widget.reason,
        detail: _detailController.text,
        images: _images,
      );

      await ReportIssueService().reportUser(report);

      _showSuccessModal();
    } catch (error) {
      _onError(error.toString());
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
            'Your report has been submitted. We will review and investigate.',
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
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
