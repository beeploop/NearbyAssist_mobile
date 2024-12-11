import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nearby_assist/utils/custom_snackbar.dart';

class ServiceGallery extends StatefulWidget {
  const ServiceGallery({
    super.key,
    required this.images,
  });

  final List<Uint8List> images;

  @override
  State<ServiceGallery> createState() => _ServiceGalleryState();
}

class _ServiceGalleryState extends State<ServiceGallery> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Gallery',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        _imageField(),
      ],
    );
  }

  Widget _imageField() {
    return Row(
      children: [
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) => InkWell(
              overlayColor: WidgetStatePropertyAll(
                Colors.green[200],
              ),
              onTap: () => _handlePickImage(),
              child: Ink(
                decoration: BoxDecoration(
                  color: Colors.green[100],
                  border: Border.all(color: Colors.green),
                  borderRadius: BorderRadius.circular(5),
                ),
                width: constraints.maxWidth,
                height: constraints.maxWidth,
                child: widget.images.isEmpty ? _emptyState() : _imageList(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _imageList() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: widget.images.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(5),
          child: Image.memory(
            widget.images[index],
            width: 100,
            height: 100,
            fit: BoxFit.contain,
          ),
        );
      },
    );
  }

  Widget _emptyState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Add Image',
          style: TextStyle(
            color: Colors.green[700],
          ),
        ),
        const SizedBox(height: 10),
        Icon(
          CupertinoIcons.photo_on_rectangle,
          color: Colors.green[400],
        ),
        const SizedBox(height: 10),
        Text(
          'Tap to add image',
          style: TextStyle(
            fontSize: 12,
            color: Colors.green[700],
          ),
        ),
      ],
    );
  }

  Future<void> _handlePickImage() async {
    final images = await ImagePicker().pickMultiImage(limit: 3);
    if (images.isEmpty) {
      if (mounted) {
        showCustomSnackBar(context, 'No image selected');
      }
      return;
    }

    for (final image in images) {
      final imageBytes = await image.readAsBytes();
      setState(() {
        widget.images.add(imageBytes);
      });
    }
  }
}
