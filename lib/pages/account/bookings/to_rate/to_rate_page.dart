import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nearby_assist/models/booking_model.dart';
import 'package:nearby_assist/pages/account/bookings/to_rate/rate_page.dart';
import 'package:nearby_assist/pages/account/bookings/to_rate/to_rate_summary_page.dart';
import 'package:nearby_assist/providers/client_booking_provider.dart';
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
      body: Consumer<ClientBookingProvider>(
        builder: (context, provider, _) {
          return RefreshIndicator(
            onRefresh: provider.fetchToRate,
            child: provider.toRate.isEmpty
                ? _emptyState()
                : _buildBody(provider.toRate),
          );
        },
      ),
    );
  }

  Widget _buildBody(List<BookingModel> bookings) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ListView.separated(
        itemCount: bookings.length,
        separatorBuilder: (context, index) => const Divider(),
        itemBuilder: (context, index) => ListTile(
          leading: const Icon(CupertinoIcons.checkmark_circle),
          title: Text(bookings[index].vendor.name),
          subtitle: Text(
            bookings[index].service.title,
            overflow: TextOverflow.ellipsis,
          ),
          onTap: () {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => ToRateSummaryPage(
                  booking: bookings[index],
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
                    booking: bookings[index],
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
