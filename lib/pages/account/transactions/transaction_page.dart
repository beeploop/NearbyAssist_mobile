import 'package:flutter/material.dart';
import 'package:nearby_assist/pages/account/transactions/widget/grid_section.dart';
import 'package:nearby_assist/pages/account/transactions/widget/recent_transaction.dart';

class TransactionPage extends StatelessWidget {
  const TransactionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Transactions',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: const Padding(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              GridSection(),
              SizedBox(height: 20),
              Divider(),
              SizedBox(height: 10),
              RecentTransaction(),
            ],
          ),
        ),
      ),
    );
  }
}
