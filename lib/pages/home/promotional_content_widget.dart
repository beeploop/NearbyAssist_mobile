import 'package:flutter/material.dart';

class PromotionalContentWidget extends StatelessWidget {
  const PromotionalContentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: SizedBox(
        height: 200,
        width: double.infinity,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.green[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              "Some promotional content",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.green[400],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
