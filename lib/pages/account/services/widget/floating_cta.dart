import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nearby_assist/models/detailed_service_model.dart';
import 'package:nearby_assist/pages/booking/booking_page.dart';
import 'package:nearby_assist/providers/user_provider.dart';
import 'package:nearby_assist/utils/custom_snackbar.dart';
import 'package:nearby_assist/utils/money_formatter.dart';
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
        height: 40,
        child: Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        if (user.id == details.vendor.id) {
                          showCustomSnackBar(
                            context,
                            "You can't book your own service",
                            backgroundColor: Colors.red,
                            closeIconColor: Colors.white,
                            textColor: Colors.white,
                          );
                          return;
                        }

                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => BookingPage(details: details),
                          ),
                        );
                      },
                      child: const Icon(CupertinoIcons.cart),
                    ),
                  ),
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        if (user.id == details.vendor.id) {
                          showCustomSnackBar(
                            context,
                            "You can't message yourself",
                            backgroundColor: Colors.red,
                            closeIconColor: Colors.white,
                            textColor: Colors.white,
                          );
                          return;
                        }

                        context.pushNamed(
                          'chat',
                          queryParameters: {
                            'recipientId': details.vendor.id,
                            'recipient': details.vendor.name,
                          },
                        );
                      },
                      child: const Icon(CupertinoIcons.ellipses_bubble),
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
