import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nearby_assist/pages/account/transactions/widget/grid_item.dart';

class GridSection extends StatelessWidget {
  const GridSection({
    super.key,
    this.spacing = 10,
  });

  final double spacing;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: GridItem(
                background: Colors.teal.shade400,
                icon: CupertinoIcons.arrow_down_circle,
                label: 'Client Requests',
                onTap: () {},
              ),
            ),
            SizedBox(width: spacing),
            Expanded(
              child: GridItem(
                background: Colors.pink.shade300,
                icon: CupertinoIcons.arrow_up_circle,
                label: 'My Requests',
                onTap: () {},
              ),
            ),
          ],
        ),
        SizedBox(height: spacing),
        Row(
          children: [
            Expanded(
              child: GridItem(
                background: Colors.cyan.shade400,
                icon: CupertinoIcons.arrow_clockwise_circle,
                label: 'Ongoing',
                onTap: () {},
              ),
            ),
            SizedBox(width: spacing),
            Expanded(
              child: GridItem(
                background: Colors.amber.shade400,
                icon: CupertinoIcons.chart_pie,
                label: 'History',
                onTap: () {},
              ),
            ),
          ],
        ),
      ],
    );
  }
}
