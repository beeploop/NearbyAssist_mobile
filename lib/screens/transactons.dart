import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/services/transaction_service.dart';
import 'package:nearby_assist/widgets/custom_drawer.dart';

class Transactions extends StatelessWidget {
  const Transactions({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: const CustomDrawer(),
      body: Center(
        child: FutureBuilder(
          future: getIt.get<TransactionService>().fetchTransactions(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }

            if (snapshot.hasError) {
              final err = snapshot.error!;

              return Text(
                'An error occurred: $err',
                textAlign: TextAlign.center,
              );
            }

            return ListenableBuilder(
              listenable: getIt.get<TransactionService>(),
              builder: (context, _) {
                final transactions =
                    getIt.get<TransactionService>().getTransactions();

                return RefreshIndicator(
                  onRefresh: () async {
                    await getIt.get<TransactionService>().fetchTransactions();
                  },
                  child: ListView.builder(
                    itemCount: transactions.length,
                    itemBuilder: (context, index) {
                      final transaction = transactions[index];

                      return ListTile(
                        onTap: () {
                          context.goNamed('transaction-form', queryParameters: {
                            'transactionId': transaction.id.toString()
                          });
                        },
                        title: Text('Client: ${transaction.client}'),
                        subtitle: Text(
                          'created: ${transaction.createdAt}',
                        ),
                        trailing: Text(
                          transaction.status,
                          style: TextStyle(
                            color: switch (transaction.status) {
                              'ongoing' => Colors.yellow,
                              'done' => Colors.green,
                              'cancelled' => Colors.red,
                              _ => Colors.grey
                            },
                            fontSize: 16,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
