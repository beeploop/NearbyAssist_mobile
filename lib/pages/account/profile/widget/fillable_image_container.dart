import 'package:flutter/material.dart';
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
  });

  final FillableImageContainerController controller;
  final String labelText;
  final Color? labelColor;
  final IconData icon;
  final Color? iconColor;
  final Decoration? decoration;
  final WidgetStateProperty<Color>? overlay;

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
          onTap: _handleTap,
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
          'Tap to upload',
          style: TextStyle(
            fontSize: 12,
            color: widget.labelColor ?? Colors.green[700],
          ),
        ),
      ],
    );
  }

  void _handleTap() {
    showCustomSnackBar(context, 'Image picker not implemented yet');
  }
}
