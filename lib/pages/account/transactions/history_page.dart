import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nearby_assist/models/booking_model.dart';
import 'package:nearby_assist/pages/account/transactions/transaction_summary_page.dart';
import 'package:nearby_assist/providers/transaction_provider.dart';
import 'package:nearby_assist/providers/user_provider.dart';
import 'package:provider/provider.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
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
                    'An error occurred while fetching data, please try again later',
                  ),
                ),
              );
            }

            final history = context.watch<TransactionProvider>().history;

            return RefreshIndicator(
              onRefresh: context.read<TransactionProvider>().fetchHistory,
              child: history.isEmpty ? _emptyState() : _mainContent(history),
            );
          }),
    );
  }

  Widget _mainContent(List<BookingModel> requests) {
    final user = context.read<UserProvider>().user;

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
                    TransactionSummaryPage(transaction: requests[index]),
              ),
            );
          },
          leading: Icon(
            requests[index].clientId == user.id
                ? CupertinoIcons.arrow_up
                : CupertinoIcons.arrow_down,
          ),
          title: Text(requests[index].vendor),
          subtitle: Text(
            requests[index].service.title,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: _chip(requests[index].status),
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

  Widget _chip(String label) {
    Color color;
    switch (label.toLowerCase()) {
      case 'done':
        color = Colors.green;
        break;
      case 'cancelled':
        color = Colors.grey;
        break;
      case 'rejected':
        color = Colors.red;
      default:
        color = Colors.grey;
    }

    return Chip(
      label: Text(label),
      labelStyle: const TextStyle(
        fontSize: 12,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      visualDensity: VisualDensity.compact,
      padding: const EdgeInsets.all(2),
      backgroundColor: color,
      shape: const RoundedRectangleBorder(
        side: BorderSide(color: Colors.transparent),
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
    );
  }
}
