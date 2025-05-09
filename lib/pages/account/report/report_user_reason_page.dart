import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nearby_assist/config/report.dart';
import 'package:nearby_assist/pages/account/report/report_user_page.dart';
import 'package:nearby_assist/pages/account/report/widget/reason_tile.dart';

class ReportUserReasonPage extends StatelessWidget {
  const ReportUserReasonPage({
    super.key,
    required this.userId,
    this.bookingId,
  });

  final String userId;
  final String? bookingId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Reason'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Reason options
            const Text(
              'General reasons',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            ..._buildMisconductReasons(context),
            const SizedBox(height: 10),

            if (bookingId != null)
              const Text(
                'Booking related reasons',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),

            if (bookingId != null) ..._buildBookingRelatedReasons(context),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildMisconductReasons(BuildContext context) {
    final options = reasons.where((reason) {
      if (reason.category == ReportCategory.misconduct) {
        return true;
      }
      return false;
    }).toList();

    return options
        .map((option) => ReasonTile(
              title: option.title,
              onPress: () => _handleClick(context, option),
            ))
        .toList();
  }

  List<Widget> _buildBookingRelatedReasons(BuildContext context) {
    final options = reasons.where((reason) {
      if (reason.category == ReportCategory.bookingRelated) {
        return true;
      }
      return false;
    }).toList();

    return options
        .map((option) => ReasonTile(
              title: option.title,
              onPress: () => _handleClick(context, option),
            ))
        .toList();
  }

  void _handleClick(BuildContext context, ReportReason reason) {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => ReportUserPage(
          userId: userId,
          reason: reason.title,
          category: reason.category,
          bookingId: bookingId,
        ),
      ),
    );
  }
}
