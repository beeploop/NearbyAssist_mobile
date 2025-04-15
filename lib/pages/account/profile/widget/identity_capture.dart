import 'package:capture_identity/capture_identity.dart';
import 'package:flutter/material.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/pages/account/profile/widget/fillable_image_container_controller.dart';

class IdentityCapture extends StatefulWidget {
  const IdentityCapture({
    super.key,
    required this.controller,
    required this.hintText,
    required this.labelText,
    required this.icon,
    this.labelColor,
    this.iconColor,
  });

  final FillableImageContainerController controller;
  final String hintText;
  final String labelText;
  final IconData icon;
  final Color? labelColor;
  final Color? iconColor;

  @override
  State<IdentityCapture> createState() => _IdentityCaptureState();
}

class _IdentityCaptureState extends State<IdentityCapture> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraint) {
        return InkWell(
          onTap: _handleCapture,
          child: Ink(
            decoration: BoxDecoration(
              color: Colors.green[100],
              border: Border.all(color: Colors.green),
              borderRadius: BorderRadius.circular(5),
            ),
            width: constraint.maxWidth,
            height: constraint.maxWidth * 0.5,
            child: Center(
              child: widget.controller.hasImage
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: Image.memory(widget.controller.image!),
                      ),
                    )
                  : _emptyState(),
            ),
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
          widget.labelText,
          style: TextStyle(
            color: widget.labelColor ?? Colors.green.shade800,
          ),
        ),
        const SizedBox(height: 10),
        Icon(
          widget.icon,
          color: widget.iconColor ?? Colors.green.shade400,
        ),
        const SizedBox(height: 10),
        Text(
          widget.hintText,
          style: TextStyle(
            fontSize: 12,
            color: widget.labelColor ?? Colors.green.shade800,
          ),
        ),
      ],
    );
  }

  Future<void> _handleCapture() async {
    try {
      final image = await showCapture(
        context: context,
        title: 'Scan ID',
        hideIdWidget: false,
      );
      if (image == null) {
        throw 'no image selected';
      }

      final bytes = await image.readAsBytes();
      setState(() {
        widget.controller.setImage(bytes);
      });
    } catch (error) {
      logger.logDebug(error.toString());
    }
  }
}
