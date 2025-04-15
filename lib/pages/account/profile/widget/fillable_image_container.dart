import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nearby_assist/pages/account/profile/widget/fillable_image_container_controller.dart';
import 'package:nearby_assist/utils/custom_snackbar.dart';

class FillableImageContainer extends StatefulWidget {
  const FillableImageContainer({
    super.key,
    required this.controller,
    required this.labelText,
    required this.icon,
    this.labelColor,
    this.iconColor,
    this.decoration,
    this.overlay,
    this.hintText = 'Tap to upload',
    this.source = ImageSource.gallery,
  });

  final FillableImageContainerController controller;
  final String labelText;
  final String hintText;
  final Color? labelColor;
  final IconData icon;
  final Color? iconColor;
  final Decoration? decoration;
  final WidgetStateProperty<Color>? overlay;
  final ImageSource source;

  @override
  State<FillableImageContainer> createState() => _FillableImageContainerState();
}

class _FillableImageContainerState extends State<FillableImageContainer> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: LayoutBuilder(
        builder: (context, constraints) => InkWell(
          overlayColor: widget.overlay ??
              WidgetStatePropertyAll(
                Colors.green[200],
              ),
          onTap: widget.source == ImageSource.gallery
              ? _pickImageFromGallery
              : _pickImageFromCamera,
          child: Ink(
            decoration: widget.decoration ??
                BoxDecoration(
                  color: Colors.green[100],
                  border: Border.all(color: Colors.green),
                  borderRadius: BorderRadius.circular(5),
                ),
            width: constraints.maxWidth,
            height: constraints.maxWidth,
            child: widget.controller.hasImage ? _filledState() : _emptyState(),
          ),
        ),
      ),
    );
  }

  Widget _filledState() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: FittedBox(
        fit: BoxFit.contain,
        child: Image.memory(widget.controller.image!),
      ),
    );
  }

  Widget _emptyState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          widget.labelText,
          style: TextStyle(
            color: widget.labelColor ?? Colors.green[700],
          ),
        ),
        const SizedBox(height: 10),
        Icon(
          widget.icon,
          color: widget.iconColor ?? Colors.green[400],
        ),
        const SizedBox(height: 10),
        Text(
          widget.hintText,
          style: TextStyle(
            fontSize: 12,
            color: widget.labelColor ?? Colors.green[700],
          ),
        ),
      ],
    );
  }

  Future<void> _pickImageFromGallery() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) {
      if (mounted) {
        showCustomSnackBar(context, 'No image selected');
      }
      return;
    }

    final imageBytes = await image.readAsBytes();
    setState(() {
      widget.controller.setImage(imageBytes);
    });
  }

  Future<void> _pickImageFromCamera() async {
    final image = await ImagePicker().pickImage(
      maxWidth: 800,
      maxHeight: 800,
      imageQuality: 80,
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.front,
    );
    if (image == null) {
      if (mounted) {
        showCustomSnackBar(context, 'No image selected');
      }
      return;
    }

    final cropped = await ImageCropper().cropImage(
      sourcePath: image.path,
      maxWidth: 600,
      maxHeight: 600,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      uiSettings: [
        AndroidUiSettings(
          cropStyle: CropStyle.rectangle,
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
          ],
        ),
        IOSUiSettings(
          cropStyle: CropStyle.rectangle,
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
          ],
        ),
      ],
    );
    if (cropped == null) {
      if (mounted) {
        showCustomSnackBar(context, 'Error cropping image');
      }
      return;
    }

    final imageBytes = await cropped.readAsBytes();
    setState(() {
      widget.controller.setImage(imageBytes);
    });
  }
}
