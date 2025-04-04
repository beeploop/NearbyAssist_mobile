import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nearby_assist/models/booking_model.dart';
import 'package:nearby_assist/pages/account/bookings/accepted_request_summary_page.dart';
import 'package:nearby_assist/pages/account/bookings/received_request_summary_page.dart';
import 'package:nearby_assist/pages/account/bookings/sent_request_summary_page.dart';
import 'package:nearby_assist/pages/account/bookings/booking_summary_page.dart';
import 'package:nearby_assist/pages/account/bookings/widget/booking_status_chip.dart';
import 'package:nearby_assist/providers/booking_provider.dart';
import 'package:nearby_assist/providers/user_provider.dart';
import 'package:provider/provider.dart';

class RecentBooking extends StatefulWidget {
  const RecentBooking({super.key});

  @override
  State<RecentBooking> createState() => _RecentBookingState();
}

class _RecentBookingState extends State<RecentBooking> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recent Bookings',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        _fetchAndBuildList(),
      ],
    );
  }

  Widget _fetchAndBuildList() {
    return FutureBuilder(
      future: context.read<BookingProvider>().fetchRecent(),
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

        final recents = context.watch<BookingProvider>().recents;
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
          if (recents[index].status == BookingStatus.done) {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) =>
                    BookingSummaryPage(booking: recents[index]),
              ),
            );
            return;
          }

          if (recents[index].client.id == user.id) {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) =>
                    SentRequestSummaryPage(booking: recents[index]),
              ),
            );
            return;
          } else {
            if (recents[index].status == BookingStatus.confirmed) {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) =>
                      AcceptedRequestSummaryPage(booking: recents[index]),
                ),
              );
              return;
            }

            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) =>
                    ReceivedRequestSummaryPage(booking: recents[index]),
              ),
            );
            return;
          }
        },
        dense: true,
        leading: Icon(
          recents[index].client.id == user.id
              ? CupertinoIcons.arrow_up
              : CupertinoIcons.arrow_down,
          color: recents[index].client.id == user.id
              ? Colors.teal.shade400
              : Colors.pink.shade300,
        ),
        title: Text(
          recents[index].client.id == user.id
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
        trailing: BookingStatusChip(status: recents[index].status),
      ),
    );
  }
}
