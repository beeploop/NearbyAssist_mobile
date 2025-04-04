import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class GridItem extends StatelessWidget {
  const GridItem({
    super.key,
    required this.background,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final Color background;
  final IconData icon;
  final String label;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      overlayColor: WidgetStateProperty.all(Colors.white.withOpacity(0.2)),
      onTap: () => onTap(),
      child: Ink(
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            const Spacer(),
            FittedBox(
              fit: BoxFit.contain,
              child: Icon(
                icon,
                color: Colors.white,
                size: 30,
              ),
            ),
            const SizedBox(height: 5),
            FittedBox(
              fit: BoxFit.fitWidth,
              child: AutoSizeText(
                label,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
