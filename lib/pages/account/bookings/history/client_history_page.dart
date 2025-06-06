import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nearby_assist/models/booking_model.dart';
import 'package:nearby_assist/pages/account/bookings/history/client_history_list_item.dart';
import 'package:nearby_assist/pages/account/bookings/history/client_history_detail_page.dart';
import 'package:nearby_assist/providers/client_booking_provider.dart';
import 'package:provider/provider.dart';

class ClientHistoryPage extends StatefulWidget {
  const ClientHistoryPage({super.key});

  @override
  State<ClientHistoryPage> createState() => _ClientHistoryPageState();
}

class _ClientHistoryPageState extends State<ClientHistoryPage> {
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
      body: Consumer<ClientBookingProvider>(
        builder: (context, provider, _) {
          return RefreshIndicator(
            onRefresh: provider.fetchHistory,
            child: provider.history.isEmpty
                ? _emptyState()
                : _mainContent(provider.history),
          );
        },
      ),
    );
  }

  Widget _mainContent(List<BookingModel> requests) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ListView.separated(
        separatorBuilder: (context, index) => const Divider(),
        itemCount: requests.length,
        itemBuilder: (context, index) => ClientHistoryListItem(
          booking: requests[index],
          onTap: () {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) =>
                    ClientHistoryDetailPage(booking: requests[index]),
              ),
            );
          },
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
