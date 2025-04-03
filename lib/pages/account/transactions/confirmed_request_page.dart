import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nearby_assist/models/transaction_model.dart';
import 'package:nearby_assist/pages/account/transactions/accepted_request_summary_page.dart';
import 'package:nearby_assist/pages/account/transactions/widget/transaction_status_chip.dart';
import 'package:nearby_assist/providers/transaction_provider.dart';
import 'package:provider/provider.dart';

class ConfirmedRequestPage extends StatefulWidget {
  const ConfirmedRequestPage({super.key});

  @override
  State<ConfirmedRequestPage> createState() => _ConfirmedRequestPageState();
}

class _ConfirmedRequestPageState extends State<ConfirmedRequestPage> {
  @override
  Widget build(BuildContext context) {
    final confirmed = context.watch<TransactionProvider>().accepted;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Ongoing',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: context.read<TransactionProvider>().fetchAccepted,
        child: confirmed.isEmpty ? _emptyState() : _mainContent(confirmed),
      ),
    );
  }

  Widget _mainContent(List<TransactionModel> requests) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: ListView.separated(
        separatorBuilder: (context, index) => const Divider(),
        itemCount: requests.length,
        itemBuilder: (context, index) => ListTile(
          onTap: () {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) =>
                    AcceptedRequestSummaryPage(transaction: requests[index]),
              ),
            );
          },
          title: Text(requests[index].vendor),
          subtitle: Text(
            requests[index].service.title,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: TransactionStatusChip(status: requests[index].status),
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
