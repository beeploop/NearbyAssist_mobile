import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:nearby_assist/models/booking_model.dart';
import 'package:nearby_assist/pages/account/report/report_user_reason_page.dart';
import 'package:nearby_assist/pages/account/widget/input_field.dart';
import 'package:nearby_assist/providers/client_booking_provider.dart';
import 'package:nearby_assist/utils/show_generic_error_modal.dart';
import 'package:nearby_assist/utils/show_generic_success_modal.dart';
import 'package:provider/provider.dart';

class Menu extends StatefulWidget {
  const Menu({
    super.key,
    required this.booking,
    this.showCancel = true,
  });

  final BookingModel booking;
  final bool showCancel;

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
          onTap: () {
            context.pushNamed(
              'chat',
              queryParameters: {
                'recipientId': widget.booking.vendor.id,
                'recipient': widget.booking.vendor.name,
              },
            );
          },
          icon: CupertinoIcons.ellipses_bubble,
          text: 'Message',
        ),
        _popupItem(
          context,
          onTap: () {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => ReportUserReasonPage(
                  userId: widget.booking.vendor.id,
                  bookingId: widget.booking.id,
                ),
              ),
            );
          },
          icon: CupertinoIcons.nosign,
          text: 'Report user',
        ),
        if (widget.showCancel)
          _popupItem(
            context,
            onTap: () {
              _cancelConfirmation();
            },
            icon: CupertinoIcons.clear_circled,
            text: 'Cancel',
            color: Colors.red,
          ),
      ],
    );
  }

  void _cancelConfirmation() {
    final reason = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(
          CupertinoIcons.question_circle,
          color: Colors.red,
          size: 40,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        title: const Text('Are you sure?'),
        content: InputField(
          controller: reason,
          hintText: 'Reason',
          minLines: 3,
          maxLines: 6,
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.pop();
              _handleCancelBooking(reason.text);
            },
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }

  void _handleCancelBooking(String reason) async {
    final loader = context.loaderOverlay;

    try {
      loader.show();

      if (reason.isEmpty) {
        throw 'Provide reason for cancellation';
      }

      await context
          .read<ClientBookingProvider>()
          .cancelConfirmed(widget.booking.id, reason);

      if (!mounted) return;
      showGenericSuccessModal(context, message: 'Booking cancelled');
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
}
