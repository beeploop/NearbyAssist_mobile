import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nearby_assist/pages/account/transactions/received_request_page.dart';
import 'package:nearby_assist/pages/account/transactions/history_page.dart';
import 'package:nearby_assist/pages/account/transactions/sent_request_page.dart';
import 'package:nearby_assist/pages/account/transactions/confirmed_request_page.dart';
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
                background: Colors.pink.shade300,
                icon: CupertinoIcons.arrow_down_circle,
                label: 'Received Requests',
                onTap: () => _handleClientRequestTap(context),
              ),
            ),
            SizedBox(width: spacing),
            Expanded(
              child: GridItem(
                background: Colors.teal.shade400,
                icon: CupertinoIcons.arrow_up_circle,
                label: 'Sent Requests',
                onTap: () => _handleMyRequestTap(context),
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
                label: 'Accepted Requests',
                onTap: () => _handleConfirmedTap(context),
              ),
            ),
            SizedBox(width: spacing),
            Expanded(
              child: GridItem(
                background: Colors.orange.shade400,
                icon: CupertinoIcons.chart_pie,
                label: 'History',
                onTap: () => _handleHistoryTap(context),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _handleClientRequestTap(BuildContext context) {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => const ReceivedRequestPage(),
      ),
    );
  }

  void _handleMyRequestTap(BuildContext context) {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => const SentRequestPage(),
      ),
    );
  }

  void _handleConfirmedTap(BuildContext context) {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => const ConfirmedRequestPage(),
      ),
    );
  }

  void _handleHistoryTap(BuildContext context) {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => const HistoryPage(),
      ),
    );
  }
}
