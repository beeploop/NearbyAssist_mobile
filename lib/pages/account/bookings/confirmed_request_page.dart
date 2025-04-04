import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nearby_assist/models/booking_model.dart';
import 'package:nearby_assist/pages/account/bookings/accepted_request_summary_page.dart';
import 'package:nearby_assist/pages/account/bookings/widget/booking_status_chip.dart';
import 'package:nearby_assist/providers/booking_provider.dart';
import 'package:provider/provider.dart';

class ConfirmedRequestPage extends StatefulWidget {
  const ConfirmedRequestPage({super.key});

  @override
  State<ConfirmedRequestPage> createState() => _ConfirmedRequestPageState();
}

class _ConfirmedRequestPageState extends State<ConfirmedRequestPage> {
  @override
  Widget build(BuildContext context) {
    final confirmed = context.watch<BookingProvider>().accepted;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Ongoing',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: context.read<BookingProvider>().fetchAccepted,
        child: confirmed.isEmpty ? _emptyState() : _mainContent(confirmed),
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
                builder: (context) =>
                    AcceptedRequestSummaryPage(booking: requests[index]),
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
