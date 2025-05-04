import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nearby_assist/models/booking_model.dart';
import 'package:nearby_assist/pages/account/control_center/history/vendor_history_list_item.dart';
import 'package:nearby_assist/providers/control_center_provider.dart';
import 'package:nearby_assist/providers/user_provider.dart';
import 'package:nearby_assist/pages/account/control_center/history/vendor_history_summary_page.dart';
import 'package:provider/provider.dart';

class VendorHistoryPage extends StatefulWidget {
  const VendorHistoryPage({super.key});

  @override
  State<VendorHistoryPage> createState() => _VendorHistoryPageState();
}

class _VendorHistoryPageState extends State<VendorHistoryPage> {
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
      body: Consumer<ControlCenterProvider>(
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
    return Consumer<UserProvider>(
      builder: (context, provider, _) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ListView.separated(
            separatorBuilder: (context, index) => const Divider(),
            itemCount: requests.length,
            itemBuilder: (context, index) => VendorHistoryListItem(
              booking: requests[index],
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => VendorHistorySummaryPage(
                      booking: requests[index],
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
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
