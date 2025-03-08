import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class ReasonTile extends StatelessWidget {
  const ReasonTile({
    super.key,
    required this.title,
    required this.onPress,
  });

  final String title;
  final VoidCallback onPress;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      overlayColor: WidgetStateProperty.all(Colors.grey.withOpacity(0.2)),
      onTap: onPress,
      child: Ink(
        width: MediaQuery.of(context).size.width,
        height: 60,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            AutoSizeText(title),
            const Spacer(),
            Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: Colors.grey.withOpacity(0.1),
                ),
                child: const Icon(Icons.chevron_right_sharp,
                    size: 18.0, color: Colors.grey))
          ],
        ),
      ),
    );
  }
}
