import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:nearby_assist/models/booking_model.dart';
import 'package:nearby_assist/providers/control_center_provider.dart';
import 'package:nearby_assist/utils/date_formatter.dart';
import 'package:nearby_assist/utils/show_generic_error_modal.dart';
import 'package:nearby_assist/utils/show_generic_success_modal.dart';
import 'package:provider/provider.dart';

class Menu extends StatefulWidget {
  const Menu({super.key, required this.booking});

  final BookingModel booking;

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon: const Icon(CupertinoIcons.ellipsis_vertical),
      itemBuilder: (context) => [
        _popupItem(
          context,
          onTap: () => context.pushNamed(
            'chat',
            queryParameters: {
              'recipientId': widget.booking.client.id,
              'recipient': widget.booking.client.name,
            },
          ),
          icon: CupertinoIcons.ellipses_bubble,
          text: 'Message',
        ),
        _popupItem(
          context,
          onTap: () => _showRescheduleModal(context),
          icon: CupertinoIcons.calendar_today,
          text: 'Reschedule',
        ),
      ],
    );
  }

  PopupMenuItem _popupItem(
    BuildContext context, {
    required IconData icon,
    required String text,
    required void Function() onTap,
  }) {
    return PopupMenuItem(
      onTap: onTap,
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.3,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Icon(icon, size: 18),
            const SizedBox(width: 10),
            Text(text),
          ],
        ),
      ),
    );
  }

  void _showRescheduleModal(BuildContext context) {
    final rescheduleController = TextEditingController(
      text: DateFormatter.monthAndDate(widget.booking.scheduledAt!),
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(
          CupertinoIcons.calendar_badge_plus,
          color: Colors.green,
          size: 40,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        title: const Text('Set new date', style: TextStyle(fontSize: 20)),
        content: TextField(
          controller: rescheduleController,
          decoration: const InputDecoration(
            labelText: 'Schedule',
            filled: true,
            prefixIcon: Icon(CupertinoIcons.calendar),
          ),
          readOnly: true,
          onTap: () async {
            DateTime? schedule = await showDatePicker(
                context: context,
                initialDate: DateTime.parse(widget.booking.scheduledAt!),
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(
                  const Duration(days: 30),
                ));

            if (schedule == null) return;

            setState(() {
              rescheduleController.text = schedule.toString().split(" ")[0];
            });
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _rescheduleConfirmation(rescheduleController.text);
            },
            child: const Text('Reschedule'),
          ),
        ],
      ),
    );
  }

  void _rescheduleConfirmation(String schedule) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(
          CupertinoIcons.question_circle,
          color: Colors.amber,
          size: 40,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        title: const Text('Confirm', style: TextStyle(fontSize: 20)),
        content: const Text('Are you sure you want reschedule this booking?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _handleReschedule(widget.booking.id, schedule);
            },
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }

  Future<void> _handleReschedule(String bookingId, String schedule) async {
    final loader = context.loaderOverlay;

    try {
      loader.show();

      await context
          .read<ControlCenterProvider>()
          .reschedule(bookingId, schedule);

      if (!mounted) return;
      showGenericSuccessModal(context, message: 'Booking rescheduled');
    } on DioException catch (error) {
      if (!mounted) return;
      showGenericErrorModal(context, message: error.response?.data['message']);
    } catch (error) {
      if (!mounted) return;
      showGenericErrorModal(context, message: error.toString());
    } finally {
      loader.hide();
    }
  }
}
