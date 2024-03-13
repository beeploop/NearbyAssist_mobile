import 'package:flutter/material.dart';

class ReviewCounterBar extends StatefulWidget {
  const ReviewCounterBar({super.key});

  @override
  State<ReviewCounterBar> createState() => _ReviewCounterBar();
}

class _ReviewCounterBar extends State<ReviewCounterBar> {
  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Row(
          children: [
            SizedBox(width: 20, child: Text('5')),
            Expanded(
              child: LinearProgressIndicator(
                value: 0.5,
                minHeight: 8,
              ),
            )
          ],
        ),
        Row(
          children: [
            SizedBox(width: 20, child: Text('4')),
            Expanded(
              child: LinearProgressIndicator(
                value: 0.8,
                minHeight: 8,
              ),
            )
          ],
        ),
        Row(
          children: [
            SizedBox(width: 20, child: Text('3')),
            Expanded(
              child: LinearProgressIndicator(
                value: 0.2,
                minHeight: 8,
              ),
            )
          ],
        ),
        Row(
          children: [
            SizedBox(width: 20, child: Text('2')),
            Expanded(
              child: LinearProgressIndicator(
                value: 0.1,
                minHeight: 8,
              ),
            )
          ],
        ),
        Row(
          children: [
            SizedBox(width: 20, child: Text('1')),
            Expanded(
              child: LinearProgressIndicator(
                value: 0.5,
                minHeight: 8,
              ),
            )
          ],
        ),
      ],
    );
  }
}
