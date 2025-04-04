import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nearby_assist/models/booking_model.dart';
import 'package:nearby_assist/pages/account/bookings/sent_request_summary_page.dart';
import 'package:nearby_assist/pages/account/bookings/widget/booking_status_chip.dart';
import 'package:nearby_assist/providers/booking_provider.dart';
import 'package:provider/provider.dart';

class SentRequestPage extends StatefulWidget {
  const SentRequestPage({super.key});

  @override
  State<SentRequestPage> createState() => _SentRequestPageState();
}

class _SentRequestPageState extends State<SentRequestPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Sent Requests',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: FutureBuilder(
        future: context.read<BookingProvider>().fetchSentRequests(),
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

          final requests = context.watch<BookingProvider>().sentRequests;

          return RefreshIndicator(
            onRefresh: context.read<BookingProvider>().fetchSentRequests,
            child: requests.isEmpty ? _emptyState() : _mainContent(requests),
          );
        },
      ),
    );
  }

  Widget _mainContent(List<BookingModel> requests) {
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
                builder: (context) => SentRequestSummaryPage(
                  booking: requests[index],
                  showChatIcon: true,
                ),
              ),
            );
          },
          title: Text(requests[index].vendor.name),
          subtitle: Text(
            requests[index].service.title,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: BookingStatusChip(status: requests[index].status),
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
