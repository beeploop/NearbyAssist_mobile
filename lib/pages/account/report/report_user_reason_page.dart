import 'package:auto_size_text/auto_size_text.dart';
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
        centerTitle: true,
        title: const Text(
          'Bug Report',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AutoSizeText(
                'Select Reason',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 20),

              // Reason options
              ..._buildOptions(context),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildOptions(BuildContext context) {
    final options = reasons.where((reason) {
      if (bookingId == null) {
        if (reason.category == ReportCategory.bookingRelated) {
          return false;
        }
      }

      return true;
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
