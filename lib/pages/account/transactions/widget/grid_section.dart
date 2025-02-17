import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nearby_assist/pages/account/transactions/received_request_page.dart';
import 'package:nearby_assist/pages/account/transactions/history_page.dart';
import 'package:nearby_assist/pages/account/transactions/sent_request_page.dart';
import 'package:nearby_assist/pages/account/transactions/accepted_request_page.dart';
import 'package:nearby_assist/pages/account/transactions/to_rate_page.dart';
import 'package:nearby_assist/pages/account/transactions/widget/grid_item.dart';

class GridSection extends StatelessWidget {
  const GridSection({
    super.key,
    this.rowCount = 3,
    this.spacing = 10,
  });

  final int rowCount;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return GridView(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: rowCount,
        mainAxisSpacing: spacing,
        crossAxisSpacing: spacing,
      ),
      shrinkWrap: true,
      padding: const EdgeInsets.all(4),
      children: [
        GridItem(
          background: Colors.pink.shade300,
          icon: CupertinoIcons.arrow_down_circle,
          label: 'Received',
          onTap: () => _handleClientRequestTap(context),
        ),
        GridItem(
          background: Colors.teal.shade400,
          icon: CupertinoIcons.arrow_up_circle,
          label: 'Sent',
          onTap: () => _handleMyRequestTap(context),
        ),
        GridItem(
          background: Colors.cyan.shade400,
          icon: CupertinoIcons.checkmark_circle,
          label: 'Accepted',
          onTap: () => _handleConfirmedTap(context),
        ),
        GridItem(
          background: Colors.purple.shade700,
          icon: CupertinoIcons.chart_pie,
          label: 'History',
          onTap: () => _handleHistoryTap(context),
        ),
        GridItem(
          background: Colors.orange.shade400,
          icon: CupertinoIcons.star_circle,
          label: 'To Rate',
          onTap: () => _handleReviewTap(context),
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
        builder: (context) => const AcceptedRequestPage(),
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

  void _handleReviewTap(BuildContext context) {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => const ToRatePage(),
      ),
    );
  }
}
