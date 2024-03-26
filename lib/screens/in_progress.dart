import 'package:flutter/material.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/services/transaction_service.dart';
import 'package:nearby_assist/widgets/custom_drawer.dart';

class InProgress extends StatelessWidget {
  const InProgress({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: const CustomDrawer(),
      body: Center(
        child: FutureBuilder(
          future: getIt.get<TransactionService>().fetchInProgressTransactions(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }

            if (snapshot.hasError) {
              final err = snapshot.error.toString();
              return Text(
                'An error occurred: $err',
                textAlign: TextAlign.center,
              );
            }

            if (snapshot.hasData) {
              final transactions = snapshot.data;

              if (transactions == null || transactions.isEmpty) {
                return const Text('No transactions in progress');
              }

              return RefreshIndicator(
                onRefresh: () async {
                  await getIt
                      .get<TransactionService>()
                      .fetchInProgressTransactions();
                },
                child: ListView.builder(
                  itemCount: transactions.length,
                  itemBuilder: (context, index) {
                    final transaction = transactions[index];

                    return ListTile(
                      title: Text(transaction),
                    );
                  },
                ),
              );
            }

            return const Text('Something went wrong');
          },
        ),
      ),
    );
  }
}
