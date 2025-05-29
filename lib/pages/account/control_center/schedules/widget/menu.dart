import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:nearby_assist/models/booking_model.dart';
import 'package:nearby_assist/models/pricing_type.dart';
import 'package:nearby_assist/pages/account/widget/input_field.dart';
import 'package:nearby_assist/providers/control_center_provider.dart';
import 'package:nearby_assist/utils/is_previous_day.dart';
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
  late DateTimeRange _selectedDates;
  final _scheduleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedDates = DateTimeRange(
      start: widget.booking.scheduleStart!,
      end: widget.booking.scheduleEnd!,
    );

    final start = _selectedDates.start.toString().split(" ")[0];
    final end = _selectedDates.end.toString().split(" ")[0];

    _scheduleController.text = '$start - $end';
  }

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
          onTap: _showRescheduleModal,
          icon: CupertinoIcons.calendar_today,
          text: 'Reschedule',
        ),
        _popupItem(
          context,
          onTap: _showCancelConfirmation,
          icon: CupertinoIcons.clear_circled,
          text: 'Cancel',
          color: Colors.red,
          clickable: isPreviousDay(widget.booking.scheduleStart!),
        ),
      ],
    );
  }

  PopupMenuItem _popupItem(
    BuildContext context, {
    required IconData icon,
    required String text,
    required void Function() onTap,
    bool clickable = true,
    Color? color,
  }) {
    return PopupMenuItem(
      onTap: () {
        if (!clickable) return;
        onTap();
      },
      enabled: clickable,
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.3,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(width: 10),
            Text(
              text,
              style: TextStyle(color: !clickable ? Colors.red.shade200 : color),
            ),
          ],
        ),
      ),
    );
  }

  void _showRescheduleModal() {
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
        title: Text(
          'Set new date',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        content: TextField(
          controller: _scheduleController,
          decoration: const InputDecoration(
            labelText: 'Schedule',
            filled: true,
            prefixIcon: Icon(CupertinoIcons.calendar),
          ),
          readOnly: true,
          onTap: widget.booking.pricingType == PricingType.perDay
              ? _pickDateRange
              : _pickDate,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _rescheduleConfirmation();
            },
            child: const Text('Reschedule'),
          ),
        ],
      ),
    );
  }

  void _rescheduleConfirmation() {
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
        title: Text(
          'Confirm',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        content: const Text('Are you sure you want reschedule this booking?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => _handleReschedule(widget.booking.id),
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }

  void _showCancelConfirmation() {
    final reason = TextEditingController();

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
        title: Text(
          'Cancel this booking?',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        content: InputField(
          controller: reason,
          hintText: 'Reason',
          minLines: 3,
          maxLines: 6,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              _handleCancelBooking(widget.booking.id, reason.text);
            },
            style: ButtonStyle(
              backgroundColor: const WidgetStatePropertyAll(Colors.red),
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }

  Future<void> _handleReschedule(String bookingId) async {
    final loader = context.loaderOverlay;

    try {
      loader.show();
      Navigator.pop(context);

      if (widget.booking.pricingType == PricingType.perDay) {
        // add 1 because inDays counts the next day as day 1
        final days = _selectedDates.duration.inDays + 1;
        if (days > widget.booking.quantity) {
          throw "Range of days selected is greater than the requested duration";
        }
      }

      if (_scheduleController.text.isEmpty) {
        throw 'Invalid schedule';
      }

      final start = _selectedDates.start.toString().split(" ")[0];
      final end = _selectedDates.end.toString().split(" ")[0];

      await context
          .read<ControlCenterProvider>()
          .reschedule(bookingId, start, end);

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

  Future<void> _handleCancelBooking(String bookingId, String reason) async {
    final loader = context.loaderOverlay;

    try {
      loader.show();

      if (reason.isEmpty) {
        throw 'Provide a reason for cancelling this booking';
      }

      await context.read<ControlCenterProvider>().cancel(bookingId, reason);

      if (!mounted) return;
      showGenericSuccessModal(context, message: 'Request cancelled');
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

  Future<void> _pickDate() async {
    DateTime? schedule = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(
        const Duration(days: 30),
      ), // restrict schedule to 30 days advance
      initialEntryMode: DatePickerEntryMode.calendarOnly,
    );

    if (schedule == null) return;

    setState(() {
      _selectedDates = DateTimeRange(
        start: schedule,
        end: schedule,
      );

      final start = _selectedDates.start.toString().split(" ")[0];
      final end = _selectedDates.end.toString().split(" ")[0];

      _scheduleController.text = '$start - $end';
    });
  }

  Future<void> _pickDateRange() async {
    final range = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(
        const Duration(days: 30),
      ), // restrict schedule to 30 days advance
      initialEntryMode: DatePickerEntryMode.calendarOnly,
    );

    if (range == null) return;

    setState(() {
      _selectedDates = range;

      final start = _selectedDates.start.toString().split(" ")[0];
      final end = _selectedDates.end.toString().split(" ")[0];

      _scheduleController.text = '$start - $end';
    });
  }
}
