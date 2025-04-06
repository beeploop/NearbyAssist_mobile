import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class VendorToolItem extends StatelessWidget {
  const VendorToolItem({
    super.key,
    required this.count,
    required this.icon,
    required this.label,
    required this.onPressed,
    this.iconColor,
    this.labelColor,
    this.backgroundColor,
  });

  final int count;
  final IconData icon;
  final Color? iconColor;
  final String label;
  final Color? labelColor;
  final Color? backgroundColor;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: IconButton(
                    icon: Icon(
                      icon,
                      size: constraints.maxWidth / 4,
                      color: iconColor,
                    ),
                    onPressed: () => onPressed(),
                  ),
                ),
                if (count >= 1)
                  Positioned(
                    top: -14,
                    right: -6,
                    child: GestureDetector(
                      onTap: () => onPressed(),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.red,
                          border: Border.all(
                            color: Colors.red,
                          ),
                        ),
                        child: Text(
                          '${count > 99 ? 99 : count}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: count > 9 ? 14 : 18,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 8),

            // Label
            AutoSizeText(label, style: TextStyle(color: labelColor)),
          ],
        );
      },
    );
  }
}
