import 'package:flutter/material.dart';
import 'package:nearby_assist/pages/home/promotional_content_widget.dart';
import 'package:nearby_assist/pages/widget/notification_bell.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: const [
          NotificationBell(),
          SizedBox(width: 10),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ListView.builder(
          itemCount: 4,
          itemBuilder: (context, index) => const PromotionalContentWidget(),
        ),
      ),
    );
  }
}