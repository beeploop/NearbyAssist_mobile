import 'package:flutter/material.dart';
import 'package:nearby_assist/main.dart';

class RowItem extends StatelessWidget {
  const RowItem({
    super.key,
    required this.title,
    required this.icon,
    required this.status,
  });

  final String title;
  final IconData icon;
  final String status;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      overlayColor: WidgetStateProperty.all(Colors.white.withOpacity(0.2)),
      onTap: _onTap,
      child: Ink(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Icon(icon),
            const SizedBox(width: 10),
            Text(title),
            const SizedBox(width: 10),
            Text(status),
          ],
        ),
      ),
    );
  }

  void _onTap() {
    logger.log('Tapped');
  }
}
