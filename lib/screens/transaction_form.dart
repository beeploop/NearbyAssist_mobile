import 'package:flutter/material.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/services/transaction_service.dart';
import 'package:nearby_assist/widgets/text_heading.dart';

class TransactionForm extends StatefulWidget {
  const TransactionForm({super.key, required this.transactionId});

  final int transactionId;

  @override
  State createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder(
        future: getIt
            .get<TransactionService>()
            .fetchTransactionDetail(widget.transactionId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            final error = snapshot.error!;
            return Center(child: Text('Error occurred: $error'));
          }

          // final data = snapshot.data!;

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              TextHeading(
                title: 'Transaction ID: ${widget.transactionId}',
                alignment: TextAlign.start,
                fontSize: 16,
              )
            ],
          );
        },
      ),
    );
  }
}
