import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nearby_assist/models/transaction_model.dart';
import 'package:nearby_assist/pages/account/transactions/rate_page.dart';
import 'package:nearby_assist/pages/account/transactions/to_rate_summary_page.dart';
import 'package:nearby_assist/providers/transaction_provider.dart';
import 'package:provider/provider.dart';

class ToRatePage extends StatefulWidget {
  const ToRatePage({super.key});

  @override
  State<ToRatePage> createState() => _ToRatePageState();
}

class _ToRatePageState extends State<ToRatePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'To Rate',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: FutureBuilder(
        future: context.read<TransactionProvider>().fetchToReviewTransactions(),
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
                  'An error occurred while fetching data, please try again later',
                ),
              ),
            );
          }

          final reviewables = context.watch<TransactionProvider>().toReviews;

          return RefreshIndicator(
            onRefresh:
                context.read<TransactionProvider>().fetchToReviewTransactions,
            child:
                reviewables.isEmpty ? _emptyState() : _buildBody(reviewables),
          );
        },
      ),
    );
  }

  Widget _buildBody(List<TransactionModel> transactions) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ListView.separated(
        itemCount: transactions.length,
        separatorBuilder: (context, index) => const Divider(),
        itemBuilder: (context, index) => ListTile(
          leading: const Icon(CupertinoIcons.checkmark_circle),
          title: Text(transactions[index].vendor.name),
          subtitle: Text(
            transactions[index].service.title,
            overflow: TextOverflow.ellipsis,
          ),
          onTap: () {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => ToRateSummaryPage(
                  transaction: transactions[index],
                ),
              ),
            );
          },
          trailing: FilledButton(
            onPressed: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => RatePage(
                    transaction: transactions[index],
                  ),
                ),
              );
            },
            child: const Text('Review'),
          ),
        ),
      ),
    );
  }

  Widget _emptyState() {
    return ListView(
      children: [
        SingleChildScrollView(
          child: Container(
            alignment: Alignment.center,
            height: MediaQuery.of(context).size.height,
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    CupertinoIcons.tray,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'No requests',
                    style: TextStyle(color: Colors.grey),
                  ),
                  Text(
                    'Pull down to refresh',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
