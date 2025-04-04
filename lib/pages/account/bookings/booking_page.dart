import 'package:flutter/material.dart';
import 'package:nearby_assist/pages/account/bookings/widget/grid_section.dart';
import 'package:nearby_assist/pages/account/bookings/widget/recent_booking.dart';

class BookingPage extends StatelessWidget {
  const BookingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Bookings',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: const Padding(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              GridSection(),
              SizedBox(height: 20),
              Divider(),
              SizedBox(height: 10),
              RecentBooking(),
            ],
          ),
        ),
      ),
    );
  }
}
