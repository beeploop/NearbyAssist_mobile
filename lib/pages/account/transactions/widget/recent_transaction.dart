import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nearby_assist/models/booking_model.dart';
import 'package:nearby_assist/pages/account/transactions/accepted_request_summary_page.dart';
import 'package:nearby_assist/pages/account/transactions/received_request_summary_page.dart';
import 'package:nearby_assist/pages/account/transactions/sent_request_summary_page.dart';
import 'package:nearby_assist/pages/account/transactions/transaction_summary_page.dart';
import 'package:nearby_assist/providers/transaction_provider.dart';
import 'package:nearby_assist/providers/user_provider.dart';
import 'package:provider/provider.dart';

class RecentTransaction extends StatefulWidget {
  const RecentTransaction({super.key});

  @override
  State<RecentTransaction> createState() => _RecentTransactionState();
}

class _RecentTransactionState extends State<RecentTransaction> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recent Transactions',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        _fetchAndBuildList(),
      ],
    );
  }

  Widget _fetchAndBuildList() {
    return FutureBuilder(
      future: context.read<TransactionProvider>().fetchRecent(),
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
                'An error occurred while fetching recents. Please try again later',
              ),
            ),
          );
        }

        final recents = context.watch<TransactionProvider>().recents;
        return _buildList(recents);
      },
    );
  }

  Widget _buildList(List<BookingModel> recents) {
    final user = context.read<UserProvider>().user;

    return ListView.separated(
      shrinkWrap: true,
      separatorBuilder: (context, index) => const SizedBox(),
      itemCount: recents.length,
      itemBuilder: (context, index) => ListTile(
        onTap: () {
          // Navigate to history summary page if status == 'done'
          if (recents[index].status == 'done') {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) =>
                    TransactionSummaryPage(transaction: recents[index]),
              ),
            );
            return;
          }

          if (recents[index].clientId == user.id) {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) =>
                    SentRequestSummaryPage(transaction: recents[index]),
              ),
            );
            return;
          } else {
            if (recents[index].status == 'confirmed') {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) =>
                      AcceptedRequestSummaryPage(transaction: recents[index]),
                ),
              );
              return;
            }

            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) =>
                    ReceivedRequestSummaryPage(transaction: recents[index]),
              ),
            );
            return;
          }
        },
        dense: true,
        leading: Icon(
          recents[index].clientId == user.id
              ? CupertinoIcons.arrow_up
              : CupertinoIcons.arrow_down,
          color: recents[index].clientId == user.id
              ? Colors.teal.shade400
              : Colors.pink.shade300,
        ),
        title: Text(
          recents[index].clientId == user.id
              ? 'vendor: ${recents[index].vendor}'
              : 'client: ${recents[index].client}',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        subtitle: Text(
          recents[index].service.title,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: _chip(recents[index].status),
      ),
    );
  }

  Widget _chip(String label) {
    Color color;
    switch (label.toLowerCase()) {
      case 'pending':
        color = Colors.orange;
        break;
      case 'confirmed':
        color = Colors.teal;
        break;
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
