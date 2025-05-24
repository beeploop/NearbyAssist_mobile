import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nearby_assist/models/user_model.dart';
import 'package:nearby_assist/providers/control_center_provider.dart';
import 'package:nearby_assist/utils/show_account_not_vendor_modal.dart';
import 'package:nearby_assist/utils/show_has_pending_application.dart';
import 'package:provider/provider.dart';

class ShopIcon extends StatefulWidget {
  const ShopIcon({super.key, required this.user});

  final UserModel user;

  @override
  State<ShopIcon> createState() => _ShopIconState();
}

class _ShopIconState extends State<ShopIcon> {
  @override
  Widget build(BuildContext context) {
    final count = context.watch<ControlCenterProvider>().requests.length;

    return Stack(
      children: [
        IconButton(
          icon: const Icon(Icons.store, color: Colors.white),
          onPressed: _handlePress,
        ),
        if (count >= 1)
          Positioned(
            top: 6,
            left: 8,
            child: GestureDetector(
              onTap: _handlePress,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red,
                  border: Border.all(
                    color: Colors.red,
                  ),
                ),
                child: Text(
                  '$count',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
      ],
    );
  }

  void _handlePress() {
    if (widget.user.hasPendingApplication) {
      showHasPendingApplication(context);
      return;
    }

    if (!widget.user.isVendor) {
      showAccountNotVendorModal(context);
      return;
    }

    context.pushNamed("controlCenter");
  }
}
