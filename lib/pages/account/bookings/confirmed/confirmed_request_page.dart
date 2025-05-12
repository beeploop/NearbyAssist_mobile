import 'package:flutter/material.dart';
import 'package:nearby_assist/pages/account/bookings/confirmed/calendar_view_confirmed.dart';
import 'package:nearby_assist/providers/client_booking_provider.dart';
import 'package:provider/provider.dart';

class ConfirmedRequestPage extends StatelessWidget {
  const ConfirmedRequestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ClientBookingProvider>(
      builder: (context, provider, _) {
        return CalendarViewConfirmed(schedules: provider.confirmed);
      },
    );
  }
}
