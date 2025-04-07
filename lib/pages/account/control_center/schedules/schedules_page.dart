import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nearby_assist/models/booking_model.dart';
import 'package:nearby_assist/pages/account/control_center/schedules/schedule_list_item.dart';
import 'package:nearby_assist/pages/account/control_center/schedules/schedule_summary_page.dart';
import 'package:nearby_assist/providers/control_center_provider.dart';
import 'package:provider/provider.dart';

class SchedulesPage extends StatefulWidget {
  const SchedulesPage({super.key});

  @override
  State<SchedulesPage> createState() => _SchedulesPageState();
}

class _SchedulesPageState extends State<SchedulesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Schedules',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Consumer<ControlCenterProvider>(
        builder: (context, provider, _) {
          return RefreshIndicator(
            onRefresh: provider.fetchSchedules,
            child: provider.schedules.isEmpty
                ? _emptyState()
                : _mainContent(provider.schedules),
          );
        },
      ),
    );
  }

  Widget _mainContent(List<BookingModel> requests) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: ListView.separated(
        separatorBuilder: (context, index) => const SizedBox(height: 10),
        itemCount: requests.length,
        itemBuilder: (context, index) => ScheduleListItem(
          booking: requests[index],
          onTap: () {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => ScheduleSummaryPage(
                  booking: requests[index],
                  showChatIcon: true,
                ),
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
                    'No schedules',
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
