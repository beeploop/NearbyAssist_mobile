import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nearby_assist/models/booking_model.dart';
import 'package:nearby_assist/pages/account/control_center/schedules/list_view_schedules.dart';
import 'package:nearby_assist/pages/account/control_center/schedules/schedule_list_item.dart';
import 'package:nearby_assist/pages/account/control_center/schedules/schedule_summary_page.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarViewSchedules extends StatefulWidget {
  const CalendarViewSchedules({super.key, required this.schedules});

  final List<BookingModel> schedules;

  @override
  State<CalendarViewSchedules> createState() => _CalendarViewSchedulesState();
}

class _CalendarViewSchedulesState extends State<CalendarViewSchedules> {
  final ValueNotifier<List<BookingModel>> _events = ValueNotifier([]);
  CalendarFormat _format = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  late Map<DateTime, List<String>> _bookings;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _bookings = groupSchedules(widget.schedules);
    _events.value = _getEventsForDay(_selectedDay!);
  }

  @override
  void dispose() {
    _events.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant CalendarViewSchedules oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.schedules != widget.schedules) {
      _bookings = groupSchedules(widget.schedules);
      _events.value = _getEventsForDay(_selectedDay!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Schedules',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(CupertinoIcons.list_dash),
            onPressed: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => const ListViewSchedules(),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(DateTime.now().year, DateTime.now().month),
            lastDay: DateTime.now().add(const Duration(days: 30)),
            currentDay: DateTime.now(),
            focusedDay: _focusedDay,
            calendarFormat: _format,
            eventLoader: _getEventsForDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
                _events.value = _getEventsForDay(selectedDay);
              });
            },
            onPageChanged: (focusedDay) {
              setState(() {
                _focusedDay = focusedDay;
              });
            },
            onFormatChanged: (format) {
              setState(() {
                _format = format;
              });
            },
            calendarStyle: CalendarStyle(
              selectedDecoration: BoxDecoration(
                color: Colors.green.shade800,
                shape: BoxShape.circle,
              ),
              todayDecoration: BoxDecoration(
                color: Colors.green.shade200,
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Divider(),
          const SizedBox(height: 10),

          // events
          ValueListenableBuilder(
            valueListenable: _events,
            builder: (context, value, _) {
              return Padding(
                padding: const EdgeInsets.all(10),
                child: ListView.separated(
                  shrinkWrap: true,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 10),
                  itemCount: value.length,
                  itemBuilder: (context, index) => ScheduleListItem(
                    backgroundColor: Colors.green.shade100,
                    booking: value[index],
                    onTap: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => ScheduleSummaryPage(
                            booking: value[index],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Map<DateTime, List<String>> groupSchedules(List<BookingModel> schedules) {
    final Map<DateTime, List<String>> grouped = {};

    for (final schedule in schedules) {
      final start = schedule.scheduleStart;
      final end = schedule.scheduleEnd;
      if (start == null || end == null) continue;

      for (DateTime day = DateTime.utc(start.year, start.month, start.day);
          !day.isAfter(DateTime.utc(end.year, end.month, end.day));
          day = day.add(const Duration(days: 1))) {
        final normalized = DateTime.utc(day.year, day.month, day.day);

        if (grouped.containsKey(normalized)) {
          grouped[normalized]!.add(schedule.id);
        } else {
          grouped[normalized] = [schedule.id];
        }
      }
    }

    return grouped;
  }

  List<BookingModel> _getEventsForDay(DateTime day) {
    final normalizedDay = DateTime.utc(day.year, day.month, day.day);
    final bookingIds = _bookings[normalizedDay];
    if (bookingIds == null) return [];

    return widget.schedules
        .where((booking) => bookingIds.contains(booking.id))
        .toList();
  }
}
