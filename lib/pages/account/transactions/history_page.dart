import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nearby_assist/providers/transaction_provider.dart';
import 'package:provider/provider.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'History',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: FutureBuilder(
        future: context.read<TransactionProvider>().fetchHistory(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return const Center(
              child: AlertDialog(
                icon: Icon(CupertinoIcons.exclamationmark_triangle),
                title: Text('Something went wrong'),
                content: Text(
                  'An error occurred while fetching data. Please try again later',
                ),
              ),
            );
          }

          return _mainContent();
        },
      ),
    );
  }

  Widget _mainContent() {
    return const Center(
      child: Column(
        children: [
          Icon(CupertinoIcons.arrow_down_circle),
          Text('Client Request Page'),
        ],
      ),
    );
  }
}
