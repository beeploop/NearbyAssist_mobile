import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nearby_assist/pages/account/report/report_user_page.dart';
import 'package:nearby_assist/pages/account/report/widget/reason_tile.dart';

class ReportUserReasonPage extends StatelessWidget {
  const ReportUserReasonPage({super.key, required this.userId});

  final String userId;

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
              ReasonTile(
                title: 'Sexual message/images',
                onPress: () => _handleClick(context, 'Sexual message/images'),
              ),
              ReasonTile(
                title: 'Offensive messages/images',
                onPress: () =>
                    _handleClick(context, 'Offensive message/images'),
              ),
              ReasonTile(
                title: 'Other',
                onPress: () => _handleClick(context, 'Other'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleClick(BuildContext context, String reason) {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => ReportUserPage(userId: userId, reason: reason),
      ),
    );
  }
}
