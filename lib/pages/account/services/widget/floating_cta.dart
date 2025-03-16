import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:nearby_assist/models/detailed_service_model.dart';
import 'package:nearby_assist/pages/booking/booking_page.dart';
import 'package:nearby_assist/providers/user_provider.dart';
import 'package:nearby_assist/utils/money_formatter.dart';
import 'package:nearby_assist/utils/restricted_account_modal.dart';
import 'package:provider/provider.dart';

class FloatingCTA extends StatelessWidget {
  const FloatingCTA({super.key, required this.details});

  final DetailedServiceModel details;

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        decoration: const BoxDecoration(color: Colors.white),
        height: 46,
        child: Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        if (user.id == details.vendor.vendorId) return;

                        if (user.isRestricted) {
                          showAccountRestrictedModal(context);
                          return;
                        }

                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => BookingPage(details: details),
                          ),
                        );
                      },
                      child: FaIcon(
                        FontAwesomeIcons.handshakeSimple,
                        color: user.id == details.vendor.vendorId
                            ? Colors.grey
                            : null,
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        if (user.id == details.vendor.vendorId) return;

                        context.pushNamed(
                          'chat',
                          queryParameters: {
                            'recipientId': details.vendor.vendorId,
                            'recipient': details.vendor.name,
                          },
                        );
                      },
                      child: Icon(
                        CupertinoIcons.ellipses_bubble_fill,
                        color: user.id == details.vendor.vendorId
                            ? Colors.grey
                            : null,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.green.shade800,
                ),
                child: Center(
                  child: Text(
                    formatCurrency(details.service.rate),
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
