import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nearby_assist/models/booking_model.dart';
import 'package:nearby_assist/pages/account/bookings/pending/pending_request_list_item.dart';
import 'package:nearby_assist/pages/account/bookings/pending/pending_request_summary_page.dart';
import 'package:nearby_assist/providers/client_booking_provider.dart';
import 'package:provider/provider.dart';

class PendingRequestPage extends StatefulWidget {
  const PendingRequestPage({super.key});

  @override
  State<PendingRequestPage> createState() => _PendingRequestPageState();
}

class _PendingRequestPageState extends State<PendingRequestPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Pending Bookings',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Consumer<ClientBookingProvider>(
        builder: (context, provider, _) {
          return RefreshIndicator(
            onRefresh: provider.fetchPending,
            child: provider.pending.isEmpty
                ? _emptyState()
                : _mainContent(provider.pending),
          );
        },
      ),
    );
  }

  Widget _mainContent(List<BookingModel> requests) {
    return ListView.separated(
      separatorBuilder: (context, index) => const Divider(),
      itemCount: requests.length,
      itemBuilder: (context, index) => PendingRequestListItem(
        booking: requests[index],
        onTap: () {
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => PendingRequestSummaryPage(
                booking: requests[index],
              ),
            ),
          );
        },
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
